import 'dart:async';

import 'package:beam/features/domain/entities/payment_result.dart';
import 'package:beam/features/domain/usecases/payments_interactor.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/payment.dart';

@injectable
class PaymentsModel extends ChangeNotifier {
  final PaymentsInteractor _paymentsInteractor;
  List<Payment> _payments = [];
  late final StreamSubscription<List<Payment>> _paymentsSubscription;

  PaymentStatus get paymentStatus => _paymentStatus;
  PaymentStatus _paymentStatus = PaymentStatus.DEFAULT;

  int get paymentAmount => _paymentAmount;
  int _paymentAmount = 0;

  bool get isTextFieldEmpty => _isTextFieldEmpty;
  bool _isTextFieldEmpty = true;

  List<Payment> get payments => _payments;

  PaymentsModel(this._paymentsInteractor) {
    _paymentsSubscription =
        _paymentsInteractor.getPayments().listen((payments) {
      _payments = payments;
      notifyListeners();
    });
    _paymentsSubscription.onError((error) {
      _payments = [];
      notifyListeners();
    });
  }

  Future<void> makePayment(int amount) async {
    _paymentStatus = PaymentStatus.IN_PROGRESS;
    notifyListeners();
    final paymentResult = await _paymentsInteractor.makePayment(amount);
    if (paymentResult == PaymentResult.SUCCESS) {
      _paymentStatus = PaymentStatus.SUCCESS;
    } else {
      _paymentStatus = PaymentStatus.FAILURE;
    }
    notifyListeners();
  }

  void onTextFieldChanged(String value) {
    if (value != "") {
      _paymentAmount = int.parse(value);
      _isTextFieldEmpty = false;
    } else {
      _isTextFieldEmpty = true;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _paymentsSubscription.cancel();
    super.dispose();
  }
}

enum PaymentStatus {
  DEFAULT,
  SUCCESS,
  FAILURE,
  IN_PROGRESS,
}
