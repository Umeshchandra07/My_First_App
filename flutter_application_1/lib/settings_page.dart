import 'package:material_ui/material_ui.dart';

import 'user_model.dart';

class _SettingOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final List<String> suboptions;

  const _SettingOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.suboptions,
  });
}

class SettingsPage extends StatefulWidget {
  final UserProfile? user;

  const SettingsPage({super.key, this.user});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const Color _bgGrey = Color(0xFFF0F2F5);
  static const Color _accentBlue = Color(0xFF2AABEE);

  bool _showNumberPrompt = true;

  UserProfile get _activeUser =>
      globalUserNotifier.value ??
      widget.user ??
      UserProfile(
        userName: 'User',
        email: '',
        phoneNumber: '',
        bio: '',
        profileImagePath: 'assets/profile_1.jpeg',
      );

  static const List<List<_SettingOption>> _groups = [
    [
      _SettingOption(
        id: 'account',
        title: 'Account',
        subtitle: 'Number, Username, Bio',
        icon: Icons.account_circle_outlined,
        iconColor: Color(0xFF2AABEE),
        suboptions: ['Phone Number', 'Username', 'Bio', 'Email Address'],
      ),
      _SettingOption(
        id: 'chat_settings',
        title: 'Chat Settings',
        subtitle: 'Wallpaper, Night Mode, Animations',
        icon: Icons.chat_bubble_outline,
        iconColor: Color(0xFFF5A623),
        suboptions: ['Chat Wallpaper', 'Night Mode', 'Message Animations'],
      ),
      _SettingOption(
        id: 'privacy_security',
        title: 'Privacy & Security',
        subtitle: 'Last Seen, Devices, Passkeys',
        icon: Icons.vpn_key_outlined,
        iconColor: Color(0xFF34C759),
        suboptions: ['Last Seen & Online', 'Active Devices', 'Passkeys & Lock'],
      ),
      _SettingOption(
        id: 'notifications',
        title: 'Notifications',
        subtitle: 'Sounds, Calls, Badges',
        icon: Icons.notifications_none_rounded,
        iconColor: Color(0xFFFF3B30),
        suboptions: ['Message Sounds', 'Call Ringtone', 'Badge Counter'],
      ),
      _SettingOption(
        id: 'data_storage',
        title: 'Data and Storage',
        subtitle: 'Media download settings',
        icon: Icons.pie_chart_outline,
        iconColor: Color(0xFF5856D6),
        suboptions: ['Auto-Download Media', 'Storage Usage', 'Data Saver'],
      ),
    ],
    [
      _SettingOption(
        id: 'chat_folders',
        title: 'Chat Folders',
        subtitle: 'Sort chats into folders',
        icon: Icons.folder_outlined,
        iconColor: Color(0xFF2AABEE),
        suboptions: ['Create New Folder', 'Unread Filter', 'Manage Folders'],
      ),
      _SettingOption(
        id: 'devices',
        title: 'Devices',
        subtitle: 'Manage connected devices',
        icon: Icons.devices_outlined,
        iconColor: Color(0xFF00C7BE),
        suboptions: ['Current Session', 'Linked Browsers', 'Terminate Sessions'],
      ),
      _SettingOption(
        id: 'power_saving',
        title: 'Power Saving',
        subtitle: 'Reduce power usage on low charge',
        icon: Icons.battery_saver_outlined,
        iconColor: Color(0xFFFF9500),
        suboptions: ['Auto Battery Mode', 'Disable Animations', 'Lower Frame Rate'],
      ),
      _SettingOption(
        id: 'language',
        title: 'Language',
        subtitle: 'English',
        icon: Icons.language_outlined,
        iconColor: Color(0xFFAF52DE),
        suboptions: ['English', 'Telugu', 'Hindi', 'Spanish'],
      ),
    ],
    [
      _SettingOption(
        id: 'membership_plus',
        title: 'Member Plus',
        subtitle: '',
        icon: Icons.workspace_premium_outlined,
        iconColor: Color(0xFFAF52DE),
        suboptions: ['Expanded Limits', 'Custom Themes', 'Priority Support'],
      ),
      _SettingOption(
        id: 'creator_credits',
        title: 'Creator Credits',
        subtitle: '',
        icon: Icons.stars_outlined,
        iconColor: Color(0xFFFF9500),
        suboptions: ['Credit Balance', 'Top Up Credits', 'Transaction History'],
      ),
    ],
    [
      _SettingOption(
        id: 'business_tools',
        title: 'Business Tools',
        subtitle: '',
        icon: Icons.storefront_outlined,
        iconColor: Color(0xFFFF5E5B),
        suboptions: ['Quick Replies', 'Business Hours', 'Greeting Message'],
      ),
      _SettingOption(
        id: 'send_gift',
        title: 'Send a Gift',
        subtitle: '',
        icon: Icons.card_giftcard_outlined,
        iconColor: Color(0xFFFF9500),
        suboptions: ['Choose a Gift', 'Gift History', 'Gift Privacy'],
      ),
    ],
    [
      _SettingOption(
        id: 'ask_question',
        title: 'Ask a Question',
        subtitle: '',
        icon: Icons.chat_outlined,
        iconColor: Color(0xFFF5A623),
        suboptions: ['Support Chat', 'Report an Issue', 'Send Feedback'],
      ),
      _SettingOption(
        id: 'help_faq',
        title: 'Help & FAQ',
        subtitle: '',
        icon: Icons.help_outline,
        iconColor: Color(0xFF2AABEE),
        suboptions: ['Getting Started', 'Account & Security', 'Troubleshooting'],
      ),
      _SettingOption(
        id: 'app_features',
        title: 'App Features',
        subtitle: '',
        icon: Icons.lightbulb_outline,
        iconColor: Color(0xFFBF5AF2),
        suboptions: ['Split View Tips', 'Gesture Shortcuts', 'Media Tools'],
      ),
      _SettingOption(
        id: 'privacy_policy',
        title: 'Privacy Policy',
        subtitle: '',
        icon: Icons.verified_user_outlined,
        iconColor: Color(0xFF34C759),
        suboptions: ['Data Collection', 'Terms of Service', 'Cookie Preferences'],
      ),
    ],
  ];

