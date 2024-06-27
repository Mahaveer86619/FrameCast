class UserModel {// not keeping updated at and just sending it through the repository
  final String id;
  final String username;
  final String email;
  final String avatarUrl;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarUrl,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        email = json['email'],
        avatarUrl = json['avatar_url'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'avatar_url': avatarUrl,
      };
  
  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, avatarUrl: $avatarUrl)';
  }
}
