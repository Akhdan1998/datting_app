part of '../../pages.dart';

class MeController extends GetxController {
  // profile (dari Firebase user)
  final uid = ''.obs;
  final name = ''.obs;
  final email = ''.obs;
  final photoUrl = ''.obs;

  // optional fallback / demo fields
  final age = 24.obs;
  final city = 'Jakarta'.obs;
  final job = 'Mobile Developer'.obs;
  final verified =
      false.obs;

  // completion
  final completion = 0.72.obs;

  // quick actions count
  final likesYou = 12.obs;
  final boosts = 2.obs;
  final superLikes = 5.obs;

  // toggles
  final showOnDiscovery = true.obs;
  final showDistance = true.obs;
  final showOnlineStatus = true.obs;
  final readReceipts = false.obs;

  // values
  final distanceKm = 10.obs;
  final ageMin = 22.obs;
  final ageMax = 30.obs;
  final preference = 'Women'.obs;

  late final StreamSubscription<User?> _authSub;

  @override
  void onInit() {
    super.onInit();

    // set awal kalau sudah login sebelum masuk page
    _applyUser(AuthService.instance.currentUser);

    // listen perubahan login/logout
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      debugPrint('[MeController] authStateChanges: user=${user?.uid}');
      _applyUser(user);
    });
  }

  void _applyUser(User? user) {
    if (user == null) {
      uid.value = '';
      name.value = 'Guest';
      email.value = '';
      photoUrl.value = '';
      verified.value = false;
      return;
    }

    uid.value = user.uid;
    email.value = user.email ?? '';

    // Apple kadang displayName kosong. Google biasanya ada.
    name.value = (user.displayName?.trim().isNotEmpty ?? false)
        ? user.displayName!.trim()
        : (email.value.isNotEmpty ? email.value.split('@').first : 'User');

    photoUrl.value = user.photoURL ?? '';

    // NOTE: Firebase user.emailVerified biasanya untuk email/password flow.
    // Google/Apple tidak selalu meaningful di sini.
    verified.value = user.emailVerified;

    debugPrint(
      '[MeController] applied user: uid=${uid.value}, name=${name.value}, email=${email.value}, photo=${photoUrl.value.isNotEmpty}',
    );
  }

  @override
  void onClose() {
    _authSub.cancel();
    super.onClose();
  }

  // actions...
  void openEditProfile() => debugPrint('[Me] Edit Profile tapped');

  void openPreviewProfile() => debugPrint('[Me] Preview Profile tapped');

  void openLocation() => debugPrint('[Me] Location');

  void openDistance() => debugPrint('[Me] Distance');

  void openAgeRange() => debugPrint('[Me] Age range');

  void openPreference() => debugPrint('[Me] Preference');

  void openFilters() => debugPrint('[Me] Advanced filters');

  void openVerification() => debugPrint('[Me] Verification');

  void openBlockList() => debugPrint('[Me] Block list');

  void openPrivacy() => debugPrint('[Me] Privacy');

  void openNotifications() => debugPrint('[Me] Notifications');

  void openSubscription() => debugPrint('[Me] Subscription');

  void openConnectedAccounts() => debugPrint('[Me] Connected accounts');

  Future<void> logout() async {
    await AuthService.instance.signOut();
    Get.offAll(() => const SignIn());
  }

  void deleteAccount() => debugPrint('[Me] Delete account');
}

extension on MeController {
  void openSettings() => debugPrint('[Me] Settings');
}
