import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class PaymentRequest extends Equatable {
  final String userId;
  final int amount;
  final String currency;

  const PaymentRequest(
      {@required this.userId, this.amount, this.currency = "USD"});

  @override
  List<Object> get props => [userId, amount, currency];
}
