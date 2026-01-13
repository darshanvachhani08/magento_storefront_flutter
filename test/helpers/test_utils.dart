import 'package:http/http.dart' as http;
import 'package:magento_storefront_flutter/core/magento_config.dart';

/// Common test utilities
class TestUtils {
  /// Create a test MagentoConfig
  static MagentoConfig createTestConfig({
    String baseUrl = 'https://test.magento.com',
    String? storeCode,
    Map<String, String>? customHeaders,
    int timeoutSeconds = 30,
    bool enableDebugLogging = false,
  }) {
    return MagentoConfig(
      baseUrl: baseUrl,
      storeCode: storeCode,
      customHeaders: customHeaders,
      timeoutSeconds: timeoutSeconds,
      enableDebugLogging: enableDebugLogging,
    );
  }

  /// Create a mock HTTP response
  static http.Response createMockResponse({
    required int statusCode,
    required String body,
    Map<String, String>? headers,
  }) {
    return http.Response(
      body,
      statusCode,
      headers: headers ?? {'content-type': 'application/json'},
    );
  }

  /// Create a successful JSON response
  static http.Response createSuccessResponse({
    required Map<String, dynamic> data,
    int statusCode = 200,
  }) {
    return createMockResponse(
      statusCode: statusCode,
      body: '{"data": ${_encodeJson(data)}}',
    );
  }

  /// Create an error JSON response
  static http.Response createErrorResponse({
    required List<Map<String, dynamic>> errors,
    int statusCode = 200,
  }) {
    return createMockResponse(
      statusCode: statusCode,
      body: '{"errors": ${_encodeJson(errors)}}',
    );
  }

  /// Create an HTTP error response
  static http.Response createHttpErrorResponse({
    required int statusCode,
    String body = 'Error',
  }) {
    return createMockResponse(
      statusCode: statusCode,
      body: body,
    );
  }

  /// Encode JSON (simple implementation for testing)
  static String _encodeJson(dynamic data) {
    // In real tests, use jsonEncode from dart:convert
    // This is a placeholder - actual implementation will use proper JSON encoding
    if (data is Map) {
      final entries = data.entries.map((e) => '"${e.key}": ${_encodeValue(e.value)}');
      return '{${entries.join(', ')}}';
    } else if (data is List) {
      final items = data.map((e) => _encodeValue(e)).join(', ');
      return '[$items]';
    }
    return _encodeValue(data);
  }

  static String _encodeValue(dynamic value) {
    if (value == null) return 'null';
    if (value is String) return '"$value"';
    if (value is num) return value.toString();
    if (value is bool) return value.toString();
    if (value is Map) return _encodeJson(value);
    if (value is List) return _encodeJson(value);
    return '"$value"';
  }
}
