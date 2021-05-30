import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String userId;
  final int amount;
  final String? currency;
  final DateTime transactionDate;

  const Payment(
      {required this.id,
      required this.userId,
      required this.amount,
      this.currency = "USD",
      required this.transactionDate});

  @override
  List<Object?> get props => [id, userId, amount, currency, transactionDate];
}
