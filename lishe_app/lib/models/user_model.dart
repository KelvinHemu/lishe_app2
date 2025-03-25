class UserModel {
  final String uid;
  final String username;
  final String phoneNumber;
  final String? displayName;
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    this.displayName,
    this.photoUrl,
  });

  // For when you integrate with the real API
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['email'] ?? '',
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': phoneNumber,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}
