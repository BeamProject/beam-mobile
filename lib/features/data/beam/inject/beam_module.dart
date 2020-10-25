import 'package:beam/features/data/beam/beam_payment_repository.dart';
import 'package:beam/features/data/beam/beam_user_repository.dart';
import 'package:beam/features/data/datasources/payment_remote_repository.dart';
import 'package:beam/features/data/datasources/user_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@module
abstract class BeamModule {
  @Injectable(env: [Environment.prod])
  PaymentRemoteRepository paymentRemoteRepository(
          BeamPaymentRepository beamPaymentRepository) =>
      beamPaymentRepository;

  @Injectable(env: [Environment.prod])
  UserRemoteDataSource userRemoteDataSource(
          BeamUserRepository beamUserRepository) =>
      beamUserRepository;
}
