import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sessions_logger/models/group.dart';

class GroupsProvider extends ChangeNotifier {
  List<Group> _myOwnGroups = [];
  List<Group> _groupsIamParticipated = [];

  List<Group> get myAllGroups {
    return [..._myOwnGroups, ..._groupsIamParticipated];
  }

  List<Group> get myOwnGroups {
    return [..._myOwnGroups];
  }

  Future<void> fetchMyGroups(String userID) async {
    _myOwnGroups.clear();
    _myOwnGroups = [];
    final docs = await Firestore.instance
        .collection('groups')
        .where('creatorID', isEqualTo: userID)
        .getDocuments();
    docs.documents.forEach((doc) {
      _myOwnGroups.add(
        Group(
          id: doc.documentID,
          groupName: doc.data['name'],
          creatorId: doc.data['creatorID'],
          invitationCode: doc.data['invitationCode'],
          description: doc.data['description'],
          photoURL: doc.data['imageUrl'],
        ),
      );
    });
    notifyListeners();
  }

  Future<void> addGroup(String name, String description, String invitationCode,
      File image, String creatorID) async {
    var ref, url;
    if (image != null) {
      ref = FirebaseStorage.instance.ref().child('user_image').child(creatorID);
      await ref.putFile(image).onComplete;
      url = await ref.getDownloadURL();
    } else {
      url = 'assets/images/all-group-placeholder.jpg';
    }

    final doc = await Firestore.instance.collection('groups').add({
      'creatorID': creatorID,
      'name': name,
      'description': description,
      'imageUrl': url,
      'invitationCode': invitationCode
    });

    await Firestore.instance
        .collection('invitationCodes')
        .document(invitationCode)
        .setData({
      'groupID': doc.documentID,
    });

    _myOwnGroups.add(
      Group(
        id: doc.documentID,
        groupName: name,
        creatorId: creatorID,
        invitationCode: invitationCode,
        description: description,
        photoURL: url,
      ),
    );
    notifyListeners();
  }

  Future<String> verifyCode(String code) async {
    final doc = await Firestore.instance
        .collection('invitationCodes')
        .document(code)
        .get();

    if (doc.exists) {
      final gp = await Firestore.instance
          .collection('groups')
          .document(doc.data['groupID'])
          .get();
      return '${doc.data['groupID']}~${gp.data['creatorID']}';
    } else {
      return 'Verified';
    }
  }

  Future<void> sendRequest(String groupID, String userID) async {
    await Firestore.instance
        .collection('groups')
        .document(groupID)
        .collection('invitations')
        .document(userID)
        .setData({
      'date': DateTime.now().toIso8601String(),
    });
  }
}
