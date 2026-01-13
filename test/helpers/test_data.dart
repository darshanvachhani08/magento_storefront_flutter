/// Sample JSON responses for testing
class TestData {
  // Successful GraphQL response
  static Map<String, dynamic> successfulGraphQLResponse({
    required Map<String, dynamic> data,
  }) {
    return {
      'data': data,
    };
  }

  // GraphQL error response
  static Map<String, dynamic> graphQLErrorResponse({
    required List<Map<String, dynamic>> errors,
  }) {
    return {
      'errors': errors,
    };
  }

  // Login response
  static Map<String, dynamic> loginResponse({required String token}) {
    return successfulGraphQLResponse(
      data: {
        'generateCustomerToken': {
          'token': token,
        },
      },
    );
  }

  // Register response
  static Map<String, dynamic> registerResponse({
    required String email,
    required String firstName,
    required String lastName,
  }) {
    return successfulGraphQLResponse(
      data: {
        'createCustomer': {
          'customer': {
            'email': email,
            'firstname': firstName,
            'lastname': lastName,
          },
        },
      },
    );
  }

  // Forgot password response
  static Map<String, dynamic> forgotPasswordResponse({bool success = true}) {
    return successfulGraphQLResponse(
      data: {
        'requestPasswordResetEmail': success,
      },
    );
  }

  // Store config response
  static Map<String, dynamic> storeConfigResponse({
    String? id,
    String? code,
    String? websiteId,
    String? locale,
    String? baseCurrencyCode,
    String? defaultDisplayCurrencyCode,
    String? timezone,
    String? weightUnit,
    String? baseUrl,
    String? secureBaseUrl,
    String? storeName,
    bool? catalogSearchEnabled,
    bool? useStoreInUrl,
  }) {
    return successfulGraphQLResponse(
      data: {
        'storeConfig': {
          if (id != null) 'id': id,
          if (code != null) 'code': code,
          if (websiteId != null) 'website_id': websiteId,
          if (locale != null) 'locale': locale,
          if (baseCurrencyCode != null) 'base_currency_code': baseCurrencyCode,
          if (defaultDisplayCurrencyCode != null)
            'default_display_currency_code': defaultDisplayCurrencyCode,
          if (timezone != null) 'timezone': timezone,
          if (weightUnit != null) 'weight_unit': weightUnit,
          if (baseUrl != null) 'base_url': baseUrl,
          if (secureBaseUrl != null) 'secure_base_url': secureBaseUrl,
          if (storeName != null) 'store_name': storeName,
          if (catalogSearchEnabled != null)
            'catalog_search_enabled': catalogSearchEnabled,
          if (useStoreInUrl != null) 'use_store_in_url': useStoreInUrl,
        },
      },
    );
  }

  // Stores list response
  static Map<String, dynamic> storesResponse({
    required List<Map<String, dynamic>> stores,
  }) {
    return successfulGraphQLResponse(
      data: {
        'stores': stores,
      },
    );
  }

  // Category response
  static Map<String, dynamic> categoryResponse({
    required String id,
    required String uid,
    required String name,
    String? urlPath,
    String? urlKey,
    String? description,
    String? image,
    int? position,
    int? level,
    String? path,
    int? productCount,
    List<Map<String, dynamic>>? children,
  }) {
    return successfulGraphQLResponse(
      data: {
        'category': {
          'id': id,
          'uid': uid,
          'name': name,
          if (urlPath != null) 'url_path': urlPath,
          if (urlKey != null) 'url_key': urlKey,
          if (description != null) 'description': description,
          if (image != null) 'image': image,
          if (position != null) 'position': position,
          if (level != null) 'level': level,
          if (path != null) 'path': path,
          if (productCount != null) 'product_count': productCount,
          if (children != null) 'children': children,
        },
      },
    );
  }

  // Category tree response
  static Map<String, dynamic> categoryTreeResponse({
    required List<Map<String, dynamic>> categories,
  }) {
    return successfulGraphQLResponse(
      data: {
        'categoryList': categories,
      },
    );
  }

  // Product response
  static Map<String, dynamic> productResponse({
    required String id,
    required String sku,
    required String name,
    String? urlKey,
    String? description,
    String? shortDescription,
    Map<String, dynamic>? image,
    Map<String, dynamic>? priceRange,
    String? stockStatus,
  }) {
    return successfulGraphQLResponse(
      data: {
        'products': {
          'items': [
            {
              'id': id,
              'sku': sku,
              'name': name,
              if (urlKey != null) 'url_key': urlKey,
              if (description != null) 'description': description,
              if (shortDescription != null)
                'short_description': shortDescription,
              if (image != null) 'image': image,
              if (priceRange != null) 'price_range': priceRange,
              if (stockStatus != null) 'stock_status': stockStatus,
            },
          ],
        },
      },
    );
  }

  // Products list response
  static Map<String, dynamic> productsListResponse({
    required List<Map<String, dynamic>> items,
    int? totalCount,
    Map<String, dynamic>? pageInfo,
  }) {
    return successfulGraphQLResponse(
      data: {
        'products': {
          'items': items,
          if (totalCount != null) 'total_count': totalCount,
          if (pageInfo != null) 'page_info': pageInfo,
        },
      },
    );
  }

