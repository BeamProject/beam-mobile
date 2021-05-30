import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/datasources/testing/datasources_module.mocks.dart';
import 'package:beam/features/data/user_repository_impl.dart';
import 'package:beam/features/domain/entities/login_result.dart';
import 'package:beam/features/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:mockito/mockito.dart';

void main() {
  group('login user', () {
    late MockUserLocalDataSource mockUserLocalDataSource;
    late MockUserRemoteDataSource mockUserRemoteDataSource;

    setUp(() {
      configureDependencies(injectable.Environment.test);
      mockUserLocalDataSource = getIt<MockUserLocalDataSource>();
      mockUserRemoteDataSource = getIt<MockUserRemoteDataSource>();
    });

    tearDown(() {
      getIt.reset();
    });

    group('remote source returns the user', () {
      const testUser = const User(id: "1", firstName: 'john@');
      setUp(() {
        when(mockUserRemoteDataSource.logIn('John', 'pass'))
            .thenAnswer((_) async => LoginResult.SUCCESS);
        when(mockUserRemoteDataSource.getUser())
            .thenAnswer((_) async => testUser);
      });

      test('return SUCCESS', () {
        final userRepository = getIt<UserRepositoryImpl>();

        expect(userRepository.logIn('John', 'pass'),
            completion(equals(LoginResult.SUCCESS)));
      });

      test('updates local data source', () async {
        final userRepository = getIt<UserRepositoryImpl>();

        await userRepository.logIn('John', 'pass');

        verify(mockUserLocalDataSource.updateUser(testUser));
      });

      test('emits User', () async {
        final userRepository = getIt<UserRepositoryImpl>();

        await userRepository.logIn('John', 'pass');

        expect(userRepository.observeUser(), emits(testUser));
      });
    });
  });
}
