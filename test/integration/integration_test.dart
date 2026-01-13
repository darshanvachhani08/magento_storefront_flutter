import 'package:flutter_test/flutter_test.dart';
import 'package:magento_storefront_flutter/core/magento_config.dart';
import 'package:magento_storefront_flutter/magento_sdk.dart';

/// Integration tests for Magento Storefront Flutter SDK
///
/// These tests require a real Magento instance to be running.
/// To run these tests:
/// 1. Set up a test Magento instance
/// 2. Update the baseUrl in the test configuration
/// 3. Ensure test credentials are available
/// 4. Run: flutter test --tags=integration
///
/// To skip these tests, run: flutter test --exclude-tags=integration

void main() {
  group('Integration Tests', () {
    // Note: These tests are marked with @integration tag
    // They will be skipped unless explicitly run with --tags=integration
    // Set up your test Magento instance URL and credentials here
    const String testBaseUrl = 'https://your-test-magento-instance.com';
    const String testEmail = 'test@example.com';
    const String testPassword = 'test-password';

    late MagentoSDK sdk;

    setUp(() {
      // Only run if test server is configured
      // In a real scenario, you might check an environment variable
      final config = MagentoConfig(
        baseUrl: testBaseUrl,
        enableDebugLogging: true,
      );
      sdk = MagentoSDK(config: config);
    });

    tearDown(() {
      sdk.dispose();
    });

    test('should authenticate user', () async {
      // Skip if test server is not configured
      if (testBaseUrl.contains('your-test')) {
        return;
      }

      final result = await sdk.auth.login(testEmail, testPassword);

      expect(result.token, isNotEmpty);
      expect(sdk.auth.isAuthenticated, true);
    }, tags: ['integration']);

    test('should get store configuration', () async {
      if (testBaseUrl.contains('your-test')) {
        return;
      }

      final config = await sdk.store.getStoreConfig();

      expect(config, isNotNull);
      expect(config.code, isNotNull);
    }, tags: ['integration']);

    test('should get stores list', () async {
      if (testBaseUrl.contains('your-test')) {
        return;
      }

      final stores = await sdk.store.getStores();

      expect(stores, isNotEmpty);
    }, tags: ['integration']);

    test('should get category tree', () async {
      if (testBaseUrl.contains('your-test')) {
        return;
      }

      final categories = await sdk.categories.getCategoryTree();

      expect(categories, isNotEmpty);
    }, tags: ['integration']);

    test('should get product by SKU', () async {
      if (testBaseUrl.contains('your-test')) {
        return;
      }

      // Use a known product SKU from your test instance
      final product = await sdk.products.getProductBySku('test-sku');

      expect(product, isNotNull);
      expect(product!.sku, 'test-sku');
    }, tags: ['integration']);

    test('should search products', () async {
      if (testBaseUrl.contains('your-test')) {
        return;
      }

      final results = await sdk.search.searchProducts(
        query: 'shirt',
        pageSize: 10,
        currentPage: 1,
      );

      expect(results, isNotNull);
      expect(results.products, isNotEmpty);
    }, tags: ['integration']);

    test('should create and manage cart', () async {
      if (testBaseUrl.contains('your-test')) {
        return;
      }

      // Create cart
      final cart = await sdk.cart.createCart();
      expect(cart.id, isNotEmpty);

      // Add product to cart
      final updatedCart = await sdk.cart.addProductToCart(
        cartId: cart.id,
        sku: 'test-sku',
        quantity: 1,
      );

      expect(updatedCart.items, isNotEmpty);
      expect(updatedCart.totalQuantity, greaterThan(0));

      // Get cart
      final retrievedCart = await sdk.cart.getCart(cart.id);
      expect(retrievedCart, isNotNull);
      expect(retrievedCart!.id, cart.id);
    }, tags: ['integration']);

    test('should execute custom query', () async {
      if (testBaseUrl.contains('your-test')) {
        return;
      }

      final result = await sdk.custom.query(
        '''
        query {
          storeConfig {
            code
            store_name
          }
        }
        ''',
      );

      expect(result, isNotNull);
      expect(result['data'], isNotNull);
    }, tags: ['integration']);
  });
}
