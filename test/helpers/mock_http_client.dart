// ignore_for_file: argument_type_not_assignable, avoid_types_on_closure_parameters

import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

/// Helper class for creating mock HTTP clients
///
/// Note: This helper class is provided for convenience but may not be used
/// in all test files. Tests typically use @GenerateMocks directly.
class MockHttpClientHelper {
  /// Create a mock client that returns a successful response
  static http.Client createSuccessClient({
    required String responseBody,
    int statusCode = 200,
    Map<String, String>? headers,
  }) {
    final client = MockClient();
    when(
      client.post(any, headers: anyNamed('headers'), body: anyNamed('body')),
    ).thenAnswer(
      (_) async => http.Response(
        responseBody,
        statusCode,
        headers: headers ?? {'content-type': 'application/json'},
      ),
    );
    return client;
  }

  /// Create a mock client that returns an error response
  static http.Client createErrorClient({
    required int statusCode,
    String responseBody = 'Error',
  }) {
    final client = MockClient();
    when(
      client.post(any, headers: anyNamed('headers'), body: anyNamed('body')),
    ).thenAnswer((_) async => http.Response(responseBody, statusCode));
    return client;
  }

  /// Create a mock client that throws a network exception
  static http.Client createNetworkExceptionClient({
    required Exception exception,
  }) {
    final client = MockClient();
    when(
      client.post(any, headers: anyNamed('headers'), body: anyNamed('body')),
    ).thenThrow(exception);
    return client;
  }

  /// Create a mock client that returns different responses based on request
  static http.Client createConditionalClient({
    required bool Function(Uri uri, Map<String, String>? headers, String? body)
    condition,
    required http.Response Function() successResponse,
    required http.Response Function() errorResponse,
  }) {
    final client = MockClient();
    when(
      client.post(any, headers: anyNamed('headers'), body: anyNamed('body')),
    ).thenAnswer((invocation) async {
      final uri = invocation.positionalArguments[0] as Uri;
      final headers =
          invocation.namedArguments[#headers] as Map<String, String>?;
      final body = invocation.namedArguments[#body] as String?;
      if (condition(uri, headers, body)) {
        return successResponse();
      } else {
        return errorResponse();
      }
    });
    return client;
  }
}

// Mock class for http.Client
// Note: This is a manual mock. Individual test files use @GenerateMocks for their specific mocks.
class MockClient extends Mock implements http.Client {}
