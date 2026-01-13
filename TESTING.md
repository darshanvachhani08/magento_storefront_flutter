# Testing Guide

This document provides comprehensive instructions on how to run the test suite for the Magento Storefront Flutter SDK.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Running Tests](#running-tests)
- [Test Structure](#test-structure)
- [Running Specific Tests](#running-specific-tests)
- [Test Coverage](#test-coverage)
- [Troubleshooting](#troubleshooting)

## Prerequisites

Before running tests, ensure you have:

1. **Flutter SDK** installed and configured
2. **Dependencies installed**:
   ```bash
   flutter pub get
   ```

3. **Mock files generated** (required for unit tests):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

   This generates the `.mocks.dart` files used by the test suite.

## Running Tests

### Run All Tests

To run the complete test suite:

```bash
flutter test
```

This will execute all unit tests and display a summary at the end.

### Run Tests with Verbose Output

For more detailed output during test execution:

```bash
flutter test --verbose
```

### Run Tests in Watch Mode

To automatically re-run tests when files change:

```bash
flutter test --watch
```

This is useful during development as it provides immediate feedback on code changes.

## Test Structure

The test suite is organized into the following directories:

```
test/
├── core/                    # Core functionality tests
│   ├── magento_client_test.dart
│   ├── magento_config_test.dart
│   ├── magento_exception_test.dart
│   ├── error_mapper_test.dart
│   └── graphql_interceptor_test.dart
├── models/                  # Model serialization tests
│   ├── product_test.dart
│   ├── category_test.dart
│   ├── cart_test.dart
│   └── store_test.dart
├── auth/                    # Authentication tests
│   └── magento_auth_test.dart
├── store/                   # Store configuration tests
│   └── magento_store_test.dart
├── catalog/                 # Catalog tests
│   ├── magento_categories_test.dart
│   ├── magento_products_test.dart
│   └── magento_search_test.dart
├── cart/                    # Shopping cart tests
│   └── magento_cart_test.dart
├── custom/                  # Custom query tests
│   └── magento_custom_query_test.dart
├── integration/             # Integration tests (require real Magento instance)
│   └── integration_test.dart
├── helpers/                 # Test utilities and helpers
│   ├── mock_http_client.dart
│   ├── test_data.dart
│   └── test_utils.dart
└── magento_sdk_test.dart    # Main SDK initialization tests
```

## Running Specific Tests

### Run Tests in a Specific Directory

Run all tests in a directory:

```bash
# Run all core tests
flutter test test/core/

# Run all model tests
flutter test test/models/

# Run all auth tests
flutter test test/auth/
```

### Run a Specific Test File

Run tests from a single file:

```bash
flutter test test/core/magento_client_test.dart
flutter test test/auth/magento_auth_test.dart
flutter test test/models/product_test.dart
```

### Run Tests Matching a Pattern

Run tests whose names match a pattern:

```bash
# Run all tests with "login" in the name
flutter test --name login

# Run all tests with "error" in the name
flutter test --name error
```

### Run Tests by Tags

Skip integration tests (which require a real Magento instance):

```bash
flutter test --exclude-tags=integration
```

Run only integration tests:

```bash
flutter test --tags=integration
```

## Test Coverage

### Generate Coverage Report

To generate a test coverage report:

```bash
flutter test --coverage
```

This creates a `coverage` directory with coverage data in LCOV format.

### View Coverage Report

After generating coverage, you can view it using:

```bash
# Install lcov (if not already installed)
# macOS: brew install lcov
# Linux: sudo apt-get install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open the report
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

### Coverage Thresholds

The test suite aims for:
- **Core modules**: 90%+ coverage
- **Feature modules**: 85%+ coverage
- **Models**: 95%+ coverage

## Test Types

### Unit Tests

Unit tests use mocked dependencies and test individual components in isolation. They:
- Use `mockito` for creating mock objects
- Test success and error scenarios
- Verify correct data parsing and transformation
- Test edge cases and null handling

Example:
```bash
flutter test test/core/magento_client_test.dart
```

### Integration Tests

Integration tests require a real Magento instance and test end-to-end flows. They:
- Make actual API calls to a Magento server
- Test complete user workflows
- Verify real-world scenarios

**Note**: Integration tests are skipped by default. To run them, you need:
1. A running Magento instance
2. Valid API credentials
3. Run with: `flutter test --tags=integration`

## Troubleshooting

### Mock Files Not Generated

If you see errors about missing `.mocks.dart` files:

```bash
# Clean and regenerate mocks
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Tests Failing Due to Import Errors

If tests fail with import errors:

1. Ensure dependencies are installed:
   ```bash
   flutter pub get
   ```

2. Regenerate mock files:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. Clean and rebuild:
   ```bash
   flutter clean
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```

### Timeout Issues

If tests are timing out:

1. Check your network connection (for integration tests)
2. Increase timeout in test files if needed
3. Run tests individually to identify slow tests

### Logger Output in Tests

The test suite uses the `logger` package for logging. You may see colored log output during test execution. This is expected and helps with debugging.

To reduce log verbosity, you can modify the logger configuration in `lib/core/magento_logger.dart`.

## Best Practices

1. **Run tests before committing**: Always run the full test suite before committing changes
   ```bash
   flutter test
   ```

2. **Run specific tests during development**: When working on a specific feature, run only relevant tests
   ```bash
   flutter test test/catalog/magento_products_test.dart
   ```

3. **Use watch mode for TDD**: Use `--watch` mode when following Test-Driven Development
   ```bash
   flutter test --watch
   ```

4. **Check coverage regularly**: Generate coverage reports to identify untested code
   ```bash
   flutter test --coverage
   ```

5. **Keep tests isolated**: Each test should be independent and not rely on other tests

## Continuous Integration

The test suite is designed to run in CI/CD pipelines. Example GitHub Actions workflow:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.4'
      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: flutter test --coverage
```

## Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Mockito Package](https://pub.dev/packages/mockito)
- [Build Runner Documentation](https://pub.dev/packages/build_runner)

## Test Statistics

The current test suite includes:
- **244+ unit tests** covering all modules
- **Core functionality**: 100% coverage
- **Model serialization**: Comprehensive edge case testing
- **Error handling**: All exception types tested
- **Integration tests**: End-to-end workflow testing

## Support

If you encounter issues running tests:

1. Check this documentation
2. Review the error messages carefully
3. Ensure all prerequisites are met
4. Try cleaning and rebuilding:
   ```bash
   flutter clean
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   flutter test
   ```

For more information, refer to the main [README.md](README.md) file.
