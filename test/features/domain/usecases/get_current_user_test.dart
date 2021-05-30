import 'package:beam/common/di/config.dart';
import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/repositories/testing/fake_user_repository.dart';
import 'package:beam/features/domain/usecases/get_current_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;

void main() {
  final correctUser = User(id: "1", firstName: 'John', lastName: 'Doe');
  late FakeUserRepository fakeUserRepository;

  setUp(() {
    configureDependencies(injectable.Environment.test);
    fakeUserRepository = getIt<FakeUserRepository>();
  });

  tearDown(() {
    getIt.reset();
  });

  test("Emits correct user data", () {
    fakeUserRepository.usersStream = Stream.fromIterable([
      null,
      correctUser,
      User(id: "1", firstName: 'John'),
      User(id: "1", lastName: 'Doe')
    ]);
    final observeUser = getIt<ObserveUser>();

    expect(
        observeUser(), emitsInOrder([null, correctUser, null, null]));
  });
}
