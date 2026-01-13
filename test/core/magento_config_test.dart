import 'package:flutter_test/flutter_test.dart';
import 'package:magento_storefront_flutter/core/magento_config.dart';

void main() {
  group('MagentoConfig', () {
    test('should initialize with required parameters', () {
      final config = MagentoConfig(
        baseUrl: 'https://test.magento.com',
      );

      expect(config.baseUrl, 'https://test.magento.com');
      expect(config.storeCode, isNull);
      expect(config.customHeaders, isNull);
      expect(config.timeoutSeconds, 30);
      expect(config.enableDebugLogging, false);
    });

    test('should initialize with all optional parameters', () {
      final customHeaders = {'X-Custom-Header': 'value'};
      final config = MagentoConfig(
        baseUrl: 'https://test.magento.com',
        storeCode: 'default',
        customHeaders: customHeaders,
        timeoutSeconds: 60,
        enableDebugLogging: true,
      );

      expect(config.baseUrl, 'https://test.magento.com');
      expect(config.storeCode, 'default');
      expect(config.customHeaders, customHeaders);
      expect(config.timeoutSeconds, 60);
      expect(config.enableDebugLogging, true);
    });

    test('should throw assertion error when baseUrl is empty', () {
      expect(
        () => MagentoConfig(baseUrl: ''),
        throwsA(isA<AssertionError>()),
      );
    });

    group('graphqlEndpoint', () {
      test('should generate endpoint without trailing slash', () {
        final config = MagentoConfig(
          baseUrl: 'https://test.magento.com',
        );

        expect(config.graphqlEndpoint, 'https://test.magento.com/graphql');
      });

      test('should generate endpoint with trailing slash', () {
        final config = MagentoConfig(
          baseUrl: 'https://test.magento.com/',
        );

        expect(config.graphqlEndpoint, 'https://test.magento.com/graphql');
      });

      test('should generate endpoint with store code', () {
        final config = MagentoConfig(
          baseUrl: 'https://test.magento.com',
          storeCode: 'default',
        );

        expect(config.graphqlEndpoint, 'https://test.magento.com/graphql');
      });

      test('should generate endpoint with store code and trailing slash', () {
        final config = MagentoConfig(
          baseUrl: 'https://test.magento.com/',
          storeCode: 'default',
        );

        expect(config.graphqlEndpoint, 'https://test.magento.com/graphql');
      });

      test('should generate endpoint with empty store code', () {
        final config = MagentoConfig(
          baseUrl: 'https://test.magento.com',
          storeCode: '',
        );

        expect(config.graphqlEndpoint, 'https://test.magento.com/graphql');
      });
    });

    group('headers', () {
      test('should include default headers', () {
        final config = MagentoConfig(
          baseUrl: 'https://test.magento.com',
        );

        final headers = config.headers;

        expect(headers['Content-Type'], 'application/json');
        expect(headers['Accept'], 'application/json');
      });

      test('should include store header when storeCode is provided', () {
        final config = MagentoConfig(
          baseUrl: 'https://test.magento.com',
          storeCode: 'default',
        );

        final headers = config.headers;

        expect(headers['Store'], 'default');
        expect(headers['Content-Type'], 'application/json');
        expect(headers['Accept'], 'application/json');
      });

      test('should include custom headers', () {
        final customHeaders = {
          'X-Custom-Header': 'value',
          'X-Another-Header': 'another-value',
        };
        final config = MagentoConfig(
          baseUrl: 'https://test.magento.com',
          customHeaders: customHeaders,
        );

        final headers = config.headers;

        expect(headers['Content-Type'], 'application/json');
        expect(headers['Accept'], 'application/json');
        expect(headers['X-Custom-Header'], 'value');
        expect(headers['X-Another-Header'], 'another-value');
      });

      test('should include store header and custom headers', () {
        final customHeaders = {'X-Custom-Header': 'value'};
        final config = MagentoConfig(
          baseUrl: 'https://test.magento.com',
          storeCode: 'default',
          customHeaders: customHeaders,
        );

        final headers = config.headers;

        expect(headers['Store'], 'default');
        expect(headers['Content-Type'], 'application/json');
        expect(headers['Accept'], 'application/json');
        expect(headers['X-Custom-Header'], 'value');
      });

      test('should not include store header when storeCode is empty', () {
        final config = MagentoConfig(
          baseUrl: 'https://test.magento.com',
          storeCode: '',
        );

        final headers = config.headers;

        expect(headers.containsKey('Store'), false);
        expect(headers['Content-Type'], 'application/json');
        expect(headers['Accept'], 'application/json');
      });

      test('should allow custom headers to override default headers', () {
        final customHeaders = {
          'Content-Type': 'application/xml',
          'Accept': 'text/html',
        };
        final config = MagentoConfig(
          baseUrl: 'https://test.magento.com',
          customHeaders: customHeaders,
        );

        final headers = config.headers;

        expect(headers['Content-Type'], 'application/xml');
        expect(headers['Accept'], 'text/html');
      });
    });

    group('copyWith', () {
      test('should create copy with modified baseUrl', () {
        final original = MagentoConfig(
          baseUrl: 'https://test.magento.com',
          storeCode: 'default',
        );

        final copy = original.copyWith(baseUrl: 'https://new.magento.com');

        expect(copy.baseUrl, 'https://new.magento.com');
        expect(copy.storeCode, 'default');
        expect(copy.timeoutSeconds, original.timeoutSeconds);
        expect(copy.enableDebugLogging, original.enableDebugLogging);
      });

      test('should create copy with modified storeCode', () {
        final original = MagentoConfig(
          baseUrl: 'https://test.magento.com',
          storeCode: 'default',
        );

        final copy = original.copyWith(storeCode: 'new-store');

        expect(copy.baseUrl, original.baseUrl);
        expect(copy.storeCode, 'new-store');
      });

      test('should create copy with modified customHeaders', () {
        final original = MagentoConfig(
          baseUrl: 'https://test.magento.com',
          customHeaders: {'X-Original': 'value'},
        );

        final newHeaders = {'X-New': 'new-value'};
        final copy = original.copyWith(customHeaders: newHeaders);

        expect(copy.baseUrl, original.baseUrl);
        expect(copy.customHeaders, newHeaders);
      });

      test('should create copy with modified timeoutSeconds', () {
        final original = MagentoConfig(
          baseUrl: 'https://test.magento.com',
          timeoutSeconds: 30,
        );

        final copy = original.copyWith(timeoutSeconds: 60);

        expect(copy.baseUrl, original.baseUrl);
        expect(copy.timeoutSeconds, 60);
      });

      test('should create copy with modified enableDebugLogging', () {
        final original = MagentoConfig(
          baseUrl: 'https://test.magento.com',
          enableDebugLogging: false,
        );

        final copy = original.copyWith(enableDebugLogging: true);

        expect(copy.baseUrl, original.baseUrl);
        expect(copy.enableDebugLogging, true);
      });

      test('should create copy with all fields unchanged when no parameters provided', () {
        final original = MagentoConfig(
          baseUrl: 'https://test.magento.com',
          storeCode: 'default',
          customHeaders: {'X-Header': 'value'},
          timeoutSeconds: 60,
          enableDebugLogging: true,
        );

        final copy = original.copyWith();

        expect(copy.baseUrl, original.baseUrl);
        expect(copy.storeCode, original.storeCode);
        expect(copy.customHeaders, original.customHeaders);
        expect(copy.timeoutSeconds, original.timeoutSeconds);
        expect(copy.enableDebugLogging, original.enableDebugLogging);
      });
    });
  });
}
