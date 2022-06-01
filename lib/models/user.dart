import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(this.id, this.name, this.displayName, this.token, this.gender,
      this.avatar, this.roles);
  String id;
  String name;
  String? displayName;
  String? token;
  String? gender;
  String? avatar;
  List<String>? roles;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
