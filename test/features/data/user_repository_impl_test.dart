import 'package:beam/features/data/datasources/user_local_data_source.dart';
import 'package:beam/features/data/datasources/user_remote_data_source.dart';
import 'package:beam/features/data/model/user.dart';
import 'package:beam/features/data/model/user_mapper.dart';
import 'package:beam/features/data/user_repository_impl.dart';
import 'package:beam/features/domain/entities/login_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

void main() {
  group('login user', () {
    UserLocalDataSource userLocalDataSource;
    UserRemoteDataSource userRemoteDataSource;
    setUp(() {
      userLocalDataSource = MockUserLocalDataSource();
      userRemoteDataSource = MockUserRemoteDataSource();
    });

    group('remote source returns the user', () {
      const testUser = const User(id: 1, username: 'john@', authToken: 'token');
      setUp(() {
        when(userRemoteDataSource.logInWithEmailAndPassword('John', 'pass'))
            .thenAnswer((_) async => testUser);
      });

      test('return SUCCESS', () {
        final userRepository =
            UserRepositoryImpl(userLocalDataSource, userRemoteDataSource);

        expect(userRepository.logInWithEmailAndPassword('John', 'pass'),
            completion(equals(LoginResult.SUCCESS)));
      });

      test('updates local data source', () async {
        final userRepository =
            UserRepositoryImpl(userLocalDataSource, userRemoteDataSource);

        await userRepository.logInWithEmailAndPassword('John', 'pass');

        verify(userLocalDataSource.updateUser(testUser));
      });

      test('emits User', () async {
        final userRepository =
            UserRepositoryImpl(userLocalDataSource, userRemoteDataSource);

        await userRepository.logInWithEmailAndPassword('John', 'pass');

        expect(userRepository.observeUser(), emits(UserMapper.mapToUser(testUser)));
      });
    });
  });
}
