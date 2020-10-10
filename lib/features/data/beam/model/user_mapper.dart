import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/data/beam/model/user.dart' as beam;

class UserMapper {
  static User mapFromBeamUser(beam.User user) {
    return User(
        id: user.id, firstName: user.firstName, lastName: user.lastName);
  }
}
