import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';
import 'package:beam/features/domain/usecases/get_current_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

final correctUser = User(id: "1", firstName: 'John', lastName: 'Doe');

class FakeUserRepository extends Fake implements UserRepository {
  @override
  Stream<User> observeUser() {
    return Stream.fromIterable([
      null,
      correctUser,
      User(id: "1", firstName: 'John'),
      User(id: "1", lastName: 'Doe'),
      User(firstName: 'John', lastName: 'Doe')
    ]);
  }
}

void main() {
  test("Emits correct user data", () {
    final getCurrentUser = ObserveUser(FakeUserRepository());

    expect(
        getCurrentUser(), emitsInOrder([null, correctUser, null, null, null]));
  });
}
