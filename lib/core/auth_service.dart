part of '../../pages.dart';

class AuthService {
  AuthService._();

  static final instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const ['email', 'profile'],
  );

  Future<void> init() async {
    debugPrint('[AuthService] init called');
  }

  String? _detectProviderId(User? user) {
    final providers = user?.providerData ?? const <UserInfo>[];
    if (providers.isEmpty) return null;
    return providers.first.providerId;
  }

  Future<bool> _upsertCurrentUser(User user) async {
    final providerId = _detectProviderId(user);
    final provider = providerId == 'google.com'
        ? 'google'
        : providerId == 'apple.com'
            ? 'apple'
            : providerId;

    final payload = DatingUser(
      uid: user.uid,
      name: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      provider: provider,
      isProfileComplete: false,
    );

    final isNewUser = await UserRepo.instance.ensureUserInitialized(payload);

    debugPrint(
        '[AuthService] ensureUserInitialized done: uid=${user.uid} isNew=$isNewUser');
    return isNewUser;
  }

  Future<(UserCredential cred, bool isNewUser)> signInWithGoogle() async {
    debugPrint('[AuthService] signInWithGoogle start');

    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Sign-in cancelled');
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final userCred = await _auth.signInWithCredential(credential);

    await _auth.authStateChanges().first;

    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User is null after sign-in');
    }

    await user.getIdToken(true);

    final isNewUser = userCred.additionalUserInfo?.isNewUser ?? false;

    debugPrint(
      '[AuthService] signInWithGoogle success uid=${user.uid} isNew=$isNewUser',
    );

    return (userCred, isNewUser);
  }

  Future<UserCredential> signInWithApple() async {
    debugPrint('[AuthService] signInWithApple start');

    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    debugPrint(
        '[AuthService] rawNonceLen=${rawNonce.length} nonceLen=${nonce.length}');

    final appleIdCredential = await SignInWithApple.getAppleIDCredential(
      scopes: const [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final idToken = appleIdCredential.identityToken;
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Apple identityToken missing');
    }

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: idToken,
      rawNonce: rawNonce,
    );

    return _auth.signInWithCredential(oauthCredential);
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signOut() async {
    debugPrint('[AuthService] signOut start');
    try {
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      await _auth.signOut();
      debugPrint('[AuthService] signOut success');
    } catch (e, st) {
      debugPrint('[AuthService] signOut ERROR: $e');
      debugPrint('[AuthService] STACKTRACE:\n$st');
      rethrow;
    }
  }
}
