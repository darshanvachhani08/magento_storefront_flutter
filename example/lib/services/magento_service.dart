import 'package:magento_storefront_flutter/magento_storefront_flutter.dart';

/// Service class to manage Magento SDK instance
class MagentoService {
  static const String defaultBaseUrl = 'https://ideaoman.bytestechnolab.net/graphql';
  static const String defaultStoreCode = 'default';

  static MagentoSDK? _sdk;
  static MagentoConfig? _config;

  /// Initialize the SDK with configuration
  /// If config is not provided, attempts to load from storage
  static void initialize({
    String? baseUrl,
    String? storeCode,
  }) {
    // Use provided values or defaults
    final effectiveBaseUrl = baseUrl ?? defaultBaseUrl;
    final effectiveStoreCode = storeCode ?? defaultStoreCode;

    _config = MagentoConfig(
      baseUrl: effectiveBaseUrl,
      storeCode: effectiveStoreCode,
      enableDebugLogging: true,
    );
    _sdk = MagentoSDK(config: _config!);
  }

  /// Get the SDK instance
  static MagentoSDK? get sdk => _sdk;

  /// Get the current configuration
  static MagentoConfig? get config => _config;

  /// Check if SDK is initialized
  static bool get isInitialized => _sdk != null;

  /// Dispose the SDK
  static void dispose() {
    _sdk?.dispose();
    _sdk = null;
    _config = null;
  }

  /// Reinitialize with new config
  static void reinitialize({
    required String baseUrl,
    String? storeCode,
  }) {
    dispose();
    initialize(baseUrl: baseUrl, storeCode: storeCode);
  }

  /// Try to initialize from saved storage
  static bool tryInitializeFromStorage() {
    try {
      initialize();
      return _sdk != null;
    } catch (e) {
      return false;
    }
  }
}
