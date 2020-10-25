import 'package:beam/features/domain/repositories/payment_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

@singleton
class MockPaymentRepository extends Mock implements PaymentRepository {}