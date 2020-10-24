import 'dart:convert';

import 'package:beam/features/data/beam/beam_service_auth_wrapper.dart';
import 'package:beam/features/data/beam/model/payment_mapper.dart';
import 'package:beam/features/data/beam/model/payment_result.dart' as beam;
import 'package:beam/features/data/datasources/payment_remote_repository.dart';
import 'package:beam/features/domain/entities/payment.dart';
import 'package:beam/features/domain/entities/payment_result.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PaymentRemoteRepository)
class BeamPaymentRepository implements PaymentRemoteRepository {
  static const MAKE_DELAYED_PAYMENT_API = "/payment/delayedpayment";

  final BeamServiceAuthWrapper _beamServiceAuthWrapper;

  BeamPaymentRepository(this._beamServiceAuthWrapper);

  @override
  Future<PaymentResult> makeDelayedPayment(Payment payment) async {
    final response = await _beamServiceAuthWrapper.post(
        MAKE_DELAYED_PAYMENT_API,
        body: PaymentMapper.mapToBeamPayment(payment).toJson());

    if (response?.statusCode == 200) {
      final result = beam.PaymentResult.fromJson(json.decode(response.body));
      return result.success == true
          ? PaymentResult.SUCCESS
          : PaymentResult.ERROR_UNKNOWN;
    }

    if (response?.statusCode == 401) {
      return PaymentResult.ERROR_INVALID_USER;
    }

    return PaymentResult.ERROR_UNKNOWN;
  }
}
