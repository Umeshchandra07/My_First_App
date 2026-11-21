import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterRequested extends AuthEvent {
  final String userName;
  final String email;
  final String phoneNumber;
  final String password;
  final String bio;
  final String profile;

  const RegisterRequested({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.bio = '',
    this.profile = '',
  });

  @override
  List<Object?> get props => [userName, email, phoneNumber, password, bio, profile];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
