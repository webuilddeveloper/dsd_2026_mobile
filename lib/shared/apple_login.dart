import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<AuthorizationCredentialAppleID?> loginApple() async {
  try {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    return credential;
  } catch (e) {
    print('Apple login error: $e');
    return null;
  }
}

