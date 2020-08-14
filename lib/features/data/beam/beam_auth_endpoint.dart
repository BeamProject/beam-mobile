import 'package:beam/features/data/datasources/user_remote_data_source.dart';
import 'package:beam/features/data/model/user.dart';

class BeamAuthEndpoint implements UserRemoteDataSource {
  
  @override
  Future<User> logInWithEmailAndPassword(
      String username, String password) async {
    return Future.delayed(const Duration(seconds: 1),
        () => User(username: username, id: 1, authToken: 'zxcdefdfs'));
  }
}
