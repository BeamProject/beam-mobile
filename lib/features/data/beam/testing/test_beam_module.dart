import 'package:beam/features/data/beam/testing/mock_beam_service.dart';
import 'package:injectable/injectable.dart';

import '../beam_service.dart';

@module
abstract class TestBeamModule {
  @Injectable(env: [Environment.test])
  BeamService beamService(MockBeamService mockBeamService) => mockBeamService;
}
