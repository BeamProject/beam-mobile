import 'package:equatable/equatable.dart';

class PaymentRequest extends Equatable {
  final String userId;
  final int amount;
  final String? currency;

  PaymentRequest({required this.userId, required this.amount, this.currency});

  Map<String, dynamic> toJson() {
    return {
      "_id": userId,
      "amount": amount
    };
  }
  
  @override
  List<Object?> get props => [userId, amount, currency];
}