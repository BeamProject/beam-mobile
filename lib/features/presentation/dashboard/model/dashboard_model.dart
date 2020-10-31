import 'dart:async';

import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/usecases/get_current_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class DashboardModel extends ChangeNotifier {
  User _user;
  StreamSubscription<User> userSubscription;

  User get user => _user;

  DashboardModel(ObserveUser observeUser) {
    userSubscription = observeUser().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    userSubscription.cancel();
    super.dispose();
  }
}
