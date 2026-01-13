import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:magento_storefront_flutter/core/magento_client.dart';
import 'package:magento_storefront_flutter/core/magento_config.dart';
import 'package:magento_storefront_flutter/core/magento_exception.dart';
import 'package:magento_storefront_flutter/core/graphql_interceptor.dart';

import 'magento_client_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MagentoConfig config;
  late MockClient mockHttpClient;

  setUp(() {
    config = MagentoConfig(
      baseUrl: 'https://test.magento.com',
      enableDebugLogging: false,
    );
    mockHttpClient = MockClient();
  });

  tearDown(() {
    reset(mockHttpClient);
  });

  group('MagentoClient initialization', () {
    test('should initialize with config', () {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      expect(client.config, config);
      expect(client.authToken, isNull);
    });

    test('should initialize with interceptor', () {
      final interceptor = GraphQLInterceptor();
      final client = MagentoClient(
        config: config,
        interceptor: interceptor,
        httpClient: mockHttpClient,
      );

      expect(client.config, config);
    });

    test('should initialize with custom HTTP client', () {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      expect(client.config, config);
    });
  });

  group('setAuthToken and authToken', () {
    test('should set and get auth token', () {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      expect(client.authToken, isNull);

      client.setAuthToken('test-token');
      expect(client.authToken, 'test-token');

      client.setAuthToken(null);
      expect(client.authToken, isNull);
    });
  });

  group('query method', () {
    test('should execute successful query with debug logging enabled', () async {
      final debugConfig = MagentoConfig(
        baseUrl: 'https://test.magento.com',
        enableDebugLogging: true,
      );
      final client = MagentoClient(
        config: debugConfig,
        httpClient: mockHttpClient,
      );

      final responseData = {
        'data': {'test': 'value'},
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(responseData),
            200,
            headers: {'content-type': 'application/json'},
          ));

      final result = await client.query('query { test }');

      expect(result, responseData);
    });

    test('should execute successful query', () async {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      final responseData = {
        'data': {'test': 'value'},
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(responseData),
            200,
            headers: {'content-type': 'application/json'},
          ));

      final result = await client.query('query { test }');

      expect(result, responseData);
      verify(mockHttpClient.post(
        Uri.parse('https://test.magento.com/graphql'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    test('should execute query with variables', () async {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      final responseData = {
        'data': {'test': 'value'},
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(responseData),
            200,
            headers: {'content-type': 'application/json'},
          ));

      final variables = {'key': 'value'};
      final result = await client.query(
        'query { test }',
        variables: variables,
      );

      expect(result, responseData);
      final captured = verify(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: captureAnyNamed('body'),
      )).captured;

      final body = jsonDecode(captured[0] as String) as Map<String, dynamic>;
      expect(body['variables'], variables);
    });

    test('should execute query with additional headers', () async {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      final responseData = {
        'data': {'test': 'value'},
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(responseData),
            200,
            headers: {'content-type': 'application/json'},
          ));

      final additionalHeaders = {'X-Custom': 'header'};
      await client.query(
        'query { test }',
        additionalHeaders: additionalHeaders,
      );

      final captured = verify(mockHttpClient.post(
        any,
        headers: captureAnyNamed('headers'),
        body: anyNamed('body'),
      )).captured;

      final headers = captured[0] as Map<String, String>;
      expect(headers['X-Custom'], 'header');
    });

    test('should include auth token in headers when set', () async {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      client.setAuthToken('test-token');

      final responseData = {
        'data': {'test': 'value'},
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(responseData),
            200,
            headers: {'content-type': 'application/json'},
          ));

      await client.query('query { test }');

      final captured = verify(mockHttpClient.post(
        any,
        headers: captureAnyNamed('headers'),
        body: anyNamed('body'),
      )).captured;

      final headers = captured[0] as Map<String, String>;
      expect(headers['Authorization'], 'Bearer test-token');
    });

    test('should use interceptor to modify query', () async {
      final interceptor = CustomInterceptor();
      final client = MagentoClient(
        config: config,
        interceptor: interceptor,
        httpClient: mockHttpClient,
      );

      final responseData = {
        'data': {'test': 'value'},
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(responseData),
            200,
            headers: {'content-type': 'application/json'},
          ));

      await client.query('query { test }');

      final captured = verify(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: captureAnyNamed('body'),
      )).captured;

      final body = jsonDecode(captured[0] as String) as Map<String, dynamic>;
      expect(body['query'], 'query { test } # modified');
    });

    test('should use interceptor to modify variables', () async {
      final interceptor = CustomInterceptor();
      final client = MagentoClient(
        config: config,
        interceptor: interceptor,
        httpClient: mockHttpClient,
      );

      final responseData = {
        'data': {'test': 'value'},
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(responseData),
            200,
            headers: {'content-type': 'application/json'},
          ));

      await client.query('query { test }', variables: {'key': 'value'});

      final captured = verify(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: captureAnyNamed('body'),
      )).captured;

      final body = jsonDecode(captured[0] as String) as Map<String, dynamic>;
      expect(body['variables'], isNotNull);
    });

    test('should use interceptor to modify headers', () async {
      final interceptor = CustomInterceptor();
      final client = MagentoClient(
        config: config,
        interceptor: interceptor,
        httpClient: mockHttpClient,
      );

      final responseData = {
        'data': {'test': 'value'},
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(responseData),
            200,
            headers: {'content-type': 'application/json'},
          ));

      await client.query('query { test }');

      verify(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });

    test('should use interceptor to modify response', () async {
      final interceptor = CustomInterceptor();
      final client = MagentoClient(
        config: config,
        interceptor: interceptor,
        httpClient: mockHttpClient,
      );

      final responseData = {
        'data': {'test': 'value'},
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(responseData),
            200,
            headers: {'content-type': 'application/json'},
          ));

      final result = await client.query('query { test }');

      expect(result, responseData);
    });

    test('should handle HTTP 401 error', () async {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Unauthorized', 401));

      await expectLater(
        client.query('query { test }'),
        throwsA(isA<MagentoAuthenticationException>()),
      );
    });

    test('should handle HTTP 403 error', () async {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Forbidden', 403));

      await expectLater(
        client.query('query { test }'),
        throwsA(isA<MagentoAuthenticationException>()),
      );
    });

    test('should handle HTTP 500 error', () async {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Server Error', 500));

      await expectLater(
        client.query('query { test }'),
        throwsA(isA<MagentoNetworkException>()),
      );
    });

    test('should handle HTTP 502 error', () async {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Bad Gateway', 502));

      await expectLater(
        client.query('query { test }'),
        throwsA(isA<MagentoNetworkException>()),
      );
    });

    test('should handle HTTP 404 error', () async {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      await expectLater(
        client.query('query { test }'),
        throwsA(isA<MagentoNetworkException>()),
      );
    });

    test('should handle GraphQL errors', () async {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      final errorResponse = {
        'errors': [
          {'message': 'GraphQL error'},
        ],
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(errorResponse),
            200,
            headers: {'content-type': 'application/json'},
          ));

      await expectLater(
        client.query('query { test }'),
        throwsA(isA<MagentoGraphQLException>()),
      );
    });

    test('should handle GraphQL errors with locations and path', () async {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      final errorResponse = {
        'errors': [
          {
            'message': 'GraphQL error',
            'locations': [{'line': 1, 'column': 5}],
            'path': ['field1', 'field2'],
          },
        ],
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(errorResponse),
            200,
            headers: {'content-type': 'application/json'},
          ));

      await expectLater(
        client.query('query { test }'),
        throwsA(isA<MagentoGraphQLException>()),
      );
    });

    test('should handle GraphQL errors with extensions', () async {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      final errorResponse = {
        'errors': [
          {
            'message': 'GraphQL error',
            'extensions': {'code': 'ERROR_CODE'},
          },
        ],
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(errorResponse),
            200,
            headers: {'content-type': 'application/json'},
          ));

      await expectLater(
        client.query('query { test }'),
        throwsA(isA<MagentoGraphQLException>()),
      );
    });

    test('should handle network exception', () async {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenThrow(http.ClientException('Connection failed'));

      expect(
        () => client.query('query { test }'),
        throwsA(isA<MagentoNetworkException>()),
      );
    });

    test('should handle timeout', () async {
      final timeoutConfig = MagentoConfig(
        baseUrl: 'https://test.magento.com',
        timeoutSeconds: 1,
      );
      final client = MagentoClient(
        config: timeoutConfig,
        httpClient: mockHttpClient,
      );

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => Future.delayed(
            const Duration(seconds: 2),
            () => http.Response('{}', 200),
          ));

      await expectLater(
        client.query('query { test }'),
        throwsA(isA<MagentoNetworkException>()),
      );
    });

    test('should call interceptor onError when error occurs', () async {
      final interceptor = CustomInterceptor();
      final client = MagentoClient(
        config: config,
        interceptor: interceptor,
        httpClient: mockHttpClient,
      );

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Error', 500));

      try {
        await client.query('query { test }');
      } catch (e) {
        // Expected
      }

      expect(interceptor.errorHandled, true);
    });
  });

  group('mutate method', () {
    test('should delegate to query method', () async {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      final responseData = {
        'data': {'result': 'success'},
      };

      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode(responseData),
            200,
            headers: {'content-type': 'application/json'},
          ));

      final result = await client.mutate('mutation { update }');

      expect(result, responseData);
    });
  });

  group('dispose method', () {
    test('should close HTTP client', () {
      final client = MagentoClient(
        config: config,
        httpClient: mockHttpClient,
      );

      client.dispose();

      verify(mockHttpClient.close()).called(1);
    });
  });
}

