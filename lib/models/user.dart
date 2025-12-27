import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// User model example
/// To generate JSON serialization code, run:
/// flutter pub run build_runner build --delete-conflicting-outputs
@JsonSerializable()
class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
