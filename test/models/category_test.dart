import 'package:flutter_test/flutter_test.dart';
import 'package:magento_storefront_flutter/models/category/category.dart';

void main() {
  group('MagentoCategory', () {
    test('should create category from JSON with complete data', () {
      final json = {
        'id': '2',
        'uid': 'uid-2',
        'name': 'Test Category',
        'url_path': 'test-category',
        'url_key': 'test-category',
        'description': 'Category description',
        'image': 'https://example.com/image.jpg',
        'position': 1,
        'level': 1,
        'path': '1/2',
        'product_count': 10,
      };

      final category = MagentoCategory.fromJson(json);

      expect(category.id, '2');
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
      expect(category.children, isNull);
    });

    test('should create category with children', () {
      final json = {
        'id': '2',
        'uid': 'uid-2',
        'name': 'Parent Category',
        'children': [
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
      };

      final category = MagentoCategory.fromJson(json);

      expect(category.children, isNotNull);
      expect(category.children!.length, 2);
      expect(category.children![0].id, '3');
      expect(category.children![0].name, 'Child Category 1');
      expect(category.children![1].id, '4');
      expect(category.children![1].name, 'Child Category 2');
    });

    test('should create category with nested children', () {
      final json = {
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
      };

      final category = MagentoCategory.fromJson(json);

      expect(category.children, isNotNull);
      expect(category.children!.length, 1);
      expect(category.children![0].children, isNotNull);
      expect(category.children![0].children!.length, 1);
      expect(category.children![0].children![0].name, 'Grandchild Category');
    });

    test('should handle id as int', () {
      final json = {
        'id': 2,
        'uid': 'uid-2',
        'name': 'Test Category',
      };

      final category = MagentoCategory.fromJson(json);

      expect(category.id, '2');
    });

    test('should handle uid instead of id', () {
      final json = {
        'uid': 'uid-2',
        'name': 'Test Category',
      };

      final category = MagentoCategory.fromJson(json);

      expect(category.id, 'uid-2');
      expect(category.uid, 'uid-2');
    });

    test('should handle position as string', () {
      final json = {
        'id': '2',
        'uid': 'uid-2',
        'name': 'Test Category',
        'position': '1',
      };

      final category = MagentoCategory.fromJson(json);

      expect(category.position, 1);
    });

    test('should handle level as string', () {
      final json = {
        'id': '2',
        'uid': 'uid-2',
        'name': 'Test Category',
        'level': '2',
      };

      final category = MagentoCategory.fromJson(json);

      expect(category.level, 2);
    });

    test('should handle productCount as string', () {
      final json = {
        'id': '2',
        'uid': 'uid-2',
        'name': 'Test Category',
        'product_count': '10',
      };

      final category = MagentoCategory.fromJson(json);

      expect(category.productCount, 10);
    });

    test('should handle null values', () {
      final json = {
        'id': '2',
        'uid': 'uid-2',
        'name': 'Test Category',
        'url_path': null,
        'url_key': null,
        'description': null,
        'image': null,
        'position': null,
        'level': null,
        'path': null,
        'product_count': null,
        'children': null,
      };

      final category = MagentoCategory.fromJson(json);

      expect(category.urlPath, isNull);
      expect(category.urlKey, isNull);
      expect(category.description, isNull);
      expect(category.image, isNull);
      expect(category.position, isNull);
      expect(category.level, isNull);
      expect(category.path, isNull);
      expect(category.productCount, isNull);
      expect(category.children, isNull);
    });

    test('should handle invalid position string', () {
      final json = {
        'id': '2',
        'uid': 'uid-2',
        'name': 'Test Category',
        'position': 'invalid',
      };

      final category = MagentoCategory.fromJson(json);

      expect(category.position, isNull);
    });

    test('should handle invalid level string', () {
      final json = {
        'id': '2',
        'uid': 'uid-2',
        'name': 'Test Category',
        'level': 'invalid',
      };

      final category = MagentoCategory.fromJson(json);

      expect(category.level, isNull);
    });

    test('should handle invalid productCount string', () {
      final json = {
        'id': '2',
        'uid': 'uid-2',
        'name': 'Test Category',
        'product_count': 'invalid',
      };

      final category = MagentoCategory.fromJson(json);

      expect(category.productCount, isNull);
    });

    test('should handle empty children array', () {
      final json = {
        'id': '2',
        'uid': 'uid-2',
        'name': 'Test Category',
        'children': [],
      };

      final category = MagentoCategory.fromJson(json);

      expect(category.children, isEmpty);
    });
  });
}
