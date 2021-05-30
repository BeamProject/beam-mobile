import 'package:beam/features/data/beam/testing/test_beam_module.mocks.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/annotations.dart';

import '../beam_service.dart';

@module
@GenerateMocks([BeamService])
abstract class TestBeamModule {
  @Singleton(env: [Environment.test])
  MockBeamService get mockBeamService;

  @Injectable(env: [Environment.test])
  BeamService beamService(MockBeamService mockBeamService) => mockBeamService;
}
