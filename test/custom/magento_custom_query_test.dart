import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:magento_storefront_flutter/core/magento_client.dart';
import 'package:magento_storefront_flutter/core/magento_exception.dart';
import 'package:magento_storefront_flutter/custom/magento_custom_query.dart';

import 'magento_custom_query_test.mocks.dart';

@GenerateMocks([MagentoClient])
void main() {
  late MockMagentoClient mockClient;
  late MagentoCustomQuery customQuery;

  setUp(() {
    mockClient = MockMagentoClient();
    customQuery = MagentoCustomQuery(mockClient);
  });

  tearDown(() {
    reset(mockClient);
  });

  group('query', () {
    test('should execute custom query successfully', () async {
      final response = {
        'data': {
          'customField': {
            'value': 'test-value',
          },
        },
      };

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
        additionalHeaders: anyNamed('additionalHeaders'),
      )).thenAnswer((_) async => response);

      final result = await customQuery.query(
        '''
        query GetCustomData {
          customField {
            value
          }
        }
        ''',
      );

      expect(result, response);
      verify(mockClient.query(
        any,
        variables: anyNamed('variables'),
        additionalHeaders: anyNamed('additionalHeaders'),
      )).called(1);
    });

    test('should execute custom query with variables', () async {
      final response = {
        'data': {
          'customField': {
            'value': 'test-value',
          },
        },
      };

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
        additionalHeaders: anyNamed('additionalHeaders'),
      )).thenAnswer((_) async => response);

      final variables = {'id': '123'};
      await customQuery.query(
        '''
        query GetCustomData(\$id: String!) {
          customField(id: \$id) {
            value
          }
        }
        ''',
        variables: variables,
      );

      verify(mockClient.query(
        any,
        variables: variables,
        additionalHeaders: anyNamed('additionalHeaders'),
      )).called(1);
    });

    test('should execute custom query with additional headers', () async {
      final response = {
        'data': {
          'customField': {
            'value': 'test-value',
          },
        },
      };

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
        additionalHeaders: anyNamed('additionalHeaders'),
      )).thenAnswer((_) async => response);

      final additionalHeaders = {'X-Custom': 'header'};
      await customQuery.query(
        '''
        query GetCustomData {
          customField {
            value
          }
        }
        ''',
        additionalHeaders: additionalHeaders,
      );

      verify(mockClient.query(
        any,
        variables: anyNamed('variables'),
        additionalHeaders: additionalHeaders,
      )).called(1);
    });

    test('should throw exception when error occurs', () async {
      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
        additionalHeaders: anyNamed('additionalHeaders'),
      )).thenThrow(MagentoGraphQLException('GraphQL error'));

      await expectLater(
        customQuery.query(
          '''
          query GetCustomData {
            customField {
              value
            }
          }
          ''',
        ),
        throwsA(isA<MagentoGraphQLException>()),
      );
    });

    test('should throw exception when network error occurs', () async {
      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
        additionalHeaders: anyNamed('additionalHeaders'),
      )).thenThrow(MagentoNetworkException('Network error'));

      expect(
        () => customQuery.query(
          '''
          query GetCustomData {
            customField {
              value
            }
          }
          ''',
        ),
        throwsA(isA<MagentoNetworkException>()),
      );
    });
  });

  group('mutate', () {
    test('should execute custom mutation successfully', () async {
      final response = {
        'data': {
          'updateCustomData': {
            'success': true,
          },
        },
      };

      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
        additionalHeaders: anyNamed('additionalHeaders'),
      )).thenAnswer((_) async => response);

      final result = await customQuery.mutate(
        '''
        mutation UpdateCustomData(\$id: String!, \$value: String!) {
          updateCustomData(id: \$id, value: \$value) {
            success
          }
        }
        ''',
        variables: {'id': '123', 'value': 'new value'},
      );

      expect(result, response);
      verify(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
        additionalHeaders: anyNamed('additionalHeaders'),
      )).called(1);
    });

    test('should execute custom mutation with variables', () async {
      final response = {
        'data': {
          'updateCustomData': {
            'success': true,
          },
        },
      };

      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
        additionalHeaders: anyNamed('additionalHeaders'),
      )).thenAnswer((_) async => response);

      final variables = {'id': '123', 'value': 'new value'};
      await customQuery.mutate(
        '''
        mutation UpdateCustomData(\$id: String!, \$value: String!) {
          updateCustomData(id: \$id, value: \$value) {
            success
          }
        }
        ''',
        variables: variables,
      );

      verify(mockClient.mutate(
        any,
        variables: variables,
        additionalHeaders: anyNamed('additionalHeaders'),
      )).called(1);
    });

    test('should throw exception when error occurs', () async {
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
        additionalHeaders: anyNamed('additionalHeaders'),
      )).thenThrow(MagentoGraphQLException('GraphQL error'));

      await expectLater(
        customQuery.mutate(
          '''
          mutation UpdateCustomData(\$id: String!, \$value: String!) {
            updateCustomData(id: \$id, value: \$value) {
              success
            }
          }
          ''',
          variables: {'id': '123', 'value': 'new value'},
        ),
        throwsA(isA<MagentoGraphQLException>()),
      );
    });
  });
}
