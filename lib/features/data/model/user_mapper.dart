

import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/data/model/user.dart' as data;

class UserMapper {
  static User mapToUser(data.User user) {
    return User(id: user.id, username: user.username);
  }
}