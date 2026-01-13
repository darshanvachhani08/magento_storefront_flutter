import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:magento_storefront_flutter/catalog/magento_categories.dart';
import 'package:magento_storefront_flutter/core/magento_client.dart';
import 'package:magento_storefront_flutter/core/magento_exception.dart';
import '../helpers/test_data.dart';

import 'magento_categories_test.mocks.dart';

@GenerateMocks([MagentoClient])
void main() {
  late MockMagentoClient mockClient;
  late MagentoCategories categories;

  setUp(() {
    mockClient = MockMagentoClient();
    categories = MagentoCategories(mockClient);
  });

  tearDown(() {
    reset(mockClient);
  });

  group('getCategoryById', () {
    test('should get category successfully with all fields', () async {
      final response = TestData.categoryResponse(
        id: '2',
        uid: 'uid-2',
        name: 'Test Category',
        urlPath: 'test-category',
        urlKey: 'test-category',
        description: 'Category description',
        image: 'https://example.com/image.jpg',
        position: 1,
        level: 1,
        path: '1/2',
        productCount: 10,
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final category = await categories.getCategoryById('2');

      expect(category, isNotNull);
      expect(category!.id, '2');
      expect(category.uid, 'uid-2');
      expect(category.name, 'Test Category');
      expect(category.urlPath, 'test-category');
      expect(category.urlKey, 'test-category');
      expect(category.description, 'Category description');
      expect(category.image, 'https://example.com/image.jpg');
      expect(category.position, 1);
      expect(category.level, 1);
      expect(category.path, '1/2');
      expect(category.productCount, 10);
    });

    test('should get category with children', () async {
      final response = TestData.categoryResponse(
        id: '2',
        uid: 'uid-2',
        name: 'Parent Category',
        children: [
          {
            'id': '3',
            'uid': 'uid-3',
            'name': 'Child Category 1',
          },
          {
            'id': '4',
            'uid': 'uid-4',
            'name': 'Child Category 2',
          },
        ],
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final category = await categories.getCategoryById('2');

      expect(category, isNotNull);
      expect(category!.children, isNotNull);
      expect(category.children!.length, 2);
    });

    test('should return null when category not found', () async {
      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => {
            'data': {
              'category': null,
            },
          });

      final category = await categories.getCategoryById('999');

      expect(category, isNull);
    });

    test('should throw exception when response data is null', () async {
      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => <String, dynamic>{});

      expect(
        () => categories.getCategoryById('2'),
        throwsA(isA<MagentoException>()),
      );
    });

    test('should throw exception when network error occurs', () async {
      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenThrow(MagentoNetworkException('Network error'));

      expect(
        () => categories.getCategoryById('2'),
        throwsA(isA<MagentoNetworkException>()),
      );
    });
  });

  group('getCategoryTree', () {
    test('should get category tree successfully with nested categories', () async {
      final response = TestData.categoryTreeResponse(
        categories: [
          {
            'id': '2',
            'uid': 'uid-2',
            'name': 'Parent Category',
            'children': [
              {
                'id': '3',
                'uid': 'uid-3',
                'name': 'Child Category',
                'children': [
                  {
                    'id': '5',
                    'uid': 'uid-5',
                    'name': 'Grandchild Category',
                  },
                ],
              },
            ],
          },
        ],
      );

      when(mockClient.query(any)).thenAnswer((_) async => response);

      final categoryList = await categories.getCategoryTree();

      expect(categoryList.length, 1);
      expect(categoryList[0].name, 'Parent Category');
      expect(categoryList[0].children, isNotNull);
      expect(categoryList[0].children!.length, 1);
      expect(categoryList[0].children![0].name, 'Child Category');
    });

    test('should return empty list when category list is null', () async {
      when(mockClient.query(any)).thenAnswer((_) async => {
            'data': <String, dynamic>{},
          });

      final categoryList = await categories.getCategoryTree();

      expect(categoryList, isEmpty);
    });

    test('should return empty list when category list is empty', () async {
      final response = TestData.categoryTreeResponse(categories: []);

      when(mockClient.query(any)).thenAnswer((_) async => response);

      final categoryList = await categories.getCategoryTree();

      expect(categoryList, isEmpty);
    });

    test('should throw exception when response data is null', () async {
      when(mockClient.query(any)).thenAnswer((_) async => <String, dynamic>{});

      expect(
        () => categories.getCategoryTree(),
        throwsA(isA<MagentoException>()),
      );
    });

    test('should throw exception when network error occurs', () async {
      when(mockClient.query(any))
          .thenThrow(MagentoNetworkException('Network error'));

      await expectLater(
        categories.getCategoryTree(),
        throwsA(isA<MagentoNetworkException>()),
      );
    });
  });
}
