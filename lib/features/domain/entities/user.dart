import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;

  const User(
      {@required this.id, @required this.firstName, @required this.lastName});

  @override
  List<Object> get props => [id];

  bool isValid() {
    return id != null;
  }
}
