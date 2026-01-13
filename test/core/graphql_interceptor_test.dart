import 'package:flutter_test/flutter_test.dart';
import 'package:magento_storefront_flutter/core/graphql_interceptor.dart';
import 'package:magento_storefront_flutter/core/magento_exception.dart';

void main() {
  group('GraphQLInterceptor', () {
    test('should return null for interceptQuery by default', () {
      final interceptor = GraphQLInterceptor();
      final query = 'query { test }';
      final variables = {'key': 'value'};

      final result = interceptor.interceptQuery(query, variables);

      expect(result, isNull);
    });

    test('should return null for interceptVariables by default', () {
      final interceptor = GraphQLInterceptor();
      final query = 'query { test }';
      final variables = {'key': 'value'};

      final result = interceptor.interceptVariables(query, variables);

      expect(result, isNull);
    });

    test('should return null for interceptHeaders by default', () {
      final interceptor = GraphQLInterceptor();
      final query = 'query { test }';
      final variables = {'key': 'value'};
      final headers = {'Content-Type': 'application/json'};

      final result = interceptor.interceptHeaders(query, variables, headers);

      expect(result, isNull);
    });

    test('should return null for interceptResponse by default', () {
      final interceptor = GraphQLInterceptor();
      final response = {'data': {'test': 'value'}};

      final result = interceptor.interceptResponse(response);

      expect(result, isNull);
    });

    test('should not throw when onError is called by default', () {
      final interceptor = GraphQLInterceptor();
      final error = MagentoException('Test error');

      expect(() => interceptor.onError(error), returnsNormally);
    });
  });

  group('Custom GraphQLInterceptor', () {
    test('should modify query when interceptQuery is overridden', () {
      final interceptor = CustomInterceptor();
      final query = 'query { test }';
      final variables = {'key': 'value'};

      final result = interceptor.interceptQuery(query, variables);

      expect(result, 'query { test } # modified');
    });

    test('should modify variables when interceptVariables is overridden', () {
      final interceptor = CustomInterceptor();
      final query = 'query { test }';
      final variables = {'key': 'value'};

      final result = interceptor.interceptVariables(query, variables);

      expect(result, isNotNull);
      expect(result!['key'], 'value');
      expect(result['modified'], true);
    });

    test('should modify headers when interceptHeaders is overridden', () {
      final interceptor = CustomInterceptor();
      final query = 'query { test }';
      final variables = {'key': 'value'};
      final headers = {'Content-Type': 'application/json'};

      final result = interceptor.interceptHeaders(query, variables, headers);

      expect(result, isNotNull);
      expect(result!['Content-Type'], 'application/json');
      expect(result['X-Custom'], 'header');
    });

    test('should modify response when interceptResponse is overridden', () {
      final interceptor = CustomInterceptor();
      final response = {'data': {'test': 'value'}};

      final result = interceptor.interceptResponse(response);

      expect(result, isNotNull);
      expect(result!['data']['test'], 'value');
      expect(result['modified'], true);
    });

    test('should handle error when onError is overridden', () {
      final interceptor = CustomInterceptor();
      final error = MagentoException('Test error');

      expect(() => interceptor.onError(error), returnsNormally);
      expect(interceptor.errorHandled, true);
      expect(interceptor.lastError, error);
    });
  });

  group('DefaultGraphQLInterceptor', () {
    test('should inherit default behavior', () {
      final interceptor = DefaultGraphQLInterceptor();
      final query = 'query { test }';
      final variables = {'key': 'value'};
      final headers = {'Content-Type': 'application/json'};
      final response = {'data': {'test': 'value'}};

      expect(interceptor.interceptQuery(query, variables), isNull);
      expect(interceptor.interceptVariables(query, variables), isNull);
      expect(interceptor.interceptHeaders(query, variables, headers), isNull);
      expect(interceptor.interceptResponse(response), isNull);
    });
  });
}

// Custom interceptor for testing
class CustomInterceptor extends GraphQLInterceptor {
  bool errorHandled = false;
  dynamic lastError;

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
    lastError = error;
  }
}
