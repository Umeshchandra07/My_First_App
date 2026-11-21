import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_application_1/auth_bloc.dart';
import 'package:flutter_application_1/auth_repository.dart';
import 'package:flutter_application_1/user_model.dart';

class MockAuthRepository extends Mock implements AuthRepository {
  @override
  Future<bool> registerUser(UserProfile? user) =>
      (super.noSuchMethod(
        Invocation.method(#registerUser, [user]),
        returnValue: Future<bool>.value(true),
        returnValueForMissingStub: Future<bool>.value(true),
      ) as Future<bool>);
}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthBloc authBloc;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(authRepository: mockAuthRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  final testUser = UserProfile(
    userName: 'JohnDoe',
    email: 'john@example.com',
    phoneNumber: '1234567890',
    bio: 'Flutter Dev',
    profileImagePath: 'assets/avatar.png',
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthSuccess] when registration succeeds',
    build: () {
      when(mockAuthRepository.registerUser(testUser))
          .thenAnswer((_) async => true);
      return authBloc;
    },
    act: (bloc) => bloc.add(RegisterRequested(testUser)),
    expect: () => [
      AuthLoading(),
      AuthSuccess(testUser),
    ],
  );
}
