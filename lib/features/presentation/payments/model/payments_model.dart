import 'dart:async';

import 'package:beam/features/domain/usecases/get_payments.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/payment.dart';

@injectable
class PaymentsModel extends ChangeNotifier {
  final GetPayments getPayments;
  List<Payment> _payments = [];
  StreamSubscription<List<Payment>> paymentsSubscription;

  List<Payment> get payments => _payments;

  PaymentsModel(this.getPayments) {
    paymentsSubscription = getPayments().listen((payments) {
      _payments = payments;
      notifyListeners();
    });
  }
  
  @override
  void dispose() {
    paymentsSubscription.cancel();
    super.dispose();
  }
}
