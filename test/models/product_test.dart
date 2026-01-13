import 'package:flutter_test/flutter_test.dart';
import 'package:magento_storefront_flutter/models/product/product.dart';

void main() {
  group('MagentoProduct', () {
    test('should create product from JSON with complete data', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'url_key': 'test-product',
        'description': {
          'html': '<p>Product description</p>',
        },
        'short_description': {
          'html': '<p>Short description</p>',
        },
        'image': {
          'url': 'https://example.com/image.jpg',
          'label': 'Main Image',
          'position': 1,
        },
        'price_range': {
          'minimum_price': {
            'regular_price': {
              'value': 100.0,
              'currency': 'USD',
            },
            'final_price': {
              'value': 80.0,
              'currency': 'USD',
            },
          },
          'maximum_price': {
            'regular_price': {
              'value': 100.0,
              'currency': 'USD',
            },
            'final_price': {
              'value': 80.0,
              'currency': 'USD',
            },
          },
        },
        'stock_status': 'IN_STOCK',
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.id, '1');
      expect(product.sku, 'test-sku');
      expect(product.name, 'Test Product');
      expect(product.urlKey, 'test-product');
      expect(product.description, '<p>Product description</p>');
      expect(product.shortDescription, '<p>Short description</p>');
      expect(product.images.length, 1);
      expect(product.images[0].url, 'https://example.com/image.jpg');
      expect(product.priceRange, isNotNull);
      expect(product.stockStatus, 'IN_STOCK');
      expect(product.inStock, true);
    });

    test('should create product from JSON with minimal data', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.id, '1');
      expect(product.sku, 'test-sku');
      expect(product.name, 'Test Product');
      expect(product.urlKey, isNull);
      expect(product.description, isNull);
      expect(product.shortDescription, isNull);
      expect(product.images, isEmpty);
      expect(product.priceRange, isNull);
    });

    test('should handle description as string', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'description': 'Simple description',
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.description, 'Simple description');
    });

    test('should handle description as object with html', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'description': {
          'html': '<p>HTML description</p>',
        },
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.description, '<p>HTML description</p>');
    });

    test('should handle short_description as string', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'short_description': 'Short desc',
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.shortDescription, 'Short desc');
    });

    test('should handle short_description as object with html', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'short_description': {
          'html': '<p>Short HTML</p>',
        },
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.shortDescription, '<p>Short HTML</p>');
    });

    test('should handle single image', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'image': {
          'url': 'https://example.com/image.jpg',
          'label': 'Image',
        },
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.images.length, 1);
      expect(product.images[0].url, 'https://example.com/image.jpg');
      expect(product.images[0].label, 'Image');
    });

    test('should handle multiple images', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'images': [
          {
            'url': 'https://example.com/image1.jpg',
            'label': 'Image 1',
          },
          {
            'url': 'https://example.com/image2.jpg',
            'label': 'Image 2',
          },
        ],
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.images.length, 2);
      expect(product.images[0].url, 'https://example.com/image1.jpg');
      expect(product.images[1].url, 'https://example.com/image2.jpg');
    });

    test('should handle id as int', () {
      final json = {
        'id': 123,
        'sku': 'test-sku',
        'name': 'Test Product',
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.id, '123');
    });

    test('should handle uid instead of id', () {
      final json = {
        'uid': 'uid-123',
        'sku': 'test-sku',
        'name': 'Test Product',
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.id, 'uid-123');
    });

    test('should handle stock status OUT_OF_STOCK', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'stock_status': 'OUT_OF_STOCK',
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.stockStatus, 'OUT_OF_STOCK');
      expect(product.inStock, false);
    });

    test('should handle null values', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'url_key': null,
        'description': null,
        'short_description': null,
        'image': null,
        'price_range': null,
        'stock_status': null,
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.urlKey, isNull);
      expect(product.description, isNull);
      expect(product.shortDescription, isNull);
      expect(product.images, isEmpty);
      expect(product.priceRange, isNull);
      expect(product.stockStatus, isNull);
      expect(product.inStock, isNull);
    });

    test('should handle image as map with src field', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'image': {
          'src': 'https://example.com/image.jpg',
          'label': 'Product Image',
        },
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.images.length, 1);
      expect(product.images[0].url, 'https://example.com/image.jpg');
      expect(product.images[0].label, 'Product Image');
    });

    test('should handle image as map with url field', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'image': {
          'url': 'https://example.com/image.jpg',
        },
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.images.length, 1);
      expect(product.images[0].url, 'https://example.com/image.jpg');
    });

    test('should handle images array', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'images': [
          {'url': 'https://example.com/image1.jpg'},
          {'url': 'https://example.com/image2.jpg', 'label': 'Image 2'},
        ],
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.images.length, 2);
      expect(product.images[0].url, 'https://example.com/image1.jpg');
      expect(product.images[1].url, 'https://example.com/image2.jpg');
      expect(product.images[1].label, 'Image 2');
    });

    test('should handle empty images array', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'images': [],
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.images, isEmpty);
    });

    test('should handle invalid image data type', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'image': 'invalid',
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.images, isEmpty);
    });

    test('should handle stock status IN_STOCK', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'stock_status': 'IN_STOCK',
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.stockStatus, 'IN_STOCK');
      expect(product.inStock, true);
    });

    test('should handle empty attributes array', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'attributes': [],
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.attributes, isEmpty);
    });

    test('should handle attributes with null values', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'attributes': [
          {'code': 'attr1', 'value': null, 'label': null},
        ],
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.attributes.length, 1);
      expect(product.attributes[0].code, 'attr1');
      expect(product.attributes[0].value, isNull);
      expect(product.attributes[0].label, isNull);
    });

    test('should handle empty categories array', () {
      final json = {
        'id': '1',
        'sku': 'test-sku',
        'name': 'Test Product',
        'categories': [],
      };

      final product = MagentoProduct.fromJson(json);

      expect(product.categories, isEmpty);
    });
  });

  group('MagentoProductImage', () {
    test('should create image from JSON', () {
      final json = {
        'url': 'https://example.com/image.jpg',
        'label': 'Main Image',
        'position': 1,
      };

      final image = MagentoProductImage.fromJson(json);

      expect(image.url, 'https://example.com/image.jpg');
      expect(image.label, 'Main Image');
      expect(image.position, 1);
    });

    test('should handle src instead of url', () {
      final json = {
        'src': 'https://example.com/image.jpg',
        'label': 'Image',
      };

      final image = MagentoProductImage.fromJson(json);

      expect(image.url, 'https://example.com/image.jpg');
    });

    test('should handle missing fields', () {
      final json = {
        'url': 'https://example.com/image.jpg',
      };

      final image = MagentoProductImage.fromJson(json);

      expect(image.url, 'https://example.com/image.jpg');
      expect(image.label, isNull);
      expect(image.position, isNull);
    });
  });

  group('MagentoPriceRange', () {
    test('should create price range from JSON', () {
      final json = {
        'minimum_price': {
          'regular_price': {
            'value': 100.0,
            'currency': 'USD',
          },
          'final_price': {
            'value': 80.0,
            'currency': 'USD',
          },
        },
        'maximum_price': {
          'regular_price': {
            'value': 100.0,
            'currency': 'USD',
          },
          'final_price': {
            'value': 80.0,
            'currency': 'USD',
          },
        },
      };

      final priceRange = MagentoPriceRange.fromJson(json);

      expect(priceRange.minimumPrice, isNotNull);
      expect(priceRange.maximumPrice, isNotNull);
      expect(priceRange.minimumPrice!.regularPrice!.value, 100.0);
      expect(priceRange.minimumPrice!.finalPrice!.value, 80.0);
    });

    test('should handle missing prices', () {
      final json = <String, dynamic>{};

      final priceRange = MagentoPriceRange.fromJson(json);

      expect(priceRange.minimumPrice, isNull);
      expect(priceRange.maximumPrice, isNull);
    });
  });

  group('MagentoPrice', () {
    test('should create price from JSON', () {
      final json = {
        'regular_price': {
          'value': 100.0,
          'currency': 'USD',
        },
        'final_price': {
          'value': 80.0,
          'currency': 'USD',
        },
        'discount': {
          'value': 20.0,
          'currency': 'USD',
        },
      };

      final price = MagentoPrice.fromJson(json);

      expect(price.regularPrice, isNotNull);
      expect(price.finalPrice, isNotNull);
      expect(price.discount, isNotNull);
      expect(price.regularPrice!.value, 100.0);
      expect(price.finalPrice!.value, 80.0);
      expect(price.discount!.value, 20.0);
    });
  });

  group('MagentoMoney', () {
    test('should create money from JSON', () {
      final json = {
        'value': 100.0,
        'currency': 'USD',
      };

      final money = MagentoMoney.fromJson(json);

      expect(money.value, 100.0);
      expect(money.currency, 'USD');
    });

    test('should handle int value', () {
      final json = {
        'value': 100,
        'currency': 'USD',
      };

      final money = MagentoMoney.fromJson(json);

      expect(money.value, 100.0);
    });

    test('should default to 0.0 and USD when missing', () {
      final json = <String, dynamic>{};

      final money = MagentoMoney.fromJson(json);

      expect(money.value, 0.0);
      expect(money.currency, 'USD');
    });
  });

  group('MagentoProductAttribute', () {
    test('should create attribute from JSON', () {
      final json = {
        'code': 'color',
        'value': 'red',
        'label': 'Color',
      };

      final attribute = MagentoProductAttribute.fromJson(json);

      expect(attribute.code, 'color');
      expect(attribute.value, 'red');
      expect(attribute.label, 'Color');
    });

    test('should handle missing fields', () {
      final json = {
        'code': 'color',
      };

      final attribute = MagentoProductAttribute.fromJson(json);

      expect(attribute.code, 'color');
      expect(attribute.value, isNull);
      expect(attribute.label, isNull);
    });

    test('should handle empty code', () {
      final json = {
        'code': null,
      };

      final attribute = MagentoProductAttribute.fromJson(json);

      expect(attribute.code, '');
    });
  });

  group('MagentoPriceRange edge cases', () {
    test('should handle only minimum price', () {
      final json = {
        'minimum_price': {
          'regular_price': {
            'value': 100.0,
            'currency': 'USD',
          },
        },
      };

      final priceRange = MagentoPriceRange.fromJson(json);

      expect(priceRange.minimumPrice, isNotNull);
      expect(priceRange.maximumPrice, isNull);
    });

    test('should handle only maximum price', () {
      final json = {
        'maximum_price': {
          'regular_price': {
            'value': 100.0,
            'currency': 'USD',
          },
        },
      };

      final priceRange = MagentoPriceRange.fromJson(json);

      expect(priceRange.minimumPrice, isNull);
      expect(priceRange.maximumPrice, isNotNull);
    });
  });

  group('MagentoPrice edge cases', () {
    test('should handle only regular price', () {
      final json = {
        'regular_price': {
          'value': 100.0,
          'currency': 'USD',
        },
      };

      final price = MagentoPrice.fromJson(json);

      expect(price.regularPrice, isNotNull);
      expect(price.finalPrice, isNull);
      expect(price.discount, isNull);
    });

    test('should handle only final price', () {
      final json = {
        'final_price': {
          'value': 80.0,
          'currency': 'USD',
        },
      };

      final price = MagentoPrice.fromJson(json);

      expect(price.regularPrice, isNull);
      expect(price.finalPrice, isNotNull);
      expect(price.discount, isNull);
    });

    test('should handle only discount', () {
      final json = {
        'discount': {
          'value': 20.0,
          'currency': 'USD',
        },
      };

      final price = MagentoPrice.fromJson(json);

      expect(price.regularPrice, isNull);
      expect(price.finalPrice, isNull);
      expect(price.discount, isNotNull);
    });
  });

  group('MagentoMoney edge cases', () {
    test('should handle null currency', () {
      final json = {
        'value': 100.0,
        'currency': null,
      };

      final money = MagentoMoney.fromJson(json);

      expect(money.value, 100.0);
      expect(money.currency, 'USD');
    });

    test('should handle null value', () {
      final json = {
        'value': null,
        'currency': 'EUR',
      };

      final money = MagentoMoney.fromJson(json);

      expect(money.value, 0.0);
      expect(money.currency, 'EUR');
    });
  });

  group('MagentoProductImage edge cases', () {
    test('should handle missing url and src', () {
      final json = {
        'label': 'Image',
      };

      final image = MagentoProductImage.fromJson(json);

      expect(image.url, '');
      expect(image.label, 'Image');
    });

    test('should handle null position', () {
      final json = {
        'url': 'https://example.com/image.jpg',
        'position': null,
      };

      final image = MagentoProductImage.fromJson(json);

      expect(image.url, 'https://example.com/image.jpg');
      expect(image.position, isNull);
    });
  });
}
