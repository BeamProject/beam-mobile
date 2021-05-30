import 'package:equatable/equatable.dart';

class PaymentRequest extends Equatable {
  final String userId;
  final int amount;
  final String currency;

  const PaymentRequest(
      {required this.userId, required this.amount, this.currency = "USD"});

  @override
  List<Object> get props => [userId, amount, currency];
}
