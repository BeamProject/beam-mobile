import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/datasources/testing/datasources_module.mocks.dart';
import 'package:beam/features/data/payment_repository_impl.dart';
import 'package:beam/features/domain/entities/payment.dart';
import 'package:beam/features/domain/entities/payment_request.dart';
import 'package:beam/features/domain/entities/payment_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:mockito/mockito.dart';

void main() {
  late MockPaymentsRemoteDataSource mockPaymentRemoteRepository;
  late MockPaymentsLocalDataSource mockPaymentsLocalDataSource;

  setUp(() {
    configureDependencies(injectable.Environment.test);
    mockPaymentRemoteRepository = getIt<MockPaymentsRemoteDataSource>();
    mockPaymentsLocalDataSource = getIt<MockPaymentsLocalDataSource>();
  });

  tearDown(() {
    getIt.reset();
  });

  test('make delayed payment', () {
    final paymentRepositoryImpl = getIt<PaymentRepositoryImpl>();
    final payment = PaymentRequest(userId: "1", amount: 10, currency: "USD");
    when(mockPaymentRemoteRepository.makeDelayedPayment(any))
        .thenAnswer((_) => Future.value(PaymentResult.SUCCESS));

    paymentRepositoryImpl.makeDelayedPayment(payment);

    verify(mockPaymentRemoteRepository.makeDelayedPayment(payment));
  });

  test('get payments, disk cache up to date', () async {
    final paymentRepositoryImpl = getIt<PaymentRepositoryImpl>();
    final payments = TimestampedPayments([
      Payment(
          id: "4",
          userId: "1",
          currency: "USD",
          amount: 6,
          transactionDate: DateTime.utc(2021, 06, 13)),
      Payment(
          id: "5",
          userId: "1",
          currency: "USD",
          amount: 2,
          transactionDate: DateTime.utc(2021, 06, 15)),
    ], DateTime.now().millisecondsSinceEpoch);
    when(mockPaymentsLocalDataSource.getPayments())
        .thenAnswer((_) => Future.value(payments));

    await expectLater(paymentRepositoryImpl.getPayments("test_user_id"),
        emits(payments.payments));
  });

  test('get payments, disk cache up to date, do not hit the network', () async {
    final paymentRepositoryImpl = getIt<PaymentRepositoryImpl>();
    final payments = TimestampedPayments([
      Payment(
          id: "4",
          userId: "1",
          currency: "USD",
          amount: 6,
          transactionDate: DateTime.utc(2021, 06, 13)),
      Payment(
          id: "5",
          userId: "1",
          currency: "USD",
          amount: 2,
          transactionDate: DateTime.utc(2021, 06, 15)),
    ], DateTime.now().millisecondsSinceEpoch);
    when(mockPaymentsLocalDataSource.getPayments())
        .thenAnswer((_) => Future.value(payments));

    await expectLater(paymentRepositoryImpl.getPayments("test_user_id"),
        emits(payments.payments));

    verifyNever(mockPaymentRemoteRepository.getPayments(any));
  });

  test('get payments, disk cache stale, fetch from network', () async {
    final paymentRepositoryImpl = getIt<PaymentRepositoryImpl>();
    final payments = TimestampedPayments(
        [
          Payment(
              id: "5",
              userId: "1",
              currency: "USD",
              amount: 2,
              transactionDate: DateTime.utc(2021, 06, 15)),
        ],
        DateTime.now()
            .subtract(
                Duration(milliseconds: PaymentRepositoryImpl.PAYMENT_STALE_MS))
            .subtract(Duration(minutes: 1))
            .millisecondsSinceEpoch);
    final freshPayments = TimestampedPayments([
      Payment(
          id: "4",
          userId: "1",
          currency: "USD",
          amount: 6,
          transactionDate: DateTime.utc(2021, 06, 13)),
      Payment(
          id: "5",
          userId: "1",
          currency: "USD",
          amount: 2,
          transactionDate: DateTime.utc(2021, 06, 15)),
    ], DateTime.now().millisecondsSinceEpoch);
    when(mockPaymentsLocalDataSource.getPayments())
        .thenAnswer((_) => Future.value(payments));
    when(mockPaymentRemoteRepository.getPayments(any))
        .thenAnswer((_) => Future.value(freshPayments.payments));

    await expectLater(paymentRepositoryImpl.getPayments("test_user_id"),
        emits(freshPayments.payments));
  });

  test('get payments, disk cache stale, network fails, fall back to disk',
      () async {
    final paymentRepositoryImpl = getIt<PaymentRepositoryImpl>();
    final payments = TimestampedPayments(
        [
          Payment(
              id: "5",
              userId: "1",
              currency: "USD",
              amount: 2,
              transactionDate: DateTime.utc(2021, 06, 15)),
        ],
        DateTime.now()
            .subtract(
                Duration(milliseconds: PaymentRepositoryImpl.PAYMENT_STALE_MS))
            .subtract(Duration(minutes: 1))
            .millisecondsSinceEpoch);
    when(mockPaymentsLocalDataSource.getPayments())
        .thenAnswer((_) => Future.value(payments));
    when(mockPaymentRemoteRepository.getPayments(any))
        .thenAnswer((_) => Future.error("Failed to fetch data"));

    await expectLater(paymentRepositoryImpl.getPayments("test_user_id"),
        emits(payments.payments));
  });
}
