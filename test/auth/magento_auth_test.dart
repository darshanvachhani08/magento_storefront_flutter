import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:magento_storefront_flutter/auth/magento_auth.dart';
import 'package:magento_storefront_flutter/core/magento_client.dart';
import 'package:magento_storefront_flutter/core/magento_exception.dart';
import '../helpers/test_data.dart';

import 'magento_auth_test.mocks.dart';

@GenerateMocks([MagentoClient])
void main() {
  late MockMagentoClient mockClient;
  late MagentoAuth auth;

  setUp(() {
    mockClient = MockMagentoClient();
    auth = MagentoAuth(mockClient);
  });

  tearDown(() {
    reset(mockClient);
  });

  group('login', () {
    test('should login successfully with valid credentials', () async {
      final token = 'test-token-123';
      final response = TestData.loginResponse(token: token);

      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      final result = await auth.login('user@example.com', 'password');

      expect(result.token, token);
      verify(mockClient.setAuthToken(token)).called(1);
      verify(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).called(1);
    });

    test('should throw exception when response data is null', () async {
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => <String, dynamic>{});

      expect(
        () => auth.login('user@example.com', 'password'),
        throwsA(isA<MagentoAuthenticationException>()),
      );
    });

    test('should throw exception when token data is null', () async {
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => {
            'data': <String, dynamic>{},
          });

      await expectLater(
        auth.login('user@example.com', 'password'),
        throwsA(isA<MagentoAuthenticationException>()),
      );
    });

    test('should throw exception when token is empty string', () async {
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => {
            'data': {
              'generateCustomerToken': {
                'token': '',
              },
            },
          });

      await expectLater(
        auth.login('user@example.com', 'password'),
        throwsA(isA<MagentoAuthenticationException>()),
      );
    });

    test('should throw exception when token is empty', () async {
      final response = {
        'data': {
          'generateCustomerToken': {
            'token': '',
          },
        },
      };

      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      expect(
        () => auth.login('user@example.com', 'password'),
        throwsA(isA<MagentoAuthenticationException>()),
      );
    });

    test('should throw exception when GraphQL error occurs', () async {
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenThrow(MagentoGraphQLException('Invalid credentials'));

      expect(
        () => auth.login('user@example.com', 'password'),
        throwsA(isA<MagentoGraphQLException>()),
      );
    });

    test('should throw exception when network error occurs', () async {
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenThrow(MagentoNetworkException('Network error'));

      expect(
        () => auth.login('user@example.com', 'password'),
        throwsA(isA<MagentoNetworkException>()),
      );
    });
  });

  group('register', () {
    test('should register successfully and auto-login', () async {
      final registerResponse = TestData.registerResponse(
        email: 'user@example.com',
        firstName: 'John',
        lastName: 'Doe',
      );
      final loginResponse = TestData.loginResponse(token: 'test-token-123');

      var callCount = 0;
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async {
        callCount++;
        // First call is register, second is login
        if (callCount == 1) {
          return registerResponse;
        } else {
          return loginResponse;
        }
      });

      final result = await auth.register(
        email: 'user@example.com',
        password: 'password',
        firstName: 'John',
        lastName: 'Doe',
      );

      expect(result.token, 'test-token-123');
      verify(mockClient.setAuthToken('test-token-123')).called(1);
    });

    test('should throw exception when registration fails', () async {
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => {
            'data': <String, dynamic>{},
          });

      await expectLater(
        auth.register(
          email: 'user@example.com',
          password: 'password',
          firstName: 'John',
          lastName: 'Doe',
        ),
        throwsA(isA<MagentoAuthenticationException>()),
      );
    });

    test('should throw exception when createCustomer data is null', () async {
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => {
            'data': <String, dynamic>{},
          });

      await expectLater(
        auth.register(
          email: 'user@example.com',
          password: 'password',
          firstName: 'John',
          lastName: 'Doe',
        ),
        throwsA(isA<MagentoAuthenticationException>()),
      );
    });

    test('should throw exception when GraphQL error occurs', () async {
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenThrow(MagentoGraphQLException('Email already exists'));

      expect(
        () => auth.register(
          email: 'user@example.com',
          password: 'password',
          firstName: 'John',
          lastName: 'Doe',
        ),
        throwsA(isA<MagentoGraphQLException>()),
      );
    });
  });

  group('forgotPassword', () {
    test('should request password reset successfully', () async {
      final response = TestData.forgotPasswordResponse(success: true);

      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      await auth.forgotPassword('user@example.com');

      verify(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).called(1);
    });

    test('should throw exception when response data is null', () async {
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => <String, dynamic>{});

      expect(
        () => auth.forgotPassword('user@example.com'),
        throwsA(isA<MagentoAuthenticationException>()),
      );
    });

    test('should throw exception when success is false', () async {
      final response = TestData.forgotPasswordResponse(success: false);

      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenAnswer((_) async => response);

      expect(
        () => auth.forgotPassword('user@example.com'),
        throwsA(isA<MagentoAuthenticationException>()),
      );
    });

    test('should throw exception when network error occurs', () async {
      when(mockClient.mutate(
        any,
        variables: anyNamed('variables'),
      )).thenThrow(MagentoNetworkException('Network error'));

      expect(
        () => auth.forgotPassword('user@example.com'),
        throwsA(isA<MagentoNetworkException>()),
      );
    });
  });

  group('logout', () {
    test('should clear auth token', () {
      auth.logout();

      verify(mockClient.setAuthToken(null)).called(1);
    });
  });

  group('isAuthenticated', () {
    test('should return true when token exists', () {
      when(mockClient.authToken).thenReturn('test-token');

      expect(auth.isAuthenticated, true);
    });

    test('should return false when token is null', () {
      when(mockClient.authToken).thenReturn(null);

      expect(auth.isAuthenticated, false);
    });
  });
}
