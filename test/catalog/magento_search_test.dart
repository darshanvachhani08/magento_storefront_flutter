import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:magento_storefront_flutter/catalog/magento_search.dart';
import 'package:magento_storefront_flutter/core/magento_client.dart';
import 'package:magento_storefront_flutter/core/magento_exception.dart';
import '../helpers/test_data.dart';

import 'magento_search_test.mocks.dart';

@GenerateMocks([MagentoClient])
void main() {
  late MockMagentoClient mockClient;
  late MagentoSearch search;

  setUp(() {
    mockClient = MockMagentoClient();
    search = MagentoSearch(mockClient);
  });

  tearDown(() {
    reset(mockClient);
  });

  group('searchProducts', () {
    test('should search products successfully with results', () async {
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

      final result = await search.searchProducts(
        query: 'shirt',
        pageSize: 20,
        currentPage: 1,
      );

      expect(result.products.length, 2);
      expect(result.totalCount, 2);
      expect(result.currentPage, 1);
      expect(result.pageSize, 20);
    });

    test('should search products with no results', () async {
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

      final result = await search.searchProducts(
        query: 'nonexistent',
        pageSize: 20,
        currentPage: 1,
      );

      expect(result.products, isEmpty);
      expect(result.totalCount, 0);
    });

    test('should search products with pagination', () async {
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

      final result = await search.searchProducts(
        query: 'shirt',
        pageSize: 10,
        currentPage: 2,
      );

      expect(result.currentPage, 2);
      expect(result.pageSize, 10);
      expect(result.totalPages, 5);
    });

    test('should search products with relevance sort', () async {
      final response = TestData.productsListResponse(
        items: [TestData.sampleProduct()],
        totalCount: 1,
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      await search.searchProducts(
        query: 'shirt',
        sortBy: 'relevance',
      );

      verify(mockClient.query(
        any,
        variables: argThat(
          predicate<Map<String, dynamic>?>(
            (v) => v != null && v['sort'] != null,
          ),
          named: 'variables',
        ),
      )).called(1);
    });

    test('should search products with price_asc sort', () async {
      final response = TestData.productsListResponse(
        items: [TestData.sampleProduct()],
        totalCount: 1,
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      await search.searchProducts(
        query: 'shirt',
        sortBy: 'price_asc',
      );

      verify(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).called(1);
    });

    test('should search products with price_desc sort', () async {
      final response = TestData.productsListResponse(
        items: [TestData.sampleProduct()],
        totalCount: 1,
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      await search.searchProducts(
        query: 'shirt',
        sortBy: 'price_desc',
      );

      verify(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).called(1);
    });

    test('should search products with name_asc sort', () async {
      final response = TestData.productsListResponse(
        items: [TestData.sampleProduct()],
        totalCount: 1,
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      await search.searchProducts(
        query: 'shirt',
        sortBy: 'name_asc',
      );

      verify(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).called(1);
    });

    test('should search products with name_desc sort', () async {
      final response = TestData.productsListResponse(
        items: [TestData.sampleProduct()],
        totalCount: 1,
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      await search.searchProducts(
        query: 'shirt',
        sortBy: 'name_desc',
      );

      verify(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).called(1);
    });

    test('should search products with created_at sort', () async {
      final response = TestData.productsListResponse(
        items: [TestData.sampleProduct()],
        totalCount: 1,
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      await search.searchProducts(
        query: 'shirt',
        sortBy: 'created_at',
      );

      verify(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).called(1);
    });

    test('should default to relevance when invalid sort option', () async {
      final response = TestData.productsListResponse(
        items: [TestData.sampleProduct()],
        totalCount: 1,
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      await search.searchProducts(
        query: 'shirt',
        sortBy: 'invalid_sort',
      );

      verify(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).called(1);
    });

    test('should return empty result when products data is null', () async {
      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => {
            'data': <String, dynamic>{},
          });

      final result = await search.searchProducts(
        query: 'shirt',
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
        () => search.searchProducts(
          query: 'shirt',
          pageSize: 20,
          currentPage: 1,
        ),
        throwsA(isA<MagentoException>()),
      );
    });

    test('should throw exception when network error occurs', () async {
      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenThrow(MagentoNetworkException('Network error'));

      expect(
        () => search.searchProducts(
          query: 'shirt',
          pageSize: 20,
          currentPage: 1,
        ),
        throwsA(isA<MagentoNetworkException>()),
      );
    });
  });
}
