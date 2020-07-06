class User {
  final String email, userID;
  String username;
  User(this.email, this.userID) {
    username = email.split('@')[0];
  }
}
