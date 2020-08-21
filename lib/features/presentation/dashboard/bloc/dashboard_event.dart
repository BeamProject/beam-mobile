import 'package:beam/features/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class UserDataChanged extends DashboardEvent {
  final User user;

  const UserDataChanged(this.user);

  @override
  List<Object> get props => [user];
}