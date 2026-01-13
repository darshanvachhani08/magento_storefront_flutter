import 'package:flutter_test/flutter_test.dart';
import 'package:magento_storefront_flutter/models/store/store.dart';

void main() {
  group('MagentoStore', () {
    test('should create store from JSON with complete data', () {
      final json = {
        'id': '1',
        'code': 'default',
        'name': 'Main Store',
        'website_id': '1',
        'locale': 'en_US',
        'base_currency_code': 'USD',
        'default_display_currency_code': 'USD',
        'timezone': 'America/New_York',
        'weight_unit': 'lbs',
        'base_url': 'https://example.com',
        'secure_base_url': 'https://example.com',
      };

      final store = MagentoStore.fromJson(json);

      expect(store.id, '1');
      expect(store.code, 'default');
      expect(store.name, 'Main Store');
      expect(store.websiteId, '1');
      expect(store.locale, 'en_US');
      expect(store.baseCurrencyCode, 'USD');
      expect(store.defaultDisplayCurrencyCode, 'USD');
      expect(store.timezone, 'America/New_York');
      expect(store.weightUnit, 'lbs');
      expect(store.baseUrl, 'https://example.com');
      expect(store.secureBaseUrl, 'https://example.com');
    });

    test('should create store from JSON with minimal data', () {
      final json = {
        'id': '1',
        'code': 'default',
        'name': 'Main Store',
      };

      final store = MagentoStore.fromJson(json);

      expect(store.id, '1');
      expect(store.code, 'default');
      expect(store.name, 'Main Store');
      expect(store.websiteId, isNull);
      expect(store.locale, isNull);
    });

    test('should handle alternative field names', () {
      final json = {
        'store_id': '1',
        'store_code': 'default',
        'store_name': 'Main Store',
      };

      final store = MagentoStore.fromJson(json);

      expect(store.id, '1');
      expect(store.code, 'default');
      expect(store.name, 'Main Store');
    });

    test('should prefer primary field names over alternatives', () {
      final json = {
        'id': '1',
        'store_id': '2',
        'code': 'default',
        'store_code': 'alternative',
        'name': 'Main Store',
        'store_name': 'Alternative Store',
      };

      final store = MagentoStore.fromJson(json);

      expect(store.id, '1');
      expect(store.code, 'default');
      expect(store.name, 'Main Store');
    });

    test('should handle null values', () {
      final json = {
        'id': '1',
        'code': 'default',
        'name': 'Main Store',
        'website_id': null,
        'locale': null,
        'base_currency_code': null,
        'default_display_currency_code': null,
        'timezone': null,
        'weight_unit': null,
        'base_url': null,
        'secure_base_url': null,
      };

      final store = MagentoStore.fromJson(json);

      expect(store.websiteId, isNull);
      expect(store.locale, isNull);
      expect(store.baseCurrencyCode, isNull);
      expect(store.defaultDisplayCurrencyCode, isNull);
      expect(store.timezone, isNull);
      expect(store.weightUnit, isNull);
      expect(store.baseUrl, isNull);
      expect(store.secureBaseUrl, isNull);
    });
  });

  group('MagentoStoreConfig', () {
    test('should create store config from JSON with complete data', () {
      final json = {
        'id': '1',
        'code': 'default',
        'website_id': '1',
        'locale': 'en_US',
        'base_currency_code': 'USD',
        'default_display_currency_code': 'USD',
        'timezone': 'America/New_York',
        'weight_unit': 'lbs',
        'base_url': 'https://example.com',
        'secure_base_url': 'https://example.com',
        'store_name': 'Main Store',
        'catalog_search_enabled': true,
        'use_store_in_url': false,
      };

      final config = MagentoStoreConfig.fromJson(json);

      expect(config.id, '1');
      expect(config.code, 'default');
      expect(config.websiteId, '1');
      expect(config.locale, 'en_US');
      expect(config.baseCurrencyCode, 'USD');
      expect(config.defaultDisplayCurrencyCode, 'USD');
      expect(config.timezone, 'America/New_York');
      expect(config.weightUnit, 'lbs');
      expect(config.baseUrl, 'https://example.com');
      expect(config.secureBaseUrl, 'https://example.com');
      expect(config.storeName, 'Main Store');
      expect(config.catalogSearchEnabled, true);
      expect(config.useStoreInUrl, false);
    });

    test('should create store config from JSON with partial data', () {
      final json = {
        'id': '1',
        'code': 'default',
        'store_name': 'Main Store',
      };

      final config = MagentoStoreConfig.fromJson(json);

      expect(config.id, '1');
      expect(config.code, 'default');
      expect(config.storeName, 'Main Store');
      expect(config.websiteId, isNull);
      expect(config.locale, isNull);
      expect(config.baseCurrencyCode, isNull);
    });

    test('should handle null values', () {
      final json = {
        'id': null,
        'code': null,
        'website_id': null,
        'locale': null,
        'base_currency_code': null,
        'default_display_currency_code': null,
        'timezone': null,
        'weight_unit': null,
        'base_url': null,
        'secure_base_url': null,
        'store_name': null,
        'catalog_search_enabled': null,
        'use_store_in_url': null,
      };

      final config = MagentoStoreConfig.fromJson(json);

      expect(config.id, isNull);
      expect(config.code, isNull);
      expect(config.websiteId, isNull);
      expect(config.locale, isNull);
      expect(config.baseCurrencyCode, isNull);
      expect(config.defaultDisplayCurrencyCode, isNull);
      expect(config.timezone, isNull);
      expect(config.weightUnit, isNull);
      expect(config.baseUrl, isNull);
      expect(config.secureBaseUrl, isNull);
      expect(config.storeName, isNull);
      expect(config.catalogSearchEnabled, isNull);
      expect(config.useStoreInUrl, isNull);
    });

    test('should handle boolean values', () {
      final json = {
        'id': '1',
        'code': 'default',
        'catalog_search_enabled': false,
        'use_store_in_url': true,
      };

      final config = MagentoStoreConfig.fromJson(json);

      expect(config.catalogSearchEnabled, false);
      expect(config.useStoreInUrl, true);
    });
  });
}