  late _SettingOption _selectedOption = _groups.first.first;
  int _animTick = 0;

  void _handleOptionSelect(_SettingOption option, {required bool isWide}) {
    setState(() {
      _selectedOption = option;
      _animTick++;
    });

    if (!isWide) {
      showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        builder: (_) => _SuboptionsPanel(
          option: option,
          animTick: _animTick,
          onSuboptionTap: (sub) {
            Navigator.pop(context);
            _onSuboptionSelected(sub);
          },
        ),
      );
    }
  }

  void _onSuboptionSelected(String sub) {
    if (_selectedOption.id == 'account') {
      _openEditAccountField(sub);
    } else {
      setState(() => _animTick++);
      _showSnack('${_selectedOption.title} -> $sub');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _openEditAccountField(String fieldLabel) async {
    final current = _activeUser;
    String initialValue = '';
    TextInputType keyboardType = TextInputType.text;
    int maxLines = 1;

    switch (fieldLabel) {
      case 'Phone Number':
        initialValue = current.phoneNumber;
        keyboardType = TextInputType.phone;
        break;
      case 'Username':
        initialValue = current.userName;
        break;
      case 'Bio':
        initialValue = current.bio;
        maxLines = 3;
        break;
      case 'Email Address':
        initialValue = current.email;
        keyboardType = TextInputType.emailAddress;
        break;
    }

    final controller = TextEditingController(text: initialValue);

    final String? updatedValue = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit $fieldLabel'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter $fieldLabel',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            style: FilledButton.styleFrom(backgroundColor: _accentBlue),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (updatedValue == null) return;

    final updatedProfile = UserProfile(
      userName: fieldLabel == 'Username' ? updatedValue : current.userName,
      email: fieldLabel == 'Email Address' ? updatedValue : current.email,
      phoneNumber:
          fieldLabel == 'Phone Number' ? updatedValue : current.phoneNumber,
      bio: fieldLabel == 'Bio' ? updatedValue : current.bio,
      profileImagePath: current.profileImagePath,
    );

    globalUserNotifier.value = updatedProfile;
    setState(() {
      _animTick++;
    });
    _showSnack('$fieldLabel updated');
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.maybePop(context),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () => _showSnack('Search settings'),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () => _showSnack('More options'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile currentUser) {
    final String displayName =
        currentUser.userName.isNotEmpty ? currentUser.userName : 'User';
    final String handle =
        '@${displayName.toLowerCase().replaceAll(' ', '_')}';
    final String phoneText = currentUser.phoneNumber.isNotEmpty
        ? currentUser.phoneNumber
        : 'Add mobile number';

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.blueGrey.shade200,
                child: const Icon(Icons.person, size: 46, color: Colors.white),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => _showSnack('Change profile photo'),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _accentBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$phoneText · $handle',
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          if (currentUser.bio.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              currentUser.bio,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5, color: Colors.black45),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNumberCheckCard(UserProfile currentUser) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            currentUser.phoneNumber.isNotEmpty
                ? 'Is ${currentUser.phoneNumber} still your number?'
                : 'Add your mobile number?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(fontSize: 12.5, color: Colors.black54),
              children: [
                TextSpan(
                  text:
                      'Keep your number up to date to ensure you can always sign in. ',
                ),
                TextSpan(
                  text: 'Learn more',
                  style: TextStyle(color: _accentBlue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _showNumberPrompt = false);
                    _showSnack('Update phone number');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _accentBlue,
                    side: BorderSide(color: _accentBlue.withValues(alpha: 0.4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'No',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    setState(() => _showNumberPrompt = false);
                    _showSnack('Phone number confirmed');
                  },
                  icon: const Icon(Icons.thumb_up_alt_outlined, size: 16),
                  label: const Text(
                    'Yes',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: _accentBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionGroup(
    List<_SettingOption> items, {
    required bool isWide,
    String? sectionHeader,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sectionHeader != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                sectionHeader,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _accentBlue,
                ),
              ),
            ),
          for (int i = 0; i < items.length; i++) ...[
            Builder(
              builder: (context) {
                final item = items[i];
                final bool isSelected = isWide && _selectedOption.id == item.id;
                final bool hasSubtitle = item.subtitle.isNotEmpty;
                final itemPreset = _MotionPreset.forOption(item.id);

                return InkWell(
                  onTap: () => _handleOptionSelect(item, isWide: isWide),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: itemPreset.panelMs),
                    curve: itemPreset.curve,
                    color: isSelected
                        ? itemPreset.bgColor
                        : Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: item.iconColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            item.icon,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              if (hasSubtitle) ...[
                                const SizedBox(height: 2),
                                Text(
                                  item.subtitle,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (isWide)
                          Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: isSelected ? _accentBlue : Colors.black26,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (i < items.length - 1)
              const Divider(height: 1, indent: 60, endIndent: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildLeftList({required bool isWide, required UserProfile currentUser}) {
    return Container(
      color: _bgGrey,
      child: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _buildProfileHeader(currentUser),
                if (_showNumberPrompt) _buildNumberCheckCard(currentUser),
                _buildOptionGroup(_groups[0], isWide: isWide),
                _buildOptionGroup(_groups[1], isWide: isWide),
                _buildOptionGroup(_groups[2], isWide: isWide),
                _buildOptionGroup(_groups[3], isWide: isWide),
                _buildOptionGroup(
                  _groups[4],
                  isWide: isWide,
                  sectionHeader: 'Help',
                ),
                const SizedBox(height: 16),
                const Text(
                  'App Version 1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: globalUserNotifier,
      builder: (context, value, _) {
        final currentUser = _activeUser;

        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth >= 600;
            final preset = _MotionPreset.forOption(_selectedOption.id);

            if (isWide) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Row(
                  children: [
                    // Left side: all settings titles & groups
                    SizedBox(
                      width: 370,
                      height: double.infinity,
                      child: _buildLeftList(isWide: true, currentUser: currentUser),
                    ),
                    const VerticalDivider(width: 1),
                    // Right side: suboptions for the selected setting
                    Expanded(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: preset.panelMs),
                        curve: preset.curve,
                        color: preset.bgColor.withValues(alpha: 0.55),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(32),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 620),
                          child: _SuboptionsPanel(
                            option: _selectedOption,
                            animTick: _animTick,
                            onSuboptionTap: (sub) {
                              setState(() => _animTick++);
                              _onSuboptionSelected(sub);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Scaffold(
              backgroundColor: _bgGrey,
              body: SafeArea(
                  child: _buildLeftList(isWide: false, currentUser: currentUser)),
            );
          },
        );
      },
    );
  }
}

enum _PanelAnimStyle {
  accountGlide,
  chatPop,
  shieldReveal,
  bellPulse,
  storageLift,
  folderSlide,
  deviceZoom,
  powerWave,
  globeFlip,
  plusShimmerSlide,
  creditsBounce,
  businessSnap,
  giftPopTilt,
  questionFloat,
  faqSlideUp,
  featuresZoomRotate,
  policySmoothFade,
}

class _MotionPreset {
  final _PanelAnimStyle style;
  final int panelMs;
  final int itemBaseMs;
  final int itemStepMs;
  final Curve curve;
  final Offset panelBeginOffset;
  final Offset itemBeginOffset;
  final double beginScale;
  final double beginAngle;
  final Color bgColor;

  const _MotionPreset({
    required this.style,
    required this.panelMs,
    required this.itemBaseMs,
    required this.itemStepMs,
    required this.curve,
    required this.panelBeginOffset,
    required this.itemBeginOffset,
    required this.beginScale,
    this.beginAngle = 0.0,
    this.bgColor = const Color(0xFFD6EEFF),
  });

  factory _MotionPreset.forOption(String id) {
    switch (id) {
      case 'account':
        return const _MotionPreset(
          style: _PanelAnimStyle.accountGlide,
          panelMs: 420,
          itemBaseMs: 260,
          itemStepMs: 65,
          curve: Curves.easeOutCubic,
          panelBeginOffset: Offset(-1.0, 0.0),
          itemBeginOffset: Offset(-48.0, 0.0),
          beginScale: 1.0,
          beginAngle: 0.0,
          bgColor: Color(0xFFD6EEFF),
        );
      case 'chat_settings':
        return const _MotionPreset(
          style: _PanelAnimStyle.chatPop,
          panelMs: 400,
          itemBaseMs: 260,
          itemStepMs: 65,
          curve: Curves.easeOutBack,
          panelBeginOffset: Offset(0.0, 0.25),
          itemBeginOffset: Offset(0.0, 26.0),
          beginScale: 0.90,
          beginAngle: 0.0,
          bgColor: Color(0xFFFFE8BE),
        );
      case 'privacy_security':
        return const _MotionPreset(
          style: _PanelAnimStyle.shieldReveal,
          panelMs: 380,
          itemBaseMs: 260,
          itemStepMs: 60,
          curve: Curves.easeOutExpo,
          panelBeginOffset: Offset(0.45, 0.0),
          itemBeginOffset: Offset(36.0, 0.0),
          beginScale: 0.96,
          beginAngle: 0.0,
          bgColor: Color(0xFFD2F8E3),
        );
      case 'notifications':
        return const _MotionPreset(
          style: _PanelAnimStyle.bellPulse,
          panelMs: 440,
          itemBaseMs: 260,
          itemStepMs: 70,
          curve: Curves.elasticOut,
          panelBeginOffset: Offset(0.0, -0.25),
          itemBeginOffset: Offset(0.0, -24.0),
          beginScale: 0.92,
          beginAngle: -0.05,
          bgColor: Color(0xFFFFD6D6),
        );
      case 'data_storage':
        return const _MotionPreset(
          style: _PanelAnimStyle.storageLift,
          panelMs: 390,
          itemBaseMs: 250,
          itemStepMs: 60,
          curve: Curves.easeOutCubic,
          panelBeginOffset: Offset(0.0, 0.30),
          itemBeginOffset: Offset(0.0, 30.0),
          beginScale: 0.95,
          beginAngle: 0.0,
          bgColor: Color(0xFFE3E0FF),
        );
      case 'chat_folders':
        return const _MotionPreset(
          style: _PanelAnimStyle.folderSlide,
          panelMs: 380,
          itemBaseMs: 240,
          itemStepMs: 55,
          curve: Curves.fastOutSlowIn,
          panelBeginOffset: Offset(-0.45, 0.0),
          itemBeginOffset: Offset(-32.0, 0.0),
          beginScale: 0.96,
          beginAngle: 0.0,
          bgColor: Color(0xFFD2F1FF),
        );
      case 'devices':
        return const _MotionPreset(
          style: _PanelAnimStyle.deviceZoom,
          panelMs: 400,
          itemBaseMs: 250,
          itemStepMs: 60,
          curve: Curves.easeOutBack,
          panelBeginOffset: Offset.zero,
          itemBeginOffset: Offset(0.0, 20.0),
          beginScale: 0.85,
          beginAngle: 0.0,
          bgColor: Color(0xFFD0FAF6),
        );
      case 'power_saving':
        return const _MotionPreset(
          style: _PanelAnimStyle.powerWave,
          panelMs: 390,
          itemBaseMs: 250,
          itemStepMs: 60,
          curve: Curves.easeInOutCubic,
          panelBeginOffset: Offset(0.20, -0.15),
          itemBeginOffset: Offset(22.0, -14.0),
          beginScale: 0.93,
          beginAngle: 0.04,
          bgColor: Color(0xFFFFE5C2),
        );
      case 'language':
        return const _MotionPreset(
          style: _PanelAnimStyle.globeFlip,
          panelMs: 410,
          itemBaseMs: 260,
          itemStepMs: 65,
          curve: Curves.easeOutCubic,
          panelBeginOffset: Offset(-0.30, 0.15),
          itemBeginOffset: Offset(-26.0, 16.0),
          beginScale: 0.93,
          beginAngle: -0.035,
          bgColor: Color(0xFFF3D9FF),
        );
      case 'membership_plus':
        return const _MotionPreset(
          style: _PanelAnimStyle.plusShimmerSlide,
          panelMs: 380,
          itemBaseMs: 245,
          itemStepMs: 55,
          curve: Curves.easeOutQuart,
          panelBeginOffset: Offset(0.25, -0.10),
          itemBeginOffset: Offset(24.0, -10.0),
          beginScale: 0.93,
          beginAngle: 0.025,
          bgColor: Color(0xFFEDD6FF),
        );
      case 'creator_credits':
        return const _MotionPreset(
          style: _PanelAnimStyle.creditsBounce,
          panelMs: 390,
          itemBaseMs: 250,
          itemStepMs: 60,
          curve: Curves.easeOutBack,
          panelBeginOffset: Offset(0.0, 0.18),
          itemBeginOffset: Offset(0.0, 20.0),
          beginScale: 0.90,
          beginAngle: -0.025,
          bgColor: Color(0xFFFFE9C7),
        );
      case 'business_tools':
        return const _MotionPreset(
          style: _PanelAnimStyle.businessSnap,
          panelMs: 350,
          itemBaseMs: 220,
          itemStepMs: 50,
          curve: Curves.fastOutSlowIn,
          panelBeginOffset: Offset(0.28, 0.10),
          itemBeginOffset: Offset(26.0, 10.0),
          beginScale: 0.95,
          beginAngle: 0.0,
          bgColor: Color(0xFFFFD8D8),
        );
      case 'send_gift':
        return const _MotionPreset(
          style: _PanelAnimStyle.giftPopTilt,
          panelMs: 400,
          itemBaseMs: 250,
          itemStepMs: 60,
          curve: Curves.easeOutBack,
          panelBeginOffset: Offset(-0.18, 0.16),
          itemBeginOffset: Offset(-18.0, 18.0),
          beginScale: 0.89,
          beginAngle: 0.04,
          bgColor: Color(0xFFFFE2C4),
        );
      case 'ask_question':
        return const _MotionPreset(
          style: _PanelAnimStyle.questionFloat,
          panelMs: 360,
          itemBaseMs: 230,
          itemStepMs: 55,
          curve: Curves.easeInOutCubic,
          panelBeginOffset: Offset(0.0, -0.14),
          itemBeginOffset: Offset(0.0, -16.0),
          beginScale: 0.95,
          beginAngle: -0.025,
          bgColor: Color(0xFFFFF0C2),
        );
      case 'help_faq':
        return const _MotionPreset(
          style: _PanelAnimStyle.faqSlideUp,
          panelMs: 360,
          itemBaseMs: 225,
          itemStepMs: 50,
          curve: Curves.easeOutCubic,
          panelBeginOffset: Offset(0.0, 0.22),
          itemBeginOffset: Offset(0.0, 22.0),
          beginScale: 0.96,
          beginAngle: 0.0,
          bgColor: Color(0xFFD4EEFF),
        );
      case 'app_features':
        return const _MotionPreset(
          style: _PanelAnimStyle.featuresZoomRotate,
          panelMs: 390,
          itemBaseMs: 245,
          itemStepMs: 55,
          curve: Curves.easeOutBack,
          panelBeginOffset: Offset(0.18, 0.08),
          itemBeginOffset: Offset(20.0, 10.0),
          beginScale: 0.88,
          beginAngle: 0.03,
          bgColor: Color(0xFFF2D6FF),
        );
      case 'privacy_policy':
        return const _MotionPreset(
          style: _PanelAnimStyle.policySmoothFade,
          panelMs: 350,
          itemBaseMs: 220,
          itemStepMs: 45,
          curve: Curves.easeOutQuart,
          panelBeginOffset: Offset(-0.20, 0.0),
          itemBeginOffset: Offset(-20.0, 0.0),
          beginScale: 0.97,
          beginAngle: 0.0,
          bgColor: Color(0xFFD4F8E2),
        );
      default:
        return const _MotionPreset(
          style: _PanelAnimStyle.accountGlide,
          panelMs: 420,
          itemBaseMs: 260,
          itemStepMs: 65,
          curve: Curves.easeOutCubic,
          panelBeginOffset: Offset(-1.0, 0.0),
          itemBeginOffset: Offset(-48.0, 0.0),
          beginScale: 1.0,
          beginAngle: 0.0,
          bgColor: Color(0xFFD6EEFF),
        );
    }
  }
}

class _SuboptionsPanel extends StatelessWidget {
  final _SettingOption option;
  final int animTick;
  final ValueChanged<String> onSuboptionTap;

  const _SuboptionsPanel({
    required this.option,
    required this.animTick,
    required this.onSuboptionTap,
  });

  @override
  Widget build(BuildContext context) {
    final preset = _MotionPreset.forOption(option.id);
    final bool isHighlighted = option.id == 'account';

    return AnimatedSwitcher(
      duration: Duration(milliseconds: preset.panelMs),
      switchInCurve: preset.curve,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final bool isAccount = option.id == 'account';
        final curved = CurvedAnimation(
          parent: animation,
          curve: isAccount ? Curves.easeOutCubic : preset.curve,
        );
        final slideTween = Tween<Offset>(
          begin: isAccount ? const Offset(-1.0, 0.0) : preset.panelBeginOffset,
          end: Offset.zero,
        );
        final scaleTween = Tween<double>(
          begin: isAccount ? 1.0 : preset.beginScale,
          end: 1.0,
        );

        return ClipRect(
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: scaleTween.animate(curved),
              child: SlideTransition(
                position: slideTween.animate(curved),
                child: child,
              ),
            ),
          ),
        );
      },
      child: AnimatedContainer(
        key: ValueKey<String>('${option.id}_$animTick'),
        duration: Duration(milliseconds: preset.panelMs),
        curve: preset.curve,
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: preset.bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighlighted
                ? option.iconColor.withValues(alpha: 0.45)
                : option.iconColor.withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: option.iconColor.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TweenAnimationBuilder<double>(
                  key: ValueKey<String>('badge_${option.id}_$animTick'),
                  tween: Tween<double>(begin: 0.78, end: 1.0),
                  duration: Duration(milliseconds: preset.panelMs),
                  curve: preset.curve,
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: option.iconColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(option.icon, color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    if (option.subtitle.isNotEmpty)
                      Text(
                        option.subtitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.black54,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            for (int i = 0; i < option.suboptions.length; i++)
              TweenAnimationBuilder<double>(
                key: ValueKey<String>('${option.id}_${animTick}_$i'),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(
                  milliseconds: preset.itemBaseMs + (i * preset.itemStepMs),
                ),
                curve: preset.curve,
                builder: (context, value, child) {
                  final clamped = value.clamp(0.0, 1.0);
                  final double itemScale = preset.beginScale +
                      ((1.0 - preset.beginScale) * clamped);
                  final double itemAngle =
                      preset.beginAngle * (1.0 - clamped);

                  return Opacity(
                    opacity: clamped,
                    child: Transform.translate(
                      offset: Offset(
                        preset.itemBeginOffset.dx * (1.0 - value),
                        preset.itemBeginOffset.dy * (1.0 - value),
                      ),
                      child: Transform.rotate(
                        angle: itemAngle,
                        child: Transform.scale(
                          scale: itemScale,
                          child: child,
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    tileColor: Colors.white.withValues(alpha: 0.78),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black12),
                    ),
                    leading: Icon(
                      Icons.tune,
                      color: option.iconColor,
                      size: 20,
                    ),
                    title: Text(
                      option.suboptions[i],
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => onSuboptionTap(option.suboptions[i]),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}