import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String userId;
  final int amount;
  final String? currency;
  final DateTime transactionDate;

  Payment(
      {required this.id, required this.userId, required this.amount, this.currency, required this.transactionDate});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
        id: json["_id"],
        userId: json["userId"],
        amount: json["amount"],
        transactionDate: DateTime.parse(json["transactionDate"]));
  }

  @override
  List<Object?> get props => [id, userId, amount, currency, transactionDate];
}
