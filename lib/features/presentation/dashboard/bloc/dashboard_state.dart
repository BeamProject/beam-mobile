import 'package:beam/features/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  final User user;

  const DashboardState(this.user);

  const DashboardState.empty() : this(null);

  @override
  List<Object> get props => [user];
}