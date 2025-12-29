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

  Future<void> _upsertCurrentUser(User user) async {
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

    await UserRepo.instance.upsertUser(payload);

    debugPrint('[AuthService] upsert user to Firestore done: uid=${user.uid}');
  }

  Future<UserCredential> signInWithGoogle() async {
    debugPrint('[AuthService] signInWithGoogle start');
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('[AuthService] signInWithGoogle cancelled by user');
        throw Exception('Sign-in cancelled');
      }

      debugPrint(
          '[AuthService] Google user selected: email=${googleUser.email}');

      final googleAuth = await googleUser.authentication;

      final hasIdToken =
          (googleAuth.idToken != null && googleAuth.idToken!.isNotEmpty);
      final hasAccessToken = (googleAuth.accessToken != null &&
          googleAuth.accessToken!.isNotEmpty);

      debugPrint(
        '[AuthService] Google tokens: idToken=$hasIdToken accessToken=$hasAccessToken',
      );

      if (!hasIdToken && !hasAccessToken) {
        throw Exception('Google auth token missing (idToken/accessToken null)');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCred = await _auth.signInWithCredential(credential);

      final user = userCred.user;
      if (user != null) {
        await _upsertCurrentUser(user);
      }

      debugPrint('[AuthService] signInWithGoogle success: uid=${user?.uid}');
      return userCred;
    } on FirebaseAuthException catch (e, st) {
      debugPrint(
          '[AuthService] FirebaseAuthException(Google): code=${e.code}, msg=${e.message}');
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

    debugPrint('[AuthService] rawNonceLen=${rawNonce.length} nonceLen=${nonce.length}');

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

class UserRepo {
  UserRepo._();

  static final instance = UserRepo._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> upsertUser(DatingUser user) async {
    await _db
        .collection('users')
        .doc(user.uid)
        .set(user.toMap(), SetOptions(merge: true));
  }

  Stream<List<DatingUser>> streamDiscoverUsers({required String myUid}) {
    return FirebaseFirestore.instance
        .collection('publicProfiles')
        .where(FieldPath.documentId, isNotEqualTo: myUid)
        .orderBy(FieldPath.documentId)
        .limit(50)
        .snapshots()
        .map((snap) => snap.docs.map((d) => DatingUser.fromDoc(d)).toList());
  }
}
