import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'user_model.dart';

ImageProvider _resolveImageProvider(
  String path, {
  String fallback = 'assets/profile_1.jpeg',
}) {
  if (path.startsWith('assets/') || path.isEmpty) {
    return AssetImage(path.isNotEmpty ? path : fallback);
  }
  if (kIsWeb) {
    return AssetImage(fallback);
  }
  return FileImage(File(path));
}

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
        suboptions: [
          'Current Session',
          'Linked Browsers',
          'Terminate Sessions',
        ],
      ),
      _SettingOption(
        id: 'power_saving',
        title: 'Power Saving',
        subtitle: 'Reduce power usage on low charge',
        icon: Icons.battery_saver_outlined,
        iconColor: Color(0xFFFF9500),
        suboptions: [
          'Auto Battery Mode',
          'Disable Animations',
          'Lower Frame Rate',
        ],
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
        suboptions: [
          'Getting Started',
          'Account & Security',
          'Troubleshooting',
        ],
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
        suboptions: [
          'Data Collection',
          'Terms of Service',
          'Cookie Preferences',
        ],
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
        builder: (_) => option.id == 'account'
            ? AnimatedSwitcher(
                duration: Duration(
                  milliseconds: _MotionPreset.forOption(option.id).panelMs,
                ),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final curved = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  );
                  final slideTween = Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: Offset.zero,
                  );
                  return ClipRect(
                    child: FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: slideTween.animate(curved),
                        child: child,
                      ),
                    ),
                  );
                },
                child: _AccountDashboardPanel(
                  key: ValueKey<String>('${option.id}_$_animTick'),
                  onSuboptionTap: (sub) {
                    Navigator.pop(context);
                    _handleSuboptionTap(sub);
                  },
                ),
              )
            : _SuboptionsPanel(
                option: option,
                animTick: _animTick,
                onSuboptionTap: (sub) {
                  Navigator.pop(context);
                  _handleSuboptionTap(sub);
                },
              ),
      );
    }
  }

  void _handleSuboptionTap(String title) {
    if (title == 'Phone Number' ||
        title == 'Username' ||
        title == 'Bio' ||
        title == 'Email Address') {
      _openEditAccountField(title);
      return;
    }
    _showSnack('Selected: $title');
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

  String _extractTenDigits(String rawPhone) {
    final digitsOnly = rawPhone.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length > 10) {
      return digitsOnly.substring(digitsOnly.length - 10);
    }
    return digitsOnly;
  }

  Future<void> _openEditAccountField(String fieldLabel) async {
    final current = _activeUser;
    String initialValue = '';
    TextInputType keyboardType = TextInputType.text;
    int maxLines = 1;

    switch (fieldLabel) {
      case 'Phone Number':
        initialValue = _extractTenDigits(current.phoneNumber);
        keyboardType = TextInputType.number;
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
    String? errorText;

    final String? updatedValue = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Edit $fieldLabel'),
            content: TextField(
              controller: controller,
              autofocus: true,
              keyboardType: keyboardType,
              maxLines: maxLines,
              maxLength: fieldLabel == 'Phone Number' ? 10 : null,
              inputFormatters: fieldLabel == 'Phone Number'
                  ? <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ]
                  : null,
              onChanged: (_) {
                if (errorText != null) {
                  setDialogState(() => errorText = null);
                }
              },
              decoration: InputDecoration(
                hintText: fieldLabel == 'Phone Number'
                    ? 'Enter 10-digit mobile number'
                    : 'Enter $fieldLabel',
                errorText: errorText,
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
                onPressed: () {
                  final value = controller.text.trim();
                  if (fieldLabel == 'Phone Number' && value.length != 10) {
                    setDialogState(() {
                      errorText = 'Please enter a valid 10-digit number';
                    });
                    return;
                  }
                  Navigator.pop(ctx, value);
                },
                style: FilledButton.styleFrom(backgroundColor: _accentBlue),
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );

    if (updatedValue == null) return;

    final updatedProfile = UserProfile(
      userName: fieldLabel == 'Username' ? updatedValue : current.userName,
      email: fieldLabel == 'Email Address' ? updatedValue : current.email,
      phoneNumber: fieldLabel == 'Phone Number'
          ? updatedValue
          : current.phoneNumber,
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
    final String displayName = currentUser.userName.isNotEmpty
        ? currentUser.userName
        : 'User';
    final String handle = '@${displayName.toLowerCase().replaceAll(' ', '_')}';
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
                backgroundImage: _resolveImageProvider(
                  _activeUser.profileImagePath,
                ),
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
                  text: 'Keep your number up to date to ensure you can always sign in. ',
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
                    color: isSelected ? itemPreset.bgColor : Colors.transparent,
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
                          child: Icon(item.icon, color: Colors.white, size: 18),
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

  Widget _buildLeftList({
    required bool isWide,
    required UserProfile currentUser,
  }) {
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
                      child: _buildLeftList(
                        isWide: true,
                        currentUser: currentUser,
                      ),
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
                          child: _selectedOption.id == 'account'
                              ? AnimatedSwitcher(
                                  duration: Duration(
                                    milliseconds: preset.panelMs,
                                  ),
                                  switchInCurve: Curves.easeOutCubic,
                                  switchOutCurve: Curves.easeInCubic,
                                  transitionBuilder:
                                      (
                                        Widget child,
                                        Animation<double> animation,
                                      ) {
                                        final curved = CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeOutCubic,
                                        );
                                        final slideTween = Tween<Offset>(
                                          begin: const Offset(-1.0, 0.0),
                                          end: Offset.zero,
                                        );
                                        return ClipRect(
                                          child: FadeTransition(
                                            opacity: animation,
                                            child: SlideTransition(
                                              position: slideTween.animate(
                                                curved,
                                              ),
                                              child: child,
                                            ),
                                          ),
                                        );
                                      },
                                  child: _AccountDashboardPanel(
                                    key: ValueKey<String>(
                                      '${_selectedOption.id}_$_animTick',
                                    ),
                                    onSuboptionTap: (sub) {
                                      setState(() => _animTick++);
                                      _handleSuboptionTap(sub);
                                    },
                                  ),
                                )
                              : _SuboptionsPanel(
                                  option: _selectedOption,
                                  animTick: _animTick,
                                  onSuboptionTap: (sub) {
                                    setState(() => _animTick++);
                                    _handleSuboptionTap(sub);
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
                child: _buildLeftList(isWide: false, currentUser: currentUser),
              ),
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
                  final double itemScale =
                      preset.beginScale + ((1.0 - preset.beginScale) * clamped);
                  final double itemAngle = preset.beginAngle * (1.0 - clamped);

                  return Opacity(
                    opacity: clamped,
                    child: Transform.translate(
                      offset: Offset(
                        preset.itemBeginOffset.dx * (1.0 - value),
                        preset.itemBeginOffset.dy * (1.0 - value),
                      ),
                      child: Transform.rotate(
                        angle: itemAngle,
                        child: Transform.scale(scale: itemScale, child: child),
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

class _AccountDashboardPanel extends StatefulWidget {
  final ValueChanged<String> onSuboptionTap;

  const _AccountDashboardPanel({super.key, required this.onSuboptionTap});

  @override
  State<_AccountDashboardPanel> createState() => _AccountDashboardPanelState();
}

class _AccountDashboardPanelState extends State<_AccountDashboardPanel> {
  static const Color _oliveBg = Color(0xFF678D4B);
  static const Color _oliveDarkStrip = Color(0xFF56793D);
  static const Color _charcoalCard = Color(0xFF141614);
  static const Color _charcoalTile = Color(0xFF1E211E);
  static const Color _creamCard = Color(0xFFF4F7EE);
  static const Color _limeAccent = Color(0xFF9ED468);

  String _activeTopTab = 'Account';
  String _activeFilter = 'All';
  int _selectedDay = 18;
  bool _twoFactorEnabled = true;
  bool _privateAccountEnabled = true;

  static const List<String> _topTabs = [
    'Profile',
    'Personal Info',
    'Security',
    'Account',
    'Privacy',
    'Linked',
    'Data',
  ];

  static const List<String> _filters = [
    'All',
    'Username',
    'Phone Number',
    'Email Address',
    'Bio',
    'Password',
    'Privacy',
  ];

  UserProfile get _user =>
      globalUserNotifier.value ??
      UserProfile(
        userName: 'Member',
        email: 'member@example.com',
        phoneNumber: '9876543210',
        bio: 'Account bio',
        profileImagePath: 'assets/profile_1.jpeg',
      );

  int _completionPercent(UserProfile p) {
    int filled = 0;
    if (p.userName.trim().isNotEmpty) filled++;
    if (p.phoneNumber.trim().length == 10) filled++;
    if (p.email.trim().isNotEmpty) filled++;
    if (p.bio.trim().isNotEmpty) filled++;
    return ((filled / 4) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: globalUserNotifier,
      builder: (context, _, _) {
        final profile = _user;
        final String displayName = profile.userName.isNotEmpty
            ? profile.userName
            : 'Member';
        final String displayPhone = profile.phoneNumber.isNotEmpty
            ? profile.phoneNumber
            : '0000000000';
        final String displayEmail = profile.email.isNotEmpty
            ? profile.email
            : 'user@domain.com';
        final String displayBio = profile.bio.isNotEmpty
            ? profile.bio
            : 'Add your bio';
        final int completion = _completionPercent(profile);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _oliveBg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TOP NAVIGATION BAR (Logo + Pill Tabs + User Profile Badge)
                Row(
                  children: [
                    const Text(
                      'ac',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _oliveDarkStrip,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final tab in _topTabs)
                                GestureDetector(
                                  onTap: () {
                                    setState(() => _activeTopTab = tab);
                                    if (tab == 'Personal Info') {
                                      widget.onSuboptionTap('Username');
                                    } else if (tab == 'Security') {
                                      widget.onSuboptionTap('Change Password');
                                    } else if (tab == 'Privacy') {
                                      widget.onSuboptionTap('Account Privacy');
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 13,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _activeTopTab == tab
                                          ? _charcoalCard
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      tab,
                                      style: TextStyle(
                                        color: _activeTopTab == tab
                                            ? Colors.white
                                            : Colors.white70,
                                        fontSize: 11.5,
                                        fontWeight: _activeTopTab == tab
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: _charcoalCard,
                      child: Text(
                        displayName.characters.first.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '@${displayName.toLowerCase().replaceAll(' ', '_')}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => widget.onSuboptionTap('Username'),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: const BoxDecoration(
                          color: _oliveDarkStrip,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.settings_outlined,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 2. HEADER TITLE + COMPLETION RING + 3 ACCOUNT STATS
                Wrap(
                  spacing: 20,
                  runSpacing: 14,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Account\nSettings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            height: 1.06,
                          ),
                        ),
                        const SizedBox(width: 18),
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: completion / 100.0,
                                strokeWidth: 4.5,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.22,
                                ),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  _charcoalCard,
                                ),
                              ),
                              Text(
                                '$completion%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _metricBlock('Mobile Number', displayPhone),
                        const SizedBox(width: 22),
                        _metricBlock('Username', displayName),
                        const SizedBox(width: 22),
                        _metricBlock('Email ID', displayEmail),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // 3. ACCOUNT OPTION FILTER CHIPS ROW
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final label in _filters)
                            GestureDetector(
                              onTap: () {
                                setState(() => _activeFilter = label);
                                if (label == 'Username' ||
                                    label == 'Phone Number' ||
                                    label == 'Email Address' ||
                                    label == 'Bio') {
                                  widget.onSuboptionTap(label);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _activeFilter == label
                                      ? _charcoalCard
                                      : _oliveDarkStrip,
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.14),
                                  ),
                                ),
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          GestureDetector(
                            onTap: () => widget.onSuboptionTap('Add Account'),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: _oliveDarkStrip,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // 4. MAIN SPLIT CARDS (CHARCOAL CARD LEFT + 2 CREAM CARDS RIGHT)
                LayoutBuilder(
                  builder: (context, box) {
                    final bool stacked = box.maxWidth < 560;
                    final darkWidget = _buildDarkAccountCard(
                      displayName: displayName,
                      displayPhone: displayPhone,
                      displayEmail: displayEmail,
                      displayBio: displayBio,
                    );
                    final rightCardsWidget = Column(
                      children: [
                        _buildLightFieldCard(
                          icon: Icons.verified_user_outlined,
                          title: 'Two-Step Verification',
                          subtitle: 'SMS & Authenticator on $displayPhone',
                          badgeText: _twoFactorEnabled ? 'Active' : 'Off',
                          isOn: _twoFactorEnabled,
                          onToggle: (v) {
                            setState(() => _twoFactorEnabled = v);
                            widget.onSuboptionTap('Two-Step Verification');
                          },
                          onEdit: () => widget.onSuboptionTap('Phone Number'),
                        ),
                        const SizedBox(height: 12),
                        _buildLightFieldCard(
                          icon: Icons.lock_outline,
                          title: 'Private Account',
                          subtitle: '$displayEmail · $displayBio',
                          badgeText: _privateAccountEnabled
                              ? 'Private'
                              : 'Public',
                          isOn: _privateAccountEnabled,
                          onToggle: (v) {
                            setState(() => _privateAccountEnabled = v);
                            widget.onSuboptionTap('Account Privacy');
                          },
                          onEdit: () => widget.onSuboptionTap('Email Address'),
                        ),
                      ],
                    );

                    if (stacked) {
                      return Column(
                        children: [
                          darkWidget,
                          const SizedBox(height: 12),
                          rightCardsWidget,
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: darkWidget),
                        const SizedBox(width: 14),
                        Expanded(flex: 4, child: rightCardsWidget),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _metricBlock(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10.5),
        ),
        const SizedBox(height: 2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 140),
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDarkAccountCard({
    required String displayName,
    required String displayPhone,
    required String displayEmail,
    required String displayBio,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _charcoalCard,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row inside dark card
          Row(
            children: [
              const CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: _charcoalCard, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      displayBio,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => widget.onSuboptionTap('Bio'),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: _charcoalTile,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white70,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => widget.onSuboptionTap('Download Your Data'),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: _charcoalTile,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.open_in_full,
                    color: Colors.white70,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 3 Inner Columns (Date Grid | Account Options | Security Bars)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Login / Backup Date Grid
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: _charcoalTile,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Last login date',
                        style: TextStyle(color: Colors.white70, fontSize: 10.5),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          for (int d = 1; d <= 28; d++)
                            GestureDetector(
                              onTap: () => setState(() => _selectedDay = d),
                              child: Container(
                                width: 18,
                                height: 18,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _selectedDay == d
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Text(
                                  '$d',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: _selectedDay == d
                                        ? _charcoalCard
                                        : Colors.white60,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // 2. Account Options Chips (Edit any field directly)
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: _charcoalTile,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account options',
                        style: TextStyle(color: Colors.white70, fontSize: 10.5),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _accountOptionPill('Username'),
                          _accountOptionPill('Phone Number'),
                          _accountOptionPill('Bio'),
                          _accountOptionPill('Email Address'),
                          _accountOptionPill('Change Password'),
                          _accountOptionPill('Delete Account'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // 3. Green Verification Bars Box
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: _oliveDarkStrip,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verified',
                        style: TextStyle(color: Colors.white, fontSize: 10.5),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: _barColumn('Mail', 34, Colors.white70),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: _barColumn('Phone', 46, _charcoalCard),
                          ),
                          const SizedBox(width: 5),
                          Expanded(child: _barColumn('2FA', 58, _limeAccent)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Bottom Summary Strip + Lime Confirm Button
          Row(
            children: [
              Expanded(child: _bottomStat('Active day', '${_selectedDay}th')),
              Expanded(child: _bottomStat('Phone', displayPhone)),
              Expanded(child: _bottomStat('Account', displayName)),
              GestureDetector(
                onTap: () => widget.onSuboptionTap('Phone Number'),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: _limeAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: _charcoalCard,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _barColumn(String tag, double height, Color barColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: _charcoalCard.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tag,
            style: const TextStyle(color: Colors.white, fontSize: 8.5),
          ),
        ),
      ],
    );
  }

  Widget _accountOptionPill(String optionLabel) {
    final bool isHighlighted =
        optionLabel == 'Phone Number' || optionLabel == 'Username';
    return GestureDetector(
      onTap: () => widget.onSuboptionTap(optionLabel),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.white : _charcoalCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          optionLabel,
          style: TextStyle(
            color: isHighlighted ? _charcoalCard : Colors.white,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _bottomStat(String title, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          val,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildLightFieldCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required bool isOn,
    required ValueChanged<bool> onToggle,
    required VoidCallback onEdit,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _creamCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: _charcoalCard, size: 18),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _charcoalCard,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    color: _charcoalCard,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black54, fontSize: 11),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                badgeText,
                style: const TextStyle(
                  color: _charcoalCard,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => onToggle(false),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.close,
                          size: 13,
                          color: !isOn ? _charcoalCard : Colors.black45,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onToggle(true),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isOn ? _limeAccent : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 12,
                          color: _charcoalCard,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
