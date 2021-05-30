import 'dart:async';

import 'package:beam/features/domain/usecases/payments_interactor.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/payment.dart';

@injectable
class PaymentsModel extends ChangeNotifier {
  final PaymentsInteractor paymentsInteractor;
  List<Payment> _payments = [];
  late final StreamSubscription<List<Payment>> _paymentsSubscription;

  List<Payment> get payments => _payments;

  PaymentsModel(this.paymentsInteractor) {
    _paymentsSubscription = paymentsInteractor.getPayments().listen((payments) {
      _payments = payments;
      notifyListeners();
    });
    _paymentsSubscription.onError((error) {
      _payments = [];
      notifyListeners();
    });
  }
  
  @override
  void dispose() {
    _paymentsSubscription.cancel();
    super.dispose();
  }
}
