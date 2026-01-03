part of '../../pages.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final controller = Get.put(EditProfileController(), permanent: false);

  @override
  void dispose() {
    if (Get.isRegistered<EditProfileController>()) {
      Get.delete<EditProfileController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return WillPopScope(
      onWillPop: () async {
        Get.delete<EditProfileController>();
        return true;
      },
      child: Scaffold(
        backgroundColor: electric,
        appBar: AppBar(
          backgroundColor: electric,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: lemonade.withOpacity(0.92)),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Edit Profile',
            style: inconsolataStyle(
              fontSize: 18,
              color: lemonade.withOpacity(0.92),
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            Obx(() {
              final saving = controller.isSaving.value;
              return TextButton(
                onPressed: saving ? null : controller.save,
                child: Text(
                  saving ? 'Saving...' : 'Save',
                  style: inconsolataStyle(
                    fontSize: 14,
                    color: saving
                        ? lemonade.withOpacity(0.45)
                        : lemonade.withOpacity(0.95),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              );
            }),
            const SizedBox(width: 6),
          ],
        ),
        body: SafeArea(
          bottom: true,
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: lemonade),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== header vibe =====
                  GlassHeader(
                    title: 'Make them stop scrolling.',
                    subtitle:
                        'Sedikit Jaksel, tapi tetap genuine. Isi yang bikin orang ngeh: “oh wow, interesting”.',
                    completion: controller.completion.value,
                  ),
                  const SizedBox(height: 14),

                  // ===== photos =====
                  SectionCard(
                    title: 'Photos',
                    subtitle:
                        '3 foto yang paling “you”. Yang 1: senyum. Yang 2: aktivitas. Yang 3: drip.',
                    child: PhotoGrid(
                      photos: controller.photos,
                      onAddOrEdit: controller.setPhotoAt,
                      onRemove: controller.removePhotoAt,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ===== about =====
                  SectionCard(
                    title: 'About you',
                    subtitle: 'Keep it short, punchy, and a bit flirty.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: inconsolataStyle(
                            fontSize: 12,
                            color: lemonade.withOpacity(0.70),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        AppTextField(
                          controller: controller.nameCtrl,
                          hintText: 'Nama panggilan aja — ex: Pendekar Gendut',
                          maxLength: 24,
                          textColor: lemonade,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Age',
                                    style: inconsolataStyle(
                                      fontSize: 12,
                                      color: lemonade.withOpacity(0.70),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  AppTextField(
                                    controller: controller.ageCtrl,
                                    hintText: 'ex: 24',
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(2),
                                    ],
                                    maxLength: 2,
                                    textColor: lemonade,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'City',
                                    style: inconsolataStyle(
                                      fontSize: 12,
                                      color: lemonade.withOpacity(0.70),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  AppTextField(
                                    controller: controller.cityCtrl,
                                    hintText: 'ex: Jakarta',
                                    maxLength: 24,
                                    textColor: lemonade,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Bio',
                          style: inconsolataStyle(
                            fontSize: 12,
                            color: lemonade.withOpacity(0.70),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        AppTextField(
                          controller: controller.bioCtrl,
                          hintText:
                              'ex: “Coffee person. Weekend: gym + cari hidden gem. Kalau kamu suka banter, we’ll vibe.”',
                          maxLines: 4,
                          maxLength: 180,
                          textColor: lemonade,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Gender',
                          style: inconsolataStyle(
                            fontSize: 12,
                            color: lemonade.withOpacity(0.70),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Obx(() {
                          final selected = controller.gender.value;

                          Widget genderButton({
                            required String label,
                            required Gender value,
                          }) {
                            final isActive = selected == value;

                            return BounceButton(
                              onTap: () => controller.gender.value = value,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              color: isActive ? lemonade : electric,
                              child: Text(
                                label,
                                style: inconsolataStyle(
                                  color: isActive
                                      ? electric
                                      : lemonade.withOpacity(0.85),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          }

                          return Row(
                            children: [
                              genderButton(
                                label: 'Male',
                                value: Gender.male,
                              ),
                              const SizedBox(width: 12),
                              genderButton(
                                label: 'Female',
                                value: Gender.female,
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ===== basics =====
                  SectionCard(
                    title: 'Basics',
                    subtitle: 'Biar match-mu lebih relevant.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Job',
                          style: inconsolataStyle(
                            fontSize: 12,
                            color: lemonade.withOpacity(0.70),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        AppTextField(
                          controller: controller.jobCtrl,
                          hintText: 'ex: Mobile Dev',
                          maxLength: 40,
                          textColor: lemonade,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'School',
                          style: inconsolataStyle(
                            fontSize: 12,
                            color: lemonade.withOpacity(0.70),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        AppTextField(
                          controller: controller.schoolCtrl,
                          hintText: 'ex: UI / ITB / etc (optional)',
                          maxLength: 50,
                          textColor: lemonade,
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          final h = controller.heightCm.value;
                          return SliderRow(
                            title: 'Height',
                            valueText: '$h cm',
                            min: 140,
                            max: 200,
                            value: h.toDouble(),
                            onChanged: (v) =>
                                controller.heightCm.value = v.round(),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ===== prompts =====
                  SectionCard(
                    title: 'Jaksel Prompts',
                    subtitle: 'Ini yang bikin orang chat duluan.',
                    child: Column(
                      children: [
                        PromptBox(
                          title: 'My green flag is…',
                          hint:
                              'ex: “I’m consistent. I show up. No mixed signals.”',
                          controller: controller.promptGreenFlagCtrl,
                          maxLen: 120,
                        ),
                        const SizedBox(height: 10),
                        PromptBox(
                          title: 'Weekend energy:',
                          hint:
                              'ex: “Brunch, pilates, sunset drive, then tidur cepat.”',
                          controller: controller.promptWeekendCtrl,
                          maxLen: 120,
                        ),
                        const SizedBox(height: 10),
                        PromptBox(
                          title: 'We’ll get along if…',
                          hint:
                              'ex: “you can laugh at dumb jokes and like trying new food.”',
                          controller: controller.promptGetAlongCtrl,
                          maxLen: 120,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ===== interests (chips) =====
                  Obx(() => ChipEditor(
                        items: controller.interests.toList(),
                        suggestions: const [
                          'Coffee',
                          'Gym',
                          'Running',
                          'Badminton',
                          'Anime',
                          'K-drama',
                          'Culinary',
                          'Travel',
                          'Movies',
                          'Music',
                          'Books',
                          'Tech',
                          'Photography',
                          'Gaming',
                        ],
                        onAdd: controller.addInterest,
                        onRemove: controller.removeInterest,
                      )),
                  const SizedBox(height: 12),

                  // ===== discovery =====
                  SectionCard(
                    title: 'Discovery',
                    subtitle: 'Biar kamu bisa tampil di Discover.',
                    child: Column(
                      children: [
                        Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Show me on discovery',
                                      style: inconsolataStyle(
                                        fontSize: 13,
                                        color: lemonade.withOpacity(0.90),
                                        fontWeight: FontWeight.w900,
                                      )),
                                  const SizedBox(height: 3),
                                  Text(
                                      controller.profileReady.value
                                          ? 'Your profile is ready ✨'
                                          : 'Lengkapi biar bisa muncul',
                                      style: inconsolataStyle(
                                        fontSize: 12,
                                        color: lemonade.withOpacity(0.62),
                                        fontWeight: FontWeight.w700,
                                      )),
                                ],
                              ),
                              AppSwitch(
                                value: controller.showOnDiscovery.value,
                                onChanged: (v) =>
                                    controller.showOnDiscovery.value = v,
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 10),
                        _MiniNote(
                          text:
                              'Tip: 1 foto + 1 prompt yang kuat biasanya cukup bikin “first move”.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Obx(() {
                    final saving = controller.isSaving.value;
                    return BounceButton(
                      onTap: saving ? () {} : controller.save,
                      color: lemonade,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        saving ? 'Saving...' : 'Save changes',
                        style: inconsolataStyle(
                          color: electric,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
