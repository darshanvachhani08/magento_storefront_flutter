import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:magento_storefront_flutter/core/magento_config.dart';
import 'package:magento_storefront_flutter/core/graphql_interceptor.dart';
import 'package:magento_storefront_flutter/magento_sdk.dart';

void main() {
  group('MagentoSDK', () {
    test('should initialize with required config', () {
      final config = MagentoConfig(
        baseUrl: 'https://test.magento.com',
      );

      final sdk = MagentoSDK(config: config);

      expect(sdk.config, config);
      expect(sdk.auth, isNotNull);
      expect(sdk.store, isNotNull);
      expect(sdk.categories, isNotNull);
      expect(sdk.products, isNotNull);
      expect(sdk.search, isNotNull);
      expect(sdk.cart, isNotNull);
      expect(sdk.custom, isNotNull);
    });

    test('should initialize with interceptor', () {
      final config = MagentoConfig(
        baseUrl: 'https://test.magento.com',
      );
      final interceptor = GraphQLInterceptor();

      final sdk = MagentoSDK(
        config: config,
        interceptor: interceptor,
      );

      expect(sdk.config, config);
      expect(sdk.client, isNotNull);
    });

    test('should initialize with custom HTTP client', () {
      final config = MagentoConfig(
        baseUrl: 'https://test.magento.com',
      );
      final httpClient = http.Client();

      final sdk = MagentoSDK(
        config: config,
        httpClient: httpClient,
      );

      expect(sdk.config, config);
      expect(sdk.client, isNotNull);
    });

    test('should initialize all modules', () {
      final config = MagentoConfig(
        baseUrl: 'https://test.magento.com',
      );

      final sdk = MagentoSDK(config: config);

      // Verify all modules are initialized
      expect(sdk.auth, isNotNull);
      expect(sdk.store, isNotNull);
      expect(sdk.categories, isNotNull);
      expect(sdk.products, isNotNull);
      expect(sdk.search, isNotNull);
      expect(sdk.cart, isNotNull);
      expect(sdk.custom, isNotNull);
    });

    test('should provide access to client', () {
      final config = MagentoConfig(
        baseUrl: 'https://test.magento.com',
      );

      final sdk = MagentoSDK(config: config);

      expect(sdk.client, isNotNull);
      expect(sdk.client.config, config);
    });

    test('should dispose resources', () {
      final config = MagentoConfig(
        baseUrl: 'https://test.magento.com',
      );

      final sdk = MagentoSDK(config: config);

      // Should not throw
      expect(() => sdk.dispose(), returnsNormally);
    });
  });
}
