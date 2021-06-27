// Mocks generated by Mockito 5.0.7 from annotations
// in beam/features/data/beam/testing/test_beam_module.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:beam/features/data/beam/beam_service.dart' as _i3;
import 'package:http/src/response.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: prefer_const_constructors

// ignore_for_file: avoid_redundant_argument_values

class _FakeResponse extends _i1.Fake implements _i2.Response {}

/// A class which mocks [BeamService].
///
/// See the documentation for Mockito's code generation for more information.
class MockBeamService extends _i1.Mock implements _i3.BeamService {
  MockBeamService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Response> get(String? api, {Map<String, String>? headers}) =>
      (super.noSuchMethod(Invocation.method(#get, [api], {#headers: headers}),
              returnValue: Future<_i2.Response>.value(_FakeResponse()))
          as _i4.Future<_i2.Response>);
  @override
  _i4.Future<_i2.Response> post(String? api,
          {Map<String, String>? headers, dynamic body}) =>
      (super.noSuchMethod(
              Invocation.method(#post, [api], {#headers: headers, #body: body}),
              returnValue: Future<_i2.Response>.value(_FakeResponse()))
          as _i4.Future<_i2.Response>);
}