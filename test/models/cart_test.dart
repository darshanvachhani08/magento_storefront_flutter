import 'package:flutter_test/flutter_test.dart';
import 'package:magento_storefront_flutter/models/cart/cart.dart';

void main() {
  group('MagentoCart', () {
    test('should create cart from JSON with items', () {
      final json = {
        'id': 'cart-123',
        'items': [
          {
            'id': '1',
            'quantity': 2,
            'product': {
              'id': '1',
              'sku': 'test-sku',
              'name': 'Test Product',
            },
            'prices': {
              'price': {
                'value': 100.0,
                'currency': 'USD',
              },
              'row_total': {
                'value': 200.0,
                'currency': 'USD',
              },
            },
          },
        ],
        'prices': {
          'grand_total': {
            'value': 200.0,
            'currency': 'USD',
          },
          'subtotal_excluding_tax': {
            'value': 180.0,
            'currency': 'USD',
          },
          'subtotal_including_tax': {
            'value': 200.0,
            'currency': 'USD',
          },
        },
        'total_quantity': 2,
      };

      final cart = MagentoCart.fromJson(json);

      expect(cart.id, 'cart-123');
      expect(cart.items.length, 1);
      expect(cart.items[0].id, '1');
      expect(cart.items[0].quantity, 2);
      expect(cart.totalQuantity, 2);
      expect(cart.isEmpty, false);
      expect(cart.prices, isNotNull);
      expect(cart.prices!.grandTotal!.value, 200.0);
    });

    test('should create empty cart', () {
      final json = {
        'id': 'cart-123',
        'items': [],
        'total_quantity': 0,
      };

      final cart = MagentoCart.fromJson(json);

      expect(cart.id, 'cart-123');
      expect(cart.items, isEmpty);
      expect(cart.totalQuantity, 0);
      expect(cart.isEmpty, true);
    });

    test('should calculate total quantity from items when missing', () {
      final json = {
        'id': 'cart-123',
        'items': [
          {
            'id': '1',
            'quantity': 2,
            'product': {
              'id': '1',
              'sku': 'test-sku',
              'name': 'Test Product',
            },
          },
          {
            'id': '2',
            'quantity': 3,
            'product': {
              'id': '2',
              'sku': 'test-sku-2',
              'name': 'Test Product 2',
            },
          },
        ],
      };

      final cart = MagentoCart.fromJson(json);

      expect(cart.totalQuantity, 5);
    });

    test('should handle id as int', () {
      final json = {
        'id': 123,
        'items': [],
        'total_quantity': 0,
      };

      final cart = MagentoCart.fromJson(json);

      expect(cart.id, '123');
    });

    test('should handle missing prices', () {
      final json = {
        'id': 'cart-123',
        'items': [],
        'total_quantity': 0,
      };

      final cart = MagentoCart.fromJson(json);

      expect(cart.prices, isNull);
    });
  });

  group('MagentoCartItem', () {
    test('should create cart item from JSON', () {
      final json = {
        'id': '1',
        'quantity': 2,
        'product': {
          'id': '1',
          'sku': 'test-sku',
          'name': 'Test Product',
        },
        'prices': {
          'price': {
            'value': 100.0,
            'currency': 'USD',
          },
          'row_total': {
            'value': 200.0,
            'currency': 'USD',
          },
        },
      };

      final item = MagentoCartItem.fromJson(json);

      expect(item.id, '1');
      expect(item.quantity, 2);
      expect(item.product.id, '1');
      expect(item.product.sku, 'test-sku');
      expect(item.product.name, 'Test Product');
      expect(item.prices, isNotNull);
      expect(item.prices!.price!.value, 100.0);
      expect(item.prices!.rowTotal!.value, 200.0);
    });

    test('should handle id as int', () {
      final json = {
        'id': 1,
        'quantity': 1,
        'product': {
          'id': '1',
          'sku': 'test-sku',
          'name': 'Test Product',
        },
      };

      final item = MagentoCartItem.fromJson(json);

      expect(item.id, '1');
    });

    test('should default quantity to 0 when missing', () {
      final json = {
        'id': '1',
        'product': {
          'id': '1',
          'sku': 'test-sku',
          'name': 'Test Product',
        },
      };

      final item = MagentoCartItem.fromJson(json);

      expect(item.quantity, 0);
    });

    test('should handle missing prices', () {
      final json = {
        'id': '1',
        'quantity': 1,
        'product': {
          'id': '1',
          'sku': 'test-sku',
          'name': 'Test Product',
        },
      };

      final item = MagentoCartItem.fromJson(json);

      expect(item.prices, isNull);
    });
  });

  group('MagentoCartPrices', () {
    test('should create cart prices from JSON', () {
      final json = {
        'grand_total': {
          'value': 200.0,
          'currency': 'USD',
        },
        'subtotal_excluding_tax': {
          'value': 180.0,
          'currency': 'USD',
        },
        'subtotal_including_tax': {
          'value': 200.0,
          'currency': 'USD',
        },
      };

      final prices = MagentoCartPrices.fromJson(json);

      expect(prices.grandTotal, isNotNull);
      expect(prices.grandTotal!.value, 200.0);
      expect(prices.grandTotal!.currency, 'USD');
      expect(prices.subtotalExcludingTax, isNotNull);
      expect(prices.subtotalExcludingTax!.value, 180.0);
      expect(prices.subtotalIncludingTax, isNotNull);
      expect(prices.subtotalIncludingTax!.value, 200.0);
    });

    test('should handle missing prices', () {
      final json = <String, dynamic>{};

      final prices = MagentoCartPrices.fromJson(json);

      expect(prices.grandTotal, isNull);
      expect(prices.subtotalExcludingTax, isNull);
      expect(prices.subtotalIncludingTax, isNull);
    });
  });

  group('MagentoCartItemPrices', () {
    test('should create cart item prices from JSON', () {
      final json = {
        'price': {
          'value': 100.0,
          'currency': 'USD',
        },
        'row_total': {
          'value': 200.0,
          'currency': 'USD',
        },
      };

      final prices = MagentoCartItemPrices.fromJson(json);

      expect(prices.price, isNotNull);
      expect(prices.price!.value, 100.0);
      expect(prices.price!.currency, 'USD');
      expect(prices.rowTotal, isNotNull);
      expect(prices.rowTotal!.value, 200.0);
      expect(prices.rowTotal!.currency, 'USD');
    });

    test('should handle missing prices', () {
      final json = <String, dynamic>{};

      final prices = MagentoCartItemPrices.fromJson(json);

      expect(prices.price, isNull);
      expect(prices.rowTotal, isNull);
    });
  });

  group('MagentoCart edge cases', () {
    test('should handle id as int', () {
      final json = {
        'id': 123,
        'items': [],
        'total_quantity': 0,
      };

      final cart = MagentoCart.fromJson(json);

      expect(cart.id, '123');
    });

    test('should calculate totalQuantity from items when not provided', () {
      final json = {
        'id': 'cart-123',
        'items': [
          {
            'id': '1',
            'quantity': 3,
            'product': {
              'id': '1',
              'sku': 'test-sku',
              'name': 'Test Product',
            },
          },
          {
            'id': '2',
            'quantity': 2,
            'product': {
              'id': '2',
              'sku': 'test-sku-2',
              'name': 'Test Product 2',
            },
          },
        ],
      };

      final cart = MagentoCart.fromJson(json);

      expect(cart.totalQuantity, 5);
    });

    test('should handle null items', () {
      final json = {
        'id': 'cart-123',
        'items': null,
        'total_quantity': 0,
      };

      final cart = MagentoCart.fromJson(json);

      expect(cart.items, isEmpty);
      expect(cart.totalQuantity, 0);
      expect(cart.isEmpty, true);
    });

    test('should handle items with null quantity', () {
      final json = {
        'id': 'cart-123',
        'items': [
          {
            'id': '1',
            'quantity': null,
            'product': {
              'id': '1',
              'sku': 'test-sku',
              'name': 'Test Product',
            },
          },
        ],
      };

      final cart = MagentoCart.fromJson(json);

      expect(cart.totalQuantity, 0);
    });
  });

  group('MagentoCartItem edge cases', () {
    test('should handle id as int', () {
      final json = {
        'id': 123,
        'quantity': 1,
        'product': {
          'id': '1',
          'sku': 'test-sku',
          'name': 'Test Product',
        },
      };

      final item = MagentoCartItem.fromJson(json);

      expect(item.id, '123');
    });

    test('should handle null quantity', () {
      final json = {
        'id': '1',
        'quantity': null,
        'product': {
          'id': '1',
          'sku': 'test-sku',
          'name': 'Test Product',
        },
      };

      final item = MagentoCartItem.fromJson(json);

      expect(item.quantity, 0);
    });
  });
}
