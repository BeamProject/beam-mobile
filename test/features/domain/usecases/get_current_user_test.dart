import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/repositories/user_repository.dart';
import 'package:beam/features/domain/usecases/get_current_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

final testUser = User(id: "1", firstName: 'John Doe');

class FakeUserRepository extends Fake implements UserRepository {
  @override
  Stream<User> observeUser() {
    return Stream.fromIterable([null, testUser]);
  }
}

void main() {
  test("Emits correct user data", () {
    final getCurrentUser = ObserveUser(FakeUserRepository());

    expect(getCurrentUser(), emitsInOrder([
      null,
      testUser,
    ]));
  });
}