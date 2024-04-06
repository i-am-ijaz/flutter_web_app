class UserModel {
  final String? password, uid;
  final String email, name, role;

  UserModel({
    required this.email,
    this.password,
    this.uid,
    required this.name,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      uid: json['uid'],
      name: json['name'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'uid': uid,
        'name': name,
        'role': role,
      };
}
