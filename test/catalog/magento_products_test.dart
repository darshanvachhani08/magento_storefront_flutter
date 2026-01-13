import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:magento_storefront_flutter/catalog/magento_products.dart';
import 'package:magento_storefront_flutter/core/magento_client.dart';
import 'package:magento_storefront_flutter/core/magento_exception.dart';
import '../helpers/test_data.dart';

import 'magento_products_test.mocks.dart';

@GenerateMocks([MagentoClient])
void main() {
  late MockMagentoClient mockClient;
  late MagentoProducts products;

  setUp(() {
    mockClient = MockMagentoClient();
    products = MagentoProducts(mockClient);
  });

  tearDown(() {
    reset(mockClient);
  });

  group('getProductBySku', () {
    test('should get product successfully by SKU', () async {
      final response = TestData.productResponse(
        id: '1',
        sku: 'test-sku',
        name: 'Test Product',
        urlKey: 'test-product',
        description: '<p>Description</p>',
        shortDescription: '<p>Short</p>',
        image: TestData.sampleImage(),
        priceRange: TestData.samplePriceRange(),
        stockStatus: 'IN_STOCK',
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final product = await products.getProductBySku('test-sku');

      expect(product, isNotNull);
      expect(product!.id, '1');
      expect(product.sku, 'test-sku');
      expect(product.name, 'Test Product');
    });

    test('should return null when product not found', () async {
      final response = {
        'data': {
          'products': {
            'items': [],
          },
        },
      };

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final product = await products.getProductBySku('non-existent-sku');

      expect(product, isNull);
    });

    test('should throw exception when response data is null', () async {
      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => <String, dynamic>{});

      expect(
        () => products.getProductBySku('test-sku'),
        throwsA(isA<MagentoException>()),
      );
    });

    test('should throw exception when network error occurs', () async {
      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenThrow(MagentoNetworkException('Network error'));

      expect(
        () => products.getProductBySku('test-sku'),
        throwsA(isA<MagentoNetworkException>()),
      );
    });
  });

  group('getProductByUrlKey', () {
    test('should get product successfully by URL key', () async {
      final response = TestData.productResponse(
        id: '1',
        sku: 'test-sku',
        name: 'Test Product',
        urlKey: 'test-product',
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final product = await products.getProductByUrlKey('test-product');

      expect(product, isNotNull);
      expect(product!.urlKey, 'test-product');
    });

    test('should return null when product not found', () async {
      final response = {
        'data': {
          'products': {
            'items': [],
          },
        },
      };

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final product = await products.getProductByUrlKey('non-existent');

      expect(product, isNull);
    });

    test('should throw exception when response data is null', () async {
      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => <String, dynamic>{});

      expect(
        () => products.getProductByUrlKey('test-product'),
        throwsA(isA<MagentoException>()),
      );
    });
  });

  group('getProductsByCategoryId', () {
    test('should get products successfully with pagination', () async {
      final response = TestData.productsListResponse(
        items: [
          TestData.sampleProduct(id: '1', sku: 'sku-1', name: 'Product 1'),
          TestData.sampleProduct(id: '2', sku: 'sku-2', name: 'Product 2'),
        ],
        totalCount: 2,
        pageInfo: {
          'current_page': 1,
          'page_size': 20,
          'total_pages': 1,
        },
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final result = await products.getProductsByCategoryId(
        categoryId: '2',
        pageSize: 20,
        currentPage: 1,
      );

      expect(result.products.length, 2);
      expect(result.totalCount, 2);
      expect(result.currentPage, 1);
      expect(result.pageSize, 20);
      expect(result.totalPages, 1);
    });

    test('should return empty list when no products found', () async {
      final response = TestData.productsListResponse(
        items: [],
        totalCount: 0,
        pageInfo: {
          'current_page': 1,
          'page_size': 20,
          'total_pages': 0,
        },
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final result = await products.getProductsByCategoryId(
        categoryId: '2',
        pageSize: 20,
        currentPage: 1,
      );

      expect(result.products, isEmpty);
      expect(result.totalCount, 0);
    });

    test('should handle different page sizes and current pages', () async {
      final response = TestData.productsListResponse(
        items: [TestData.sampleProduct()],
        totalCount: 50,
        pageInfo: {
          'current_page': 2,
          'page_size': 10,
          'total_pages': 5,
        },
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final result = await products.getProductsByCategoryId(
        categoryId: '2',
        pageSize: 10,
        currentPage: 2,
      );

      expect(result.currentPage, 2);
      expect(result.pageSize, 10);
      expect(result.totalPages, 5);
    });

    test('should return empty result when products data is null', () async {
      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => {
            'data': <String, dynamic>{},
          });

      final result = await products.getProductsByCategoryId(
        categoryId: '2',
        pageSize: 20,
        currentPage: 1,
      );

      expect(result.products, isEmpty);
      expect(result.totalCount, 0);
    });

    test('should throw exception when response data is null', () async {
      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => <String, dynamic>{});

      expect(
        () => products.getProductsByCategoryId(
          categoryId: '2',
          pageSize: 20,
          currentPage: 1,
        ),
        throwsA(isA<MagentoException>()),
      );
    });
  });
}
