import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  final String username;

  const DashboardState(this.username);

  const DashboardState.empty() : this(null);

  @override
  List<Object> get props => [username];
}