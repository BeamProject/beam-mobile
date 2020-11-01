import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String userId;
  final int amount;
  final String currency;

  Payment({this.id, this.userId, this.amount, this.currency});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
        id: json["_id"], userId: json["userId"], amount: json["amount"]);
  }

  @override
  List<Object> get props => [id, userId, amount, currency];
}
