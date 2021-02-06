import 'dart:convert';

import 'package:beam/features/data/beam/beam_service_auth_wrapper.dart';
import 'package:beam/features/data/beam/model/payment_mapper.dart';
import 'package:beam/features/data/beam/model/payment_result.dart' as beam;
import 'package:beam/features/data/beam/model/payment.dart' as beam;
import 'package:beam/features/data/datasources/payments_remote_data_source.dart';
import 'package:beam/features/domain/entities/payment.dart';
import 'package:beam/features/domain/entities/payment_request.dart';
import 'package:beam/features/domain/entities/payment_result.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

@injectable
class BeamPaymentRepository implements PaymentsRemoteDataSource {
  static const MAKE_DELAYED_PAYMENT_API = "/payment/delayedpayment";
  static const GET_PAYMENTS_API = "/payment/allpayments";

  final BeamServiceAuthWrapper _beamServiceAuthWrapper;

  BeamPaymentRepository(this._beamServiceAuthWrapper);

  @override
  Future<PaymentResult> makeDelayedPayment(
      PaymentRequest paymentRequest) async {
    final response = await _beamServiceAuthWrapper.post(
        MAKE_DELAYED_PAYMENT_API,
        body: PaymentMapper.mapToBeamPaymentRequest(paymentRequest).toJson());

    if (_isResponseSuccessful(response)) {
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

  @override
  Stream<List<Payment>> getPayments(String userId) async* {
    final response = await _beamServiceAuthWrapper.get(GET_PAYMENTS_API + "/" + userId);

    if (_isResponseSuccessful(response)) {
      final jsonList = json.decode(response.body) as List<dynamic>;
      print(jsonList);
      final List<Payment> payments = jsonList
          .map((jsonPayment) => beam.Payment.fromJson(jsonPayment as Map<String, dynamic>))
          .map((beamPayment) => PaymentMapper.mapToPayment(beamPayment))
          .toList();
      
      yield payments;
    } else {
      throw Exception("Couldn't fetch payments");
    }
  }

  bool _isResponseSuccessful(http.Response response) {
    return response?.statusCode == 200;
  }
}
