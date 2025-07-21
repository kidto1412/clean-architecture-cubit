import 'package:analytic_invest/features/register/domain/entities/user.dart';

class RegisterModel extends User {
  RegisterModel(
      {super.id,
      required super.name,
      required super.username,
      required super.password,
      required super.email,
      super.photo_profile,
      super.created_at,
      super.updated_at});

  factory RegisterModel.formJson(Map<String, dynamic> json) {
    return RegisterModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      photo_profile: json['photo_profile'] ?? "",
      created_at: DateTime.parse(json['created_at'] ?? ''),
      updated_at: DateTime.parse(json['updated_at'] ?? ''),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "name": name,
      "email": email,
    };
  }
}
