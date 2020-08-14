import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class User extends Equatable {
  final String username;
  final int id;

  const User({@required this.id, @required this.username});

  @override
  List<Object> get props => [id];
}
