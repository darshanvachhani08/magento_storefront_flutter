import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:magento_storefront_flutter/core/error_mapper.dart';
import 'package:magento_storefront_flutter/core/magento_exception.dart';

void main() {
  group('ErrorMapper', () {
    group('mapHttpError', () {
      test('should map 401 status code to MagentoAuthenticationException', () {
        final response = http.Response('Unauthorized', 401);

        final exception = ErrorMapper.mapHttpError(response);

        expect(exception, isA<MagentoAuthenticationException>());
        expect(exception.message, contains('Authentication failed'));
        expect(exception.code, '401');
        expect(exception.originalError, 'Unauthorized');
      });

      test('should map 403 status code to MagentoAuthenticationException', () {
        final response = http.Response('Forbidden', 403);

        final exception = ErrorMapper.mapHttpError(response);

        expect(exception, isA<MagentoAuthenticationException>());
        expect(exception.message, contains('Authentication failed'));
        expect(exception.code, '403');
        expect(exception.originalError, 'Forbidden');
      });

      test('should map 500 status code to MagentoNetworkException', () {
        final response = http.Response('Internal Server Error', 500);

        final exception = ErrorMapper.mapHttpError(response);

        expect(exception, isA<MagentoNetworkException>());
        expect(exception.message, contains('Server error'));
        expect(exception.message, contains('500'));
        expect(exception.code, '500');
        expect(exception.originalError, 'Internal Server Error');
      });

      test('should map 502 status code to MagentoNetworkException', () {
        final response = http.Response('Bad Gateway', 502);

        final exception = ErrorMapper.mapHttpError(response);

        expect(exception, isA<MagentoNetworkException>());
        expect(exception.message, contains('Server error'));
        expect(exception.code, '502');
      });

      test('should map 404 status code to MagentoNetworkException', () {
        final response = http.Response('Not Found', 404);

        final exception = ErrorMapper.mapHttpError(response);

        expect(exception, isA<MagentoNetworkException>());
        expect(exception.message, contains('Request failed'));
        expect(exception.message, contains('404'));
        expect(exception.code, '404');
        expect(exception.originalError, 'Not Found');
      });

      test('should map 400 status code to MagentoNetworkException', () {
        final response = http.Response('Bad Request', 400);

        final exception = ErrorMapper.mapHttpError(response);

        expect(exception, isA<MagentoNetworkException>());
        expect(exception.message, contains('Request failed'));
        expect(exception.code, '400');
      });
    });

    group('mapGraphQLError', () {
      test('should map single GraphQL error', () {
        final response = {
          'errors': [
            {
              'message': 'Error message',
            },
          ],
        };

        final exception = ErrorMapper.mapGraphQLError(response);

        expect(exception, isA<MagentoGraphQLException>());
        expect(exception.message, 'Error message');
        final graphqlException = exception as MagentoGraphQLException;
        expect(graphqlException.errors, isNotNull);
        expect(graphqlException.errors!.length, 1);
        expect(graphqlException.errors![0].message, 'Error message');
      });

      test('should map multiple GraphQL errors', () {
        final response = {
          'errors': [
            {'message': 'Error 1'},
            {'message': 'Error 2'},
            {'message': 'Error 3'},
          ],
        };

        final exception = ErrorMapper.mapGraphQLError(response);

        expect(exception, isA<MagentoGraphQLException>());
        final graphqlException = exception as MagentoGraphQLException;
        expect(graphqlException.errors, isNotNull);
        expect(graphqlException.errors!.length, 3);
        expect(exception.message, contains('Error 1'));
        expect(exception.message, contains('Error 2'));
        expect(exception.message, contains('Error 3'));
      });

      test('should map GraphQL error with locations', () {
        final response = {
          'errors': [
            {
              'message': 'Error message',
              'locations': [
                {'line': 1, 'column': 1},
                {'line': 2, 'column': 2},
              ],
            },
          ],
        };

        final exception = ErrorMapper.mapGraphQLError(response) as MagentoGraphQLException;

        expect(exception.errors, isNotNull);
        expect(exception.errors!.length, 1);
        expect(exception.errors![0].locations, isNotNull);
        expect(exception.errors![0].locations!.length, 2);
        expect(exception.errors![0].locations![0].line, 1);
        expect(exception.errors![0].locations![0].column, 1);
      });

      test('should map GraphQL error with path', () {
        final response = {
          'errors': [
            {
              'message': 'Error message',
              'path': ['field1', 'field2'],
            },
          ],
        };

        final exception = ErrorMapper.mapGraphQLError(response) as MagentoGraphQLException;

        expect(exception.errors, isNotNull);
        expect(exception.errors![0].path, isNotNull);
        expect(exception.errors![0].path, ['field1', 'field2']);
      });

      test('should map GraphQL error with extensions', () {
        final response = {
          'errors': [
            {
              'message': 'Error message',
              'extensions': {
                'code': 'ERROR_CODE',
                'category': 'validation',
              },
            },
          ],
        };

        final exception = ErrorMapper.mapGraphQLError(response) as MagentoGraphQLException;

        expect(exception.errors, isNotNull);
        expect(exception.errors![0].extensions, isNotNull);
        expect(exception.errors![0].extensions!['code'], 'ERROR_CODE');
        expect(exception.errors![0].extensions!['category'], 'validation');
      });

      test('should map GraphQL error with all fields', () {
        final response = {
          'errors': [
            {
              'message': 'Error message',
              'locations': [
                {'line': 1, 'column': 1},
              ],
              'path': ['field1'],
              'extensions': {
                'code': 'ERROR_CODE',
              },
            },
          ],
        };

        final exception = ErrorMapper.mapGraphQLError(response) as MagentoGraphQLException;

        expect(exception.errors, isNotNull);
        expect(exception.errors![0].message, 'Error message');
        expect(exception.errors![0].locations, isNotNull);
        expect(exception.errors![0].path, isNotNull);
        expect(exception.errors![0].extensions, isNotNull);
      });

      test('should map empty errors list to unknown error', () {
        final response = {
          'errors': [],
        };

        final exception = ErrorMapper.mapGraphQLError(response);

        expect(exception, isA<MagentoGraphQLException>());
        expect(exception.message, contains('Unknown GraphQL error'));
      });

      test('should map null errors to unknown error', () {
        final response = <String, dynamic>{};

        final exception = ErrorMapper.mapGraphQLError(response);

        expect(exception, isA<MagentoGraphQLException>());
        expect(exception.message, contains('Unknown GraphQL error'));
      });

      test('should map GraphQL authentication error to MagentoAuthenticationException', () {
        final response = {
          'errors': [
            {
              'message': 'Consumer key has expired',
              'extensions': {
                'category': 'graphql-authentication',
              },
            },
          ],
        };

        final exception = ErrorMapper.mapGraphQLError(response);

        expect(exception, isA<MagentoAuthenticationException>());
        expect(exception.message, 'Consumer key has expired');
        expect(exception.code, '401');
      });

      test('should map GraphQL authorization error to MagentoAuthenticationException', () {
        final response = {
          'errors': [
            {
              'message': 'The current user cannot perform operations on cart "123"',
              'extensions': {
                'category': 'graphql-authorization',
              },
            },
          ],
        };

        final exception = ErrorMapper.mapGraphQLError(response);

        expect(exception, isA<MagentoAuthenticationException>());
        expect(exception.message, contains('cannot perform operations on cart'));
      });
    });

    group('mapNetworkException', () {
      test('should map http.ClientException', () {
        final clientException = http.ClientException('Connection failed');

        final exception = ErrorMapper.mapNetworkException(clientException);

        expect(exception, isA<MagentoNetworkException>());
        expect(exception.message, contains('Network error'));
        expect(exception.message, contains('Connection failed'));
        expect(exception.originalError, clientException);
      });

      test('should map generic Exception', () {
        final genericException = Exception('Generic error');

        final exception = ErrorMapper.mapNetworkException(genericException);

        expect(exception, isA<MagentoNetworkException>());
        expect(exception.message, contains('Network error'));
        expect(exception.originalError, genericException);
      });

      test('should map string error', () {
        final stringError = 'String error';

        final exception = ErrorMapper.mapNetworkException(stringError);

        expect(exception, isA<MagentoNetworkException>());
        expect(exception.message, contains('Network error'));
        expect(exception.originalError, stringError);
      });

      test('should map timeout exception', () {
        final timeoutException = TimeoutException('Request timeout', Duration(seconds: 30));

        final exception = ErrorMapper.mapNetworkException(timeoutException);

        expect(exception, isA<MagentoNetworkException>());
        expect(exception.message, contains('Network error'));
        expect(exception.originalError, timeoutException);
      });

      test('should map FormatException', () {
        final formatException = FormatException('Invalid format');

        final exception = ErrorMapper.mapNetworkException(formatException);

        expect(exception, isA<MagentoNetworkException>());
        expect(exception.message, contains('Network error'));
        expect(exception.originalError, formatException);
      });

      test('should map null error', () {
        final exception = ErrorMapper.mapNetworkException(null);

        expect(exception, isA<MagentoNetworkException>());
        expect(exception.message, contains('Network error'));
        expect(exception.originalError, null);
      });

      test('should map int error', () {
        final exception = ErrorMapper.mapNetworkException(404);

        expect(exception, isA<MagentoNetworkException>());
        expect(exception.message, contains('Network error'));
        expect(exception.originalError, 404);
      });
    });
  });
}

// Helper class for timeout exception
class TimeoutException implements Exception {
  final String message;
  final Duration timeout;

  TimeoutException(this.message, this.timeout);

  @override
  String toString() => message;
}