  // Cart creation response
  static Map<String, dynamic> createCartResponse({required String cartId}) {
    return successfulGraphQLResponse(
      data: {
        'createEmptyCart': cartId,
      },
    );
  }

  // Cart response
  static Map<String, dynamic> cartResponse({
    required String cartId,
    required List<Map<String, dynamic>> items,
    Map<String, dynamic>? prices,
    int? totalQuantity,
  }) {
    return successfulGraphQLResponse(
      data: {
        'cart': {
          'id': cartId,
          'items': items,
          if (prices != null) 'prices': prices,
          if (totalQuantity != null) 'total_quantity': totalQuantity,
        },
      },
    );
  }

  // Add product to cart response
  static Map<String, dynamic> addProductToCartResponse({
    required String cartId,
    required List<Map<String, dynamic>> items,
    Map<String, dynamic>? prices,
    int? totalQuantity,
  }) {
    return successfulGraphQLResponse(
      data: {
        'addProductsToCart': {
          'cart': {
            'id': cartId,
            'items': items,
            if (prices != null) 'prices': prices,
            if (totalQuantity != null) 'total_quantity': totalQuantity,
          },
        },
      },
    );
  }

  // Update cart item response
  static Map<String, dynamic> updateCartItemResponse({
    required String cartId,
    required List<Map<String, dynamic>> items,
    Map<String, dynamic>? prices,
    int? totalQuantity,
  }) {
    return successfulGraphQLResponse(
      data: {
        'updateCartItems': {
          'cart': {
            'id': cartId,
            'items': items,
            if (prices != null) 'prices': prices,
            if (totalQuantity != null) 'total_quantity': totalQuantity,
          },
        },
      },
    );
  }

  // Remove cart item response
  static Map<String, dynamic> removeCartItemResponse({
    required String cartId,
    required List<Map<String, dynamic>> items,
    Map<String, dynamic>? prices,
    int? totalQuantity,
  }) {
    return successfulGraphQLResponse(
      data: {
        'removeItemFromCart': {
          'cart': {
            'id': cartId,
            'items': items,
            if (prices != null) 'prices': prices,
            if (totalQuantity != null) 'total_quantity': totalQuantity,
          },
        },
      },
    );
  }

  // Sample product data
  static Map<String, dynamic> sampleProduct({
    String id = '1',
    String sku = 'test-sku',
    String name = 'Test Product',
    String? urlKey,
    String? description,
    String? shortDescription,
    Map<String, dynamic>? image,
    Map<String, dynamic>? priceRange,
    String stockStatus = 'IN_STOCK',
  }) {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      if (urlKey != null) 'url_key': urlKey,
      if (description != null) 'description': description,
      if (shortDescription != null) 'short_description': shortDescription,
      if (image != null) 'image': image,
      if (priceRange != null) 'price_range': priceRange,
      'stock_status': stockStatus,
    };
  }

  // Sample price range
  static Map<String, dynamic> samplePriceRange({
    double regularPrice = 100.0,
    double finalPrice = 80.0,
    String currency = 'USD',
  }) {
    return {
      'minimum_price': {
        'regular_price': {
          'value': regularPrice,
          'currency': currency,
        },
        'final_price': {
          'value': finalPrice,
          'currency': currency,
        },
      },
      'maximum_price': {
        'regular_price': {
          'value': regularPrice,
          'currency': currency,
        },
        'final_price': {
          'value': finalPrice,
          'currency': currency,
        },
      },
    };
  }

  // Sample image
  static Map<String, dynamic> sampleImage({
    String url = 'https://example.com/image.jpg',
    String? label,
    int? position,
  }) {
    return {
      'url': url,
      if (label != null) 'label': label,
      if (position != null) 'position': position,
    };
  }

  // Sample cart item
  static Map<String, dynamic> sampleCartItem({
    String itemId = '1',
    required Map<String, dynamic> product,
    int quantity = 1,
    Map<String, dynamic>? prices,
  }) {
    return {
      'id': itemId,
      'product': product,
      'quantity': quantity,
      if (prices != null) 'prices': prices,
    };
  }

  // Sample cart prices
  static Map<String, dynamic> sampleCartPrices({
    double grandTotal = 100.0,
    double subtotalExcludingTax = 90.0,
    double subtotalIncludingTax = 100.0,
    String currency = 'USD',
  }) {
    return {
      'grand_total': {
        'value': grandTotal,
        'currency': currency,
      },
      'subtotal_excluding_tax': {
        'value': subtotalExcludingTax,
        'currency': currency,
      },
      'subtotal_including_tax': {
        'value': subtotalIncludingTax,
        'currency': currency,
      },
    };
  }

  // Sample GraphQL error
  static Map<String, dynamic> sampleGraphQLError({
    required String message,
    List<Map<String, dynamic>>? locations,
    List<dynamic>? path,
    Map<String, dynamic>? extensions,
  }) {
    return {
      'message': message,
      if (locations != null) 'locations': locations,
      if (path != null) 'path': path,
      if (extensions != null) 'extensions': extensions,
    };
  }

  // Sample error location
  static Map<String, dynamic> sampleErrorLocation({
    int line = 1,
    int column = 1,
  }) {
    return {
      'line': line,
      'column': column,
    };
  }
}
