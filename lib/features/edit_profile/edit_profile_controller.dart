part of '../../pages.dart';

class EditProfileController extends GetxController {
  final isLoading = true.obs;
  final isSaving = false.obs;
  final gender = Rxn<Gender>();
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final bioCtrl = TextEditingController();
  final jobCtrl = TextEditingController();
  final schoolCtrl = TextEditingController();

  final promptGreenFlagCtrl = TextEditingController();
  final promptWeekendCtrl = TextEditingController();
  final promptGetAlongCtrl = TextEditingController();

  final heightCm = 170.obs;

  final photos = <String>[].obs;
  final interests = <String>[].obs;

  final showOnDiscovery = true.obs;

  final completion = 0.0.obs;
  final profileReady = false.obs;

  String get _uid => AuthService.instance.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    _load();

    nameCtrl.addListener(_recalc);
    ageCtrl.addListener(_recalc);
    cityCtrl.addListener(_recalc);
    bioCtrl.addListener(_recalc);
    promptGreenFlagCtrl.addListener(_recalc);
    photos.listen((_) => _recalc());
    interests.listen((_) => _recalc());
    heightCm.listen((_) => _recalc());
    showOnDiscovery.listen((_) => _recalc());
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    cityCtrl.dispose();
    bioCtrl.dispose();
    jobCtrl.dispose();
    schoolCtrl.dispose();
    promptGreenFlagCtrl.dispose();
    promptWeekendCtrl.dispose();
    promptGetAlongCtrl.dispose();
    super.onClose();
  }

  Future<void> _load() async {
    try {
      final uid = _uid;
      if (uid.isEmpty) {
        isLoading.value = false;
        return;
      }

      final snap = await FirebaseFirestore.instance
          .collection('publicProfiles')
          .doc(uid)
          .get();

      final data = snap.data() ?? {};

      nameCtrl.text = (data['name'] ?? '') as String;
      cityCtrl.text = (data['city'] ?? '') as String;
      bioCtrl.text = (data['bio'] ?? '') as String;
      jobCtrl.text = (data['job'] ?? '') as String;
      schoolCtrl.text = (data['school'] ?? '') as String;

      final ageVal = data['age'];
      ageCtrl.text = ageVal == null ? '' : ageVal.toString();

      final hVal = data['heightCm'];
      if (hVal is num) heightCm.value = hVal.toInt();

      final photoUrl = (data['photoUrl'] ?? '') as String;
      final phs = (data['photos'] as List?)?.cast<String>() ?? [];
      photos.assignAll(
          phs.isNotEmpty ? phs : (photoUrl.isNotEmpty ? [photoUrl] : []));

      final ints = (data['interests'] as List?)?.cast<String>() ?? [];
      interests.assignAll(ints);

      promptGreenFlagCtrl.text = (data['promptGreenFlag'] ?? '') as String;
      promptWeekendCtrl.text = (data['promptWeekend'] ?? '') as String;
      promptGetAlongCtrl.text = (data['promptGetAlong'] ?? '') as String;

      final sod = data['showOnDiscovery'];
      if (sod is bool) showOnDiscovery.value = sod;

      _recalc();
    } catch (e) {
      debugPrint('[EditProfileController] load error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setPhotoAt(int index) async {
    final uid = _uid;
    if (uid.isEmpty) {
      debugPrint('[EditProfileController] setPhotoAt blocked: uid empty');
      Get.snackbar('Not logged in', 'Please login first.');
      return;
    }

    final b64 = await pickAndEncodePhotoBase64(uid: uid, slot: index);
    if (b64 == null) return;

    try {
      if (photos.length <= index) {
        while (photos.length < index) {
          photos.add('');
        }
        photos.add(b64);
      } else {
        photos[index] = b64;
      }

      photos.removeWhere((e) => e.trim().isEmpty);

      debugPrint('[EditProfileController] photos updated len=${photos.length}');
    } catch (e, st) {
      debugPrint('[EditProfileController] setPhotoAt error: $e');
      debugPrint('$st');
    }
  }

  Future<void> removePhotoAt(int index) async {
    if (index < 0 || index >= photos.length) return;
    photos.removeAt(index);
    debugPrint('[EditProfileController] photo removed index=$index');
  }

  void addInterest(String v) {
    final s = v.trim();
    if (s.isEmpty) return;
    if (interests.contains(s)) return;
    interests.add(s);
  }

  void removeInterest(String v) {
    interests.remove(v);
  }

  void _recalc() {
    final hasName = nameCtrl.text.trim().isNotEmpty;
    final hasAge = int.tryParse(ageCtrl.text.trim()) != null;
    final hasCity = cityCtrl.text.trim().isNotEmpty;
    final hasBio = bioCtrl.text.trim().length >= 20;
    final hasPhoto = photos.any((e) => e.trim().isNotEmpty);
    final hasPrompt = promptGreenFlagCtrl.text.trim().isNotEmpty ||
        promptWeekendCtrl.text.trim().isNotEmpty ||
        promptGetAlongCtrl.text.trim().isNotEmpty;

    double score = 0;
    score += hasName ? 0.18 : 0;
    score += hasAge ? 0.12 : 0;
    score += hasCity ? 0.12 : 0;
    score += hasBio ? 0.20 : 0;
    score += hasPhoto ? 0.20 : 0;
    score += hasPrompt ? 0.10 : 0;
    score += (interests.isNotEmpty) ? 0.08 : 0;

    completion.value = score.clamp(0.0, 1.0);
    profileReady.value = (hasName && hasAge && hasCity && hasBio && hasPhoto);
  }

  Future<void> save() async {
    if (isSaving.value) return;

    final uid = _uid;
    if (uid.isEmpty) {
      debugPrint('[EditProfileController] save aborted: uid is empty');
      return;
    }

    isSaving.value = true;

    debugPrint('[EditProfileController] save started uid=$uid');

    try {
      final data = <String, dynamic>{
        'uid': uid,
        'name': nameCtrl.text.trim(),
        'age': int.tryParse(ageCtrl.text.trim()),
        'city': cityCtrl.text.trim(),
        'bio': bioCtrl.text.trim(),
        'job': jobCtrl.text.trim(),
        'school': schoolCtrl.text.trim(),
        'heightCm': heightCm.value,
        'photos': photos.toList(),
        'photoUrl': photos.isNotEmpty ? photos.first : '',
        'interests': interests.toList(),
        'promptGreenFlag': promptGreenFlagCtrl.text.trim(),
        'promptWeekend': promptWeekendCtrl.text.trim(),
        'promptGetAlong': promptGetAlongCtrl.text.trim(),
        'gender': gender.value?.value,
        'showMe': gender.value?.opposite.value,
        'showOnDiscovery': showOnDiscovery.value,
        'isProfileComplete': true,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      debugPrint('[EditProfileController] save payload → ${data.keys.toList()}');

      final ref = FirebaseFirestore.instance
          .collection('publicProfiles')
          .doc(uid);

      await ref.set(data, SetOptions(merge: true));

      debugPrint('[EditProfileController] save success uid=$uid');

      Get.snackbar('Saved', 'Profil kamu berhasil diperbarui');
      Get.back(result: true);

    } on FirebaseException catch (e, st) {
      debugPrint(
        '[EditProfileController] FIREBASE ERROR '
            'code=${e.code} message=${e.message}',
      );
      debugPrint(st.toString());

      Get.snackbar(
        'Save failed',
        e.message ?? 'Firebase error',
      );

    } catch (e, st) {
      debugPrint('[EditProfileController] UNKNOWN ERROR: $e');
      debugPrint(st.toString());

      Get.snackbar(
        'Save failed',
        e.toString(),
      );
    } finally {
      isSaving.value = false;
      debugPrint('[EditProfileController] save finished uid=$uid');
    }
  }
}