// Custom interceptor for testing
class CustomInterceptor extends GraphQLInterceptor {
  bool errorHandled = false;

  @override
  String? interceptQuery(String query, Map<String, dynamic>? variables) {
    return '$query # modified';
  }

  @override
  Map<String, dynamic>? interceptVariables(
    String query,
    Map<String, dynamic>? variables,
  ) {
    if (variables == null) return null;
    return {
      ...variables,
      'modified': true,
    };
  }

  @override
  Map<String, String>? interceptHeaders(
    String query,
    Map<String, dynamic>? variables,
    Map<String, String> headers,
  ) {
    return {
      ...headers,
      'X-Custom': 'header',
    };
  }

  @override
  Map<String, dynamic>? interceptResponse(Map<String, dynamic> response) {
    return {
      ...response,
      'modified': true,
    };
  }

  @override
  void onError(dynamic error) {
    errorHandled = true;
  }
}

// Interceptor that returns null for all methods
class NullReturningInterceptor extends GraphQLInterceptor {
  @override
  String? interceptQuery(String query, Map<String, dynamic>? variables) {
    return null;
  }

  @override
  Map<String, dynamic>? interceptVariables(
    String query,
    Map<String, dynamic>? variables,
  ) {
    return null;
  }

  @override
  Map<String, String>? interceptHeaders(
    String query,
    Map<String, dynamic>? variables,
    Map<String, String> headers,
  ) {
    return null;
  }

  @override
  Map<String, dynamic>? interceptResponse(Map<String, dynamic> response) {
    return null;
  }
}
