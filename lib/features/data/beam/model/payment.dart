import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String userId;
  final int amount;
  final String currency;

  Payment({this.userId, this.amount, this.currency});

  Map<String, dynamic> toJson() {
    return {
      "_id": userId,
      "amount": amount
    };
  }

  @override
  List<Object> get props => [userId, amount, currency];
}