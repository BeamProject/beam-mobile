import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Payment extends Equatable {
  final String id;
  final String userId;
  final int amount;
  final String currency;

  const Payment(
      {@required this.id,
      @required this.userId,
      this.amount,
      this.currency = "USD"});

  @override
  List<Object> get props => [id, userId, amount, currency];
}
