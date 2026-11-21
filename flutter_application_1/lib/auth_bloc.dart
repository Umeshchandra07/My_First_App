import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'auth_repository.dart';
import 'user_model.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterRequested extends AuthEvent {
  final UserProfile user;
  RegisterRequested(this.user);

  @override
  List<Object?> get props => [user];
}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final UserProfile user;
  AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final success = await authRepository.registerUser(event.user);
        if (success) {
          emit(AuthSuccess(event.user));
        } else {
          emit(AuthFailure("Registration failed"));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
