import 'package:material_ui/material_ui.dart';

class UserProfile {
  final String userName;
  final String email;
  final String phoneNumber;
  final String bio;
  final String profileImagePath;

  UserProfile({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.bio,
    required this.profileImagePath,
  });
}

final ValueNotifier<UserProfile?> globalUserNotifier =
    ValueNotifier<UserProfile?>(null);
