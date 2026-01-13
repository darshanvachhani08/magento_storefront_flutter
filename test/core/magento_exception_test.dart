import 'package:flutter_test/flutter_test.dart';
import 'package:magento_storefront_flutter/core/magento_exception.dart';

void main() {
  group('MagentoException', () {
    test('should create exception with message', () {
      final exception = MagentoException('Test error');

      expect(exception.message, 'Test error');
      expect(exception.code, isNull);
      expect(exception.originalError, isNull);
    });

    test('should create exception with message and code', () {
      final exception = MagentoException(
        'Test error',
        code: 'ERROR_CODE',
      );

      expect(exception.message, 'Test error');
      expect(exception.code, 'ERROR_CODE');
    });

    test('should create exception with original error', () {
      final originalError = Exception('Original error');
      final exception = MagentoException(
        'Test error',
        originalError: originalError,
      );

      expect(exception.message, 'Test error');
      expect(exception.originalError, originalError);
    });

    test('toString should include message and code', () {
      final exception = MagentoException(
        'Test error',
        code: 'ERROR_CODE',
      );

      final string = exception.toString();
      expect(string, contains('MagentoException'));
      expect(string, contains('Test error'));
      expect(string, contains('ERROR_CODE'));
    });

    test('toString should include only message when code is null', () {
      final exception = MagentoException('Test error');

      final string = exception.toString();
      expect(string, contains('MagentoException'));
      expect(string, contains('Test error'));
      expect(string, isNot(contains('code:')));
    });
  });

  group('MagentoAuthenticationException', () {
    test('should create authentication exception', () {
      final exception = MagentoAuthenticationException('Auth failed');

      expect(exception.message, 'Auth failed');
      expect(exception, isA<MagentoException>());
    });

    test('toString should return authentication exception format', () {
      final exception = MagentoAuthenticationException('Auth failed');

      final string = exception.toString();
      expect(string, contains('MagentoAuthenticationException'));
      expect(string, contains('Auth failed'));
    });
  });

  group('MagentoGraphQLException', () {
    test('should create GraphQL exception without errors', () {
      final exception = MagentoGraphQLException('GraphQL error');

      expect(exception.message, 'GraphQL error');
      expect(exception.errors, isNull);
    });

    test('should create GraphQL exception with errors', () {
      final errors = [
        GraphQLError(message: 'Error 1'),
        GraphQLError(message: 'Error 2'),
      ];
      final exception = MagentoGraphQLException(
        'GraphQL error',
        errors: errors,
      );

      expect(exception.message, 'GraphQL error');
      expect(exception.errors, errors);
    });

    test('toString should include errors when present', () {
      final errors = [
        GraphQLError(message: 'Error 1'),
        GraphQLError(message: 'Error 2'),
      ];
      final exception = MagentoGraphQLException(
        'GraphQL error',
        errors: errors,
      );

      final string = exception.toString();
      expect(string, contains('MagentoGraphQLException'));
      expect(string, contains('GraphQL error'));
      expect(string, contains('Error 1'));
      expect(string, contains('Error 2'));
    });

    test('toString should not include errors when null', () {
      final exception = MagentoGraphQLException('GraphQL error');

      final string = exception.toString();
      expect(string, contains('MagentoGraphQLException'));
      expect(string, contains('GraphQL error'));
      expect(string, isNot(contains('Errors:')));
    });
  });

  group('MagentoNetworkException', () {
    test('should create network exception', () {
      final exception = MagentoNetworkException('Network error');

      expect(exception.message, 'Network error');
      expect(exception, isA<MagentoException>());
    });

    test('toString should return network exception format', () {
      final exception = MagentoNetworkException('Network error');

      final string = exception.toString();
      expect(string, contains('MagentoNetworkException'));
      expect(string, contains('Network error'));
    });
  });

  group('GraphQLErrorLocation', () {
    test('should create location with line and column', () {
      final location = GraphQLErrorLocation(
        line: 10,
        column: 5,
      );

      expect(location.line, 10);
      expect(location.column, 5);
    });

    test('should create location from JSON', () {
      final json = {
        'line': 10,
        'column': 5,
      };

      final location = GraphQLErrorLocation.fromJson(json);

      expect(location.line, 10);
      expect(location.column, 5);
    });

    test('toString should return formatted location', () {
      final location = GraphQLErrorLocation(
        line: 10,
        column: 5,
      );

      final string = location.toString();
      expect(string, contains('line 10'));
      expect(string, contains('column 5'));
    });
  });

  group('GraphQLError', () {
    test('should create error with message only', () {
      final error = GraphQLError(message: 'Error message');

      expect(error.message, 'Error message');
      expect(error.locations, isNull);
      expect(error.path, isNull);
      expect(error.extensions, isNull);
    });

    test('should create error with all fields', () {
      final locations = [
        GraphQLErrorLocation(line: 1, column: 1),
        GraphQLErrorLocation(line: 2, column: 2),
      ];
      final path = ['field1', 'field2'];
      final extensions = {'code': 'ERROR_CODE'};

      final error = GraphQLError(
        message: 'Error message',
        locations: locations,
        path: path,
        extensions: extensions,
      );

      expect(error.message, 'Error message');
      expect(error.locations, locations);
      expect(error.path, path);
      expect(error.extensions, extensions);
    });

    test('should create error from JSON with message only', () {
      final json = {
        'message': 'Error message',
      };

      final error = GraphQLError.fromJson(json);

      expect(error.message, 'Error message');
      expect(error.locations, isNull);
      expect(error.path, isNull);
      expect(error.extensions, isNull);
    });

    test('should create error from JSON with locations', () {
      final json = {
        'message': 'Error message',
        'locations': [
          {'line': 1, 'column': 1},
          {'line': 2, 'column': 2},
        ],
      };

      final error = GraphQLError.fromJson(json);

      expect(error.message, 'Error message');
      expect(error.locations, isNotNull);
      expect(error.locations!.length, 2);
      expect(error.locations![0].line, 1);
      expect(error.locations![0].column, 1);
    });

    test('should create error from JSON with path', () {
      final json = {
        'message': 'Error message',
        'path': ['field1', 'field2'],
      };

      final error = GraphQLError.fromJson(json);

      expect(error.message, 'Error message');
      expect(error.path, isNotNull);
      expect(error.path, ['field1', 'field2']);
    });

    test('should create error from JSON with extensions', () {
      final json = {
        'message': 'Error message',
        'extensions': {
          'code': 'ERROR_CODE',
          'category': 'validation',
        },
      };

      final error = GraphQLError.fromJson(json);

      expect(error.message, 'Error message');
      expect(error.extensions, isNotNull);
      expect(error.extensions!['code'], 'ERROR_CODE');
      expect(error.extensions!['category'], 'validation');
    });

    test('should create error from JSON with all fields', () {
      final json = {
        'message': 'Error message',
        'locations': [
          {'line': 1, 'column': 1},
        ],
        'path': ['field1'],
        'extensions': {
          'code': 'ERROR_CODE',
        },
      };

      final error = GraphQLError.fromJson(json);

      expect(error.message, 'Error message');
      expect(error.locations, isNotNull);
      expect(error.path, isNotNull);
      expect(error.extensions, isNotNull);
    });
  });
}
