class UserModel {
  final String uid;
  final String username;
  final String email;
  final String? displayName;
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  // For when you integrate with the real API
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}
