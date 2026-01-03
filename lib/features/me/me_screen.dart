part of '../../pages.dart';

class Me extends StatelessWidget {
  const Me({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MeController>()
        ? Get.find<MeController>()
        : Get.put(MeController());

    return Scaffold(
      backgroundColor: electric,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator(color: lemonade));
          }

          return Container(
            padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Me',
                        style: inconsolataStyle(
                            fontSize: 22,
                            color: lemonade,
                            fontWeight: FontWeight.w700)),
                    BounceButton(
                      onTap: controller.openSettings,
                      child: Icon(Icons.settings_rounded,
                          color: lemonade.withOpacity(0.9)),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _MeProfileCard(controller: controller),
                const SizedBox(height: 15),
                _QuickActionsRow(controller: controller),
                const SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _MeSection(
                          title: 'Discovery',
                          children: [
                            Obx(() => _MeTile(
                                  icon: Icons.radar_rounded,
                                  title: 'Distance',
                                  subtitle: '${controller.distanceKm.value} km',
                                  onTap: controller.openDistance,
                                )),
                            Obx(() => _MeTile(
                                  icon: Icons.cake_rounded,
                                  title: 'Age range',
                                  subtitle:
                                      '${controller.ageMin.value}–${controller.ageMax.value}',
                                  onTap: controller.openAgeRange,
                                )),
                            // Obx(() => _MeTile(
                            //       icon: Icons.favorite_rounded,
                            //       title: 'Show me',
                            //       subtitle: controller.preference.value,
                            //       onTap: controller.openPreference,
                            //     )),
                            Obx(() => _MeToggleTile(
                                  icon: Icons.visibility_rounded,
                                  title: 'Show me on discovery',
                                  value: controller.showOnDiscovery.value,
                                  onChanged: controller.setShowOnDiscovery,
                                )),
                            _MeTile(
                              icon: Icons.tune_rounded,
                              title: 'Advanced filters',
                              subtitle: 'Premium',
                              onTap: controller.openFilters,
                              trailing: const Pill(
                                text: 'PRO',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Safety & Privacy
                        _MeSection(
                          title: 'Safety & Privacy',
                          children: [
                            Obx(() => _MeTile(
                                  icon: Icons.verified_rounded,
                                  title: 'Photo verification',
                                  subtitle: controller.verified.value
                                      ? 'Verified'
                                      : 'Not verified',
                                  onTap: controller.openVerification,
                                  trailing: controller.verified.value
                                      ? Pill(
                                          text: 'OK',
                                        )
                                      : null,
                                )),
                            _MeTile(
                              icon: Icons.block_rounded,
                              title: 'Blocked users',
                              subtitle: 'Manage',
                              onTap: controller.openBlockList,
                            ),
                            Obx(() => _MeToggleTile(
                                  icon: Icons.pin_drop_rounded,
                                  title: 'Show distance',
                                  value: controller.showDistance.value,
                                  onChanged: controller.setShowDistance,
                                )),
                            Obx(() => _MeToggleTile(
                                  icon: Icons.circle_rounded,
                                  title: 'Show online status',
                                  value: controller.showOnlineStatus.value,
                                  onChanged:
                                      controller.setShowOnlineStatus,
                                )),
                            Obx(() => _MeToggleTile(
                                  icon: Icons.mark_chat_read_rounded,
                                  title: 'Read receipts',
                                  value: controller.readReceipts.value,
                                  onChanged: controller.setReadReceipts,
                                  subtitle: 'Premium',
                                )),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Account
                        _MeSection(
                          title: 'Account',
                          children: [
                            _MeTile(
                              icon: Icons.notifications_rounded,
                              title: 'Notifications',
                              subtitle: 'Matches, chats, likes',
                              onTap: controller.openNotifications,
                            ),
                            _MeTile(
                              icon: Icons.workspace_premium_rounded,
                              title: 'Subscription',
                              subtitle: 'Manage plan',
                              onTap: controller.openSubscription,
                              trailing: Pill(
                                text: 'PRO',
                              ),
                            ),
                            _MeTile(
                              icon: Icons.link_rounded,
                              title: 'Connected accounts',
                              subtitle: 'Google / Apple',
                              onTap: controller.openConnectedAccounts,
                            ),
                            _MeTile(
                              icon: Icons.logout_rounded,
                              title: 'Logout',
                              subtitle: '',
                              onTap: controller.logout,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        _MeDangerTile(
                          title: 'Delete account',
                          subtitle: 'This can’t be undone',
                          onTap: controller.deleteAccount,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _MeProfileCard extends StatelessWidget {
  final MeController controller;

  const _MeProfileCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: whiteSkin,
        border: Border.all(color: lemonade.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: lemonade.withOpacity(0.10),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Obx(() {
        final pct = (controller.completion.value * 100).round();
        final photo = controller.photoUrl.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lemonade.withOpacity(0.08),
                    border: Border.all(color: lemonade.withOpacity(0.15)),
                    image: photo.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(photo), fit: BoxFit.cover)
                        : null,
                  ),
                  child: photo.isEmpty
                      ? Icon(Icons.person_rounded,
                          color: lemonade.withOpacity(0.85))
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${controller.name.value}, ${controller.age.value}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: inconsolataStyle(
                                fontSize: 18,
                                color: lemonade,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (controller.verified.value)
                            Pill(
                              text: 'Verified',
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.job.value} • ${controller.city.value}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: inconsolataStyle(
                          fontSize: 13,
                          color: lemonade.withOpacity(0.70),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile completion',
                  style: inconsolataStyle(
                      fontSize: 13,
                      color: lemonade.withOpacity(0.72),
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  '$pct%',
                  style: inconsolataStyle(
                      fontSize: 13,
                      color: lemonade.withOpacity(0.9),
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: controller.completion.value.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: whiteBlue.withOpacity(0.08),
                valueColor:
                    AlwaysStoppedAnimation<Color>(lemonade.withOpacity(0.9)),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: BounceButton(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    color: lemonade,
                    onTap: controller.openEditProfile,
                    child: Text(
                      'Edit profile',
                      style: inconsolataStyle(color: electric),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BounceButton(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    color: lemonade,
                    onTap: controller.openPreviewProfile,
                    child: Text(
                      'Preview',
                      style: inconsolataStyle(color: electric),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  final MeController controller;

  const _QuickActionsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: _QuickAction(
              icon: Icons.favorite_rounded,
              label: 'Likes you',
              badge: controller.likesYou.value,
              onTap: () => debugPrint('[Me] Likes you'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _QuickAction(
              icon: Icons.flash_on_rounded,
              label: 'Boost',
              badge: controller.boosts.value,
              onTap: () => debugPrint('[Me] Boost'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _QuickAction(
              icon: Icons.star_rounded,
              label: 'Super',
              badge: controller.superLikes.value,
              onTap: () => debugPrint('[Me] Super'),
            ),
          ),
        ],
      );
    });
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final int badge;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: lemonade.withOpacity(0.10),
                  border: Border.all(color: lemonade.withOpacity(0.2)),
                ),
                child:
                    Icon(icon, color: lemonade.withOpacity(0.85), size: 18),
              ),
              if (badge > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: electric,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: lemonade.withOpacity(0.25)),
                    ),
                    child: Text(
                      badge.toString(),
                      style: inconsolataStyle(
                          fontSize: 11,
                          color: lemonade,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MeSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _MeSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: whiteSkin,
        border: Border.all(color: lemonade.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: inconsolataStyle(
                  fontSize: 14,
                  color: lemonade.withOpacity(0.72),
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          ..._withDividers(children),
        ],
      ),
    );
  }

  List<Widget> _withDividers(List<Widget> items) {
    final out = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i != items.length - 1) {
        out.add(Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: lemonade.withOpacity(0.2)));
      }
    }
    return out;
  }
}

class _MeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: lemonade.withOpacity(0.05),
              border: Border.all(color: lemonade.withOpacity(0.2)),
            ),
            child: Icon(icon, color: lemonade.withOpacity(0.80), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: inconsolataStyle(
                        fontSize: 14,
                        color: lemonade.withOpacity(0.92),
                        fontWeight: FontWeight.w700)),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: inconsolataStyle(
                          fontSize: 12,
                          color: lemonade.withOpacity(0.55),
                          fontWeight: FontWeight.w500)),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            trailing!,
          ],
          if (trailing == null)
            Icon(Icons.chevron_right_rounded,
                color: lemonade.withOpacity(0.30)),
        ],
      ),
    );
  }
}

class _MeToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _MeToggleTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: lemonade.withOpacity(0.05),
            border: Border.all(color: lemonade.withOpacity(0.2)),
          ),
          child: Icon(icon, color: lemonade.withOpacity(0.80), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: inconsolataStyle(
                          fontSize: 14,
                          color: lemonade.withOpacity(0.92),
                          fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Pill(
                      text: subtitle!,
                    ),
                ],
              ),
            ],
          ),
        ),
        AppSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _MeDangerTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MeDangerTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: whiteSkin,
          border: Border.all(color: lemonade.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: lemonade.withOpacity(0.05),
                border: Border.all(color: lemonade.withOpacity(0.2)),
              ),
              child: Icon(Icons.delete_forever_rounded,
                  color: lemonade.withOpacity(0.85)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: inconsolataStyle(
                          fontSize: 14,
                          color: lemonade.withOpacity(0.95),
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: inconsolataStyle(
                          fontSize: 12,
                          color: lemonade.withOpacity(0.55),
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: lemonade.withOpacity(0.30)),
          ],
        ),
      ),
    );
  }
}