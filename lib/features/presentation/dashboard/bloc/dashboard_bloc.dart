import 'dart:async';

import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/usecases/get_current_user.dart';
import 'package:beam/features/presentation/dashboard/bloc/dashboard_event.dart';
import 'package:beam/features/presentation/dashboard/bloc/dashboard_state.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ObserveUser _observeUser;
  StreamSubscription<User> _userDataSubscription;

  DashboardBloc(this._observeUser) : super(DashboardState.empty()) {
    _userDataSubscription = _observeUser().listen((user) {
      add(UserDataChanged(user));
    });
  }

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is UserDataChanged) {
      yield _mapUserDataChangedToState(event);
    }
  }

  DashboardState _mapUserDataChangedToState(UserDataChanged event) {
    return DashboardState(event?.user);
  }

  @override
  Future<void> close() {
    _userDataSubscription?.cancel();
    return super.close();
  }
}