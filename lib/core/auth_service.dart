part of '../../pages.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const ['email', 'profile'],
  );

  User? get currentUser => _auth.currentUser;

  Future<void> init() async {
    debugPrint('[AuthService] init called');
  }

  Future<UserCredential> signInWithGoogle() async {
    debugPrint('[AuthService] signInWithGoogle start');

    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint('[AuthService] signInWithGoogle cancelled by user');
        throw Exception('Sign-in cancelled');
      }

      debugPrint('[AuthService] Google user selected: email=${googleUser.email}');

      final googleAuth = await googleUser.authentication;

      final hasIdToken = (googleAuth.idToken != null && googleAuth.idToken!.isNotEmpty);
      final hasAccessToken = (googleAuth.accessToken != null && googleAuth.accessToken!.isNotEmpty);

      debugPrint(
        '[AuthService] Google auth tokens present: idToken=$hasIdToken, accessToken=$hasAccessToken',
      );

      if (!hasIdToken && !hasAccessToken) {
        throw Exception('Google auth token is missing (idToken/accessToken null)');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCred = await _auth.signInWithCredential(credential);

      debugPrint(
        '[AuthService] Firebase signInWithCredential success: uid=${userCred.user?.uid}',
      );

      return userCred;
    } on FirebaseAuthException catch (e, st) {
      debugPrint('[AuthService] FirebaseAuthException (Google): code=${e.code}, message=${e.message}');
      debugPrint('[AuthService] STACKTRACE:\n$st');
      rethrow;
    } catch (e, st) {
      debugPrint('[AuthService] signInWithGoogle ERROR: $e');
      debugPrint('[AuthService] STACKTRACE:\n$st');
      rethrow;
    } finally {
      debugPrint('[AuthService] signInWithGoogle end');
    }
  }

  Future<UserCredential> signInWithApple() async {
    debugPrint('[AuthService] signInWithApple start');

    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    try {
      debugPrint('[AuthService] platform=$defaultTargetPlatform isWeb=$kIsWeb');

      debugPrint('[AuthService] Requesting AppleID credential (nonce generated)');

      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final idToken = appleIdCredential.identityToken;
      final hasIdToken = idToken != null && idToken.isNotEmpty;

      debugPrint(
        '[AuthService] Apple credential received: '
            'hasIdentityToken=$hasIdToken, '
            'email=${appleIdCredential.email}, '
            'givenName=${appleIdCredential.givenName}, '
            'familyName=${appleIdCredential.familyName}',
      );

      if (!hasIdToken) {
        throw Exception('Apple identityToken is missing (check capability/signing)');
      }

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: idToken,
        rawNonce: rawNonce,
      );

      final userCred = await _auth.signInWithCredential(oauthCredential);

      debugPrint(
        '[AuthService] Firebase signInWithCredential (Apple) success: uid=${userCred.user?.uid}',
      );

      return userCred;
    } on SignInWithAppleAuthorizationException catch (e, st) {
      debugPrint('[AuthService] Apple Auth Exception: code=${e.code}, message=${e.message}');
      debugPrint('[AuthService] STACKTRACE:\n$st');

      // Mapping pesan biar jelas
      if (e.code == AuthorizationErrorCode.canceled) {
        throw Exception('Login Apple dibatalkan');
      }

      // Unknown 1000: umumnya konfigurasi / simulator
      throw Exception(
        'Login Apple gagal (iOS error ${e.code}). '
            'Coba jalankan di real device dan pastikan capability "Sign In with Apple" aktif di Xcode.',
      );
    } on FirebaseAuthException catch (e, st) {
      debugPrint('[AuthService] FirebaseAuthException (Apple): code=${e.code}, message=${e.message}');
      debugPrint('[AuthService] STACKTRACE:\n$st');
      rethrow;
    } catch (e, st) {
      debugPrint('[AuthService] signInWithApple ERROR: $e');
      debugPrint('[AuthService] STACKTRACE:\n$st');
      rethrow;
    } finally {
      debugPrint('[AuthService] signInWithApple end');
    }
  }

  Future<void> signOut() async {
    debugPrint('[AuthService] signOut start');
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      debugPrint('[AuthService] signOut success');
    } catch (e, st) {
      debugPrint('[AuthService] signOut ERROR: $e');
      debugPrint('[AuthService] STACKTRACE:\n$st');
      rethrow;
    }
  }

  // ===== helpers for Apple nonce =====
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}