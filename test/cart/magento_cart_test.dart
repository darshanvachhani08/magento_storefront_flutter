import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:magento_storefront_flutter/cart/magento_cart.dart';
import 'package:magento_storefront_flutter/core/magento_client.dart';
import 'package:magento_storefront_flutter/core/magento_exception.dart';
import '../helpers/test_data.dart';

import 'magento_cart_test.mocks.dart';

@GenerateMocks([MagentoClient])
void main() {
  late MockMagentoClient mockClient;
  late MagentoCartModule cart;

  setUp(() {
    mockClient = MockMagentoClient();
    cart = MagentoCartModule(mockClient);
  });

  tearDown(() {
    reset(mockClient);
  });

  group('createCart', () {
    test('should create cart successfully', () async {
      final response = TestData.createCartResponse(cartId: 'cart-123');

      when(mockClient.mutate(any)).thenAnswer((_) async => response);

      final createdCart = await cart.createCart();

      expect(createdCart.id, 'cart-123');
      expect(createdCart.items, isEmpty);
      expect(createdCart.totalQuantity, 0);
      expect(createdCart.isEmpty, true);
    });

    test('should throw exception when cart ID is empty', () async {
      final response = {
        'data': {
          'createEmptyCart': '',
        },
      };

      when(mockClient.mutate(any)).thenAnswer((_) async => response);

      expect(
        () => cart.createCart(),
        throwsA(isA<MagentoException>()),
      );
    });

    test('should throw exception when response data is null', () async {
      when(mockClient.mutate(any)).thenAnswer((_) async => <String, dynamic>{});

      expect(
        () => cart.createCart(),
        throwsA(isA<MagentoException>()),
      );
    });
  });

  group('addProductToCart', () {
    test('should add product to cart successfully with default quantity', () async {
      final response = TestData.addProductToCartResponse(
        cartId: 'cart-123',
        items: [
          TestData.sampleCartItem(
            itemId: '1',
            product: TestData.sampleProduct(),
            quantity: 1,
          ),
        ],
        totalQuantity: 1,
      );

      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final updatedCart = await cart.addProductToCart(
        cartId: 'cart-123',
        sku: 'test-sku',
      );

      expect(updatedCart.id, 'cart-123');
      expect(updatedCart.items.length, 1);
      expect(updatedCart.totalQuantity, 1);
    });

    test('should add product to cart with custom quantity', () async {
      final response = TestData.addProductToCartResponse(
        cartId: 'cart-123',
        items: [
          TestData.sampleCartItem(
            itemId: '1',
            product: TestData.sampleProduct(),
            quantity: 3,
          ),
        ],
        totalQuantity: 3,
      );

      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final updatedCart = await cart.addProductToCart(
        cartId: 'cart-123',
        sku: 'test-sku',
        quantity: 3,
      );

      expect(updatedCart.items[0].quantity, 3);
      expect(updatedCart.totalQuantity, 3);
    });

    test('should throw exception when response data is null', () async {
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => <String, dynamic>{});

      expect(
        () => cart.addProductToCart(
          cartId: 'cart-123',
          sku: 'test-sku',
        ),
        throwsA(isA<MagentoException>()),
      );
    });
  });

  group('getCart', () {
    test('should get cart successfully with items', () async {
      final response = TestData.cartResponse(
        cartId: 'cart-123',
        items: [
          TestData.sampleCartItem(
            itemId: '1',
            product: TestData.sampleProduct(),
            quantity: 2,
          ),
        ],
        totalQuantity: 2,
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final cartData = await cart.getCart('cart-123');

      expect(cartData, isNotNull);
      expect(cartData!.id, 'cart-123');
      expect(cartData.items.length, 1);
      expect(cartData.totalQuantity, 2);
    });

    test('should return empty cart', () async {
      final response = TestData.cartResponse(
        cartId: 'cart-123',
        items: [],
        totalQuantity: 0,
      );

      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final cartData = await cart.getCart('cart-123');

      expect(cartData, isNotNull);
      expect(cartData!.items, isEmpty);
    });

    test('should return null when cart not found', () async {
      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => {
            'data': {
              'cart': null,
            },
          });

      final cartData = await cart.getCart('non-existent');

      expect(cartData, isNull);
    });

    test('should throw exception when response data is null', () async {
      when(mockClient.query(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => <String, dynamic>{});

      expect(
        () => cart.getCart('cart-123'),
        throwsA(isA<MagentoException>()),
      );
    });
  });

  group('updateCartItem', () {
    test('should update cart item successfully', () async {
      final response = TestData.updateCartItemResponse(
        cartId: 'cart-123',
        items: [
          TestData.sampleCartItem(
            itemId: '1',
            product: TestData.sampleProduct(),
            quantity: 5,
          ),
        ],
        totalQuantity: 5,
      );

      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final updatedCart = await cart.updateCartItem(
        cartId: 'cart-123',
        itemId: '1',
        quantity: 5,
      );

      expect(updatedCart.items[0].quantity, 5);
      expect(updatedCart.totalQuantity, 5);
    });

    test('should throw exception when item ID is invalid', () {
      expect(
        () => cart.updateCartItem(
          cartId: 'cart-123',
          itemId: 'invalid',
          quantity: 1,
        ),
        throwsA(isA<MagentoException>()),
      );
    });

    test('should throw exception when response data is null', () async {
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => <String, dynamic>{});

      expect(
        () => cart.updateCartItem(
          cartId: 'cart-123',
          itemId: '1',
          quantity: 1,
        ),
        throwsA(isA<MagentoException>()),
      );
    });
  });

  group('removeCartItem', () {
    test('should remove cart item successfully', () async {
      final response = TestData.removeCartItemResponse(
        cartId: 'cart-123',
        items: [],
        totalQuantity: 0,
      );

      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final updatedCart = await cart.removeCartItem(
        cartId: 'cart-123',
        itemId: '1',
      );

      expect(updatedCart.items, isEmpty);
      expect(updatedCart.totalQuantity, 0);
    });

    test('should throw exception when item ID is invalid', () {
      expect(
        () => cart.removeCartItem(
          cartId: 'cart-123',
          itemId: 'invalid',
        ),
        throwsA(isA<MagentoException>()),
      );
    });

    test('should throw exception when response data is null', () async {
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => <String, dynamic>{});

      expect(
        () => cart.removeCartItem(
          cartId: 'cart-123',
          itemId: '1',
        ),
        throwsA(isA<MagentoException>()),
      );
    });
  });
}
