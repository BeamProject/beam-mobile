import 'package:beam/features/data/beam/beam_service_auth_wrapper.dart';
import 'package:beam/features/data/datasources/payment_remote_repository.dart';
import 'package:beam/features/data/model/payment.dart';
import 'package:beam/features/domain/entities/payment_result.dart';

class BeamPaymentRepository implements PaymentRemoteRepository {
  static const MAKE_DELAYED_PAYMENT_API = "/payment/delayedpayment";

  final BeamServiceAuthWrapper _beamServiceAuthWrapper;

  BeamPaymentRepository(this._beamServiceAuthWrapper);

  @override
  Future<PaymentResult> makeDelayedPayment(Payment payment) {
    _beamServiceAuthWrapper.post(MAKE_DELAYED_PAYMENT_API,
        body: payment.toJson());
  }
}
