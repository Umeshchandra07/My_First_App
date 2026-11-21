import 'dart:io';

import 'package:material_ui/material_ui.dart';

import 'user_model.dart';
import 'discover_map_page.dart';
import 'home_feed_page.dart';
import 'app_strings.dart';
import 'followers_following_page.dart';
import 'page_transitions.dart';
import 'settings_page.dart';

// 0 = Home, 1 = Gallery, 2 = Chat, 3 = Pages, 4 = Profile
final ValueNotifier<int> globalTabIndexNotifier = ValueNotifier<int>(0);

class HomeScreen extends StatefulWidget {
  final UserProfile user;
  final int initialIndex;
  const HomeScreen({super.key, required this.user, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    globalTabIndexNotifier.value = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MainScreen(user: widget.user);
  }
}

class MainScreen extends StatelessWidget {
  final UserProfile user;
  const MainScreen({super.key, required this.user});

  static const double _wideBreakpoint =
      600; // Use 600px as the breakpoint for wide screens

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePage(),
      GalleryPage(user: user),
      Theme(data: ThemeData.dark(), child: const ChatPage()),
      const PagesPage(),
      ProfilePage(user: user),
    ];

    return ValueListenableBuilder<String>(
      valueListenable: globalLanguageNotifier,
      builder: (context, currentLang, child) {
        return ValueListenableBuilder<int>(
          valueListenable: globalTabIndexNotifier,
          builder: (context, selectedIndex, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final bool isWideScreen =
                    constraints.maxWidth >= _wideBreakpoint; // Use 600px as the breakpoint for wide screens

                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Stack(
                    children: [
                      Row(
                        children: [
                          if (isWideScreen)
                            _ExpandableSideRail(
                              selectedIndex: selectedIndex,
                              user: user,
                              onTap: _onItemTapped,
                            ),
                          Expanded(child: _buildContent(pages, selectedIndex)),
                        ],
                      ),
                      if (isWideScreen)
                        Positioned(
                          bottom: 20,
                          right: 24,
                          child: _buildChatPill(),
                        ),
                    ],
                  ),
                  bottomNavigationBar: isWideScreen
                      ? null
                      : BottomNavigationBar(
                          currentIndex: selectedIndex,
                          type: BottomNavigationBarType.fixed,
                          selectedItemColor: Colors.black,
                          unselectedItemColor: Colors.grey,
                          onTap: _onItemTapped,
                          items: [
                            BottomNavigationBarItem(
                              icon: const Icon(Icons.home_outlined),
                              label: AppStrings.get('home'),
                            ),
                            BottomNavigationBarItem(
                              icon: const Icon(Icons.collections_outlined),
                              label: AppStrings.get('gallery'),
                            ),
                            BottomNavigationBarItem(
                              icon: const Icon(Icons.chat_bubble_outline),
                              label: AppStrings.get('chat'),
                            ),
                            BottomNavigationBarItem(
                              icon: const Icon(Icons.grid_view_outlined),
                              label: AppStrings.get('pages'),
                            ),
                            BottomNavigationBarItem(
                              icon: const Icon(Icons.person_outline),
                              label: AppStrings.get('profile'),
                            ),
                          ],
                        ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _onItemTapped(int index) {
    if (globalTabIndexNotifier.value == index) return;
    globalTabIndexNotifier.value = index;
  }

  Widget _buildContent(List<Widget> pages, int selectedIndex) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation =
            Tween<Offset>(
              begin: const Offset(0.04, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
            );
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<int>(selectedIndex),
        child: pages[selectedIndex],
      ),
    );
  }

  Widget _buildChatPill() {
    return GestureDetector(
      onTap: () => _onItemTapped(2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.send_outlined, color: Colors.black87, size: 20),
            const SizedBox(width: 10),
            Text(
              AppStrings.get('chat'),
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 48,
              height: 24,
              child: Stack(
                children: const [
                  Positioned(
                    left: 0,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage('assets/profile_1.jpeg'),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage('assets/profile_2.jpeg'),
                    ),
                  ),
                  Positioned(
                    left: 28,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage('assets/profile_3.jpeg'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Slim icon rail that expands to 230px on hover, revealing item labels.
class _ExpandableSideRail extends StatefulWidget {
  const _ExpandableSideRail({
    required this.selectedIndex,
    required this.user,
    required this.onTap,
  });

  final int selectedIndex;
  final UserProfile user;
  final ValueChanged<int> onTap;

  @override
  State<_ExpandableSideRail> createState() => _ExpandableSideRailState();
}

class _ExpandableSideRailState extends State<_ExpandableSideRail> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isExpanded = true),
      onExit: (_) => setState(() => _isExpanded = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
        width: _isExpanded ? 230 : 72,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(right: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 48,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.black87,
                      size: 28,
                    ),
                  ),
                  if (_isExpanded) ...[
                    const SizedBox(width: 14),
                    const SizedBox(
                      width: 130,
                      child: Text(
                        'SocialApp',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildExpandableNavItem(
              0,
              Icons.home_outlined,
              Icons.home,
              AppStrings.get('home'),
            ),
            _buildExpandableNavItem(
              1,
              Icons.video_library_outlined,
              Icons.video_library,
              AppStrings.get('gallery'),
            ),
            _buildExpandableNavItem(
              2,
              Icons.send_outlined,
              Icons.send,
              AppStrings.get('chat'),
            ),
            _buildExpandableNavItem(
              3,
              Icons.explore_outlined,
              Icons.explore,
              AppStrings.get('pages'),
            ),
            _buildExpandableNavItem(
              4,
              Icons.person_outline,
              Icons.person,
              AppStrings.get('profile'),
              isProfile: true,
            ),
            const Spacer(),
            PopupMenuButton<String>(
              offset: const Offset(0, -60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              elevation: 4,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'settings',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.settings_outlined,
                        color: Colors.black87,
                        size: 22,
                      ),
                      if (_isExpanded) ...[
                        const SizedBox(width: 12),
                        const SizedBox(
                          width: 100,
                          child: Text(
                            'Settings',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              onSelected: (String value) {
                if (value == 'settings') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                }
              },
              child: _buildBottomActionItem(
                icon: Icons.menu,
                label: 'More',
                onTap: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label, {
    bool isProfile = false,
  }) {
    final bool isSelected = widget.selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => widget.onTap(index),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey.shade100 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 26,
                child: isProfile
                    ? Container(
                        padding: const EdgeInsets.all(1.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Colors.black
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 11,
                          backgroundImage: _profileImage(widget.user),
                        ),
                      )
                    : Icon(
                        isSelected ? activeIcon : icon,
                        color: Colors.black87,
                        size: 26,
                      ),
              ),
              if (_isExpanded) ...[
                const SizedBox(width: 14),
                SizedBox(
                  width: 130,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionItem({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 26,
              child: Icon(icon, color: Colors.black87, size: 26),
            ),
            if (_isExpanded) ...[
              const SizedBox(width: 14),
              SizedBox(
                width: 130,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  ImageProvider _profileImage(UserProfile profile) {
    final String path = profile.profileImagePath;
    if (path.startsWith('assets/')) return AssetImage(path);
    if (path.isEmpty) return const AssetImage('assets/profile_1.jpeg');
    return FileImage(File(path));
  }
}

// --- Individual Tab Views ---

class GalleryPage extends StatefulWidget {
  final UserProfile user;
  const GalleryPage({super.key, required this.user});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  bool isDarkMode = true; // Default dark theme

  @override
  Widget build(BuildContext context) {
    ImageProvider getProfileImage() {
      if (widget.user.profileImagePath.startsWith('assets/')) {
        return AssetImage(widget.user.profileImagePath);
      }
      return FileImage(File(widget.user.profileImagePath));
    }

    final List<Map<String, String>> galleryItems = [
      {
        'image': 'assets/Diwali_1.jpg',
        'title': 'Barcelona \n after dark',
        'location': 'Barcelona, Spain',
        'subtitle': 'Late dinners, tiny bars, nowhere to be early',
        'footerText':
            '${widget.user.userName.isNotEmpty ? widget.user.userName : "Maya"} found a swimming spot\n8 min away',
        'tag1': '★ Local mood',
        'tag2': '🕒 Best hour',
        'tag3': '📍 Local tip',
      },
      {
        'image': 'assets/Diwali_2.jpg',
        'title': 'Festival of\nLights',
        'location': 'Hyderabad, India',
        'subtitle': 'Sweets, sparklers, and joyful moments',
        'footerText': 'Celebration hub\n12 min away',
        'tag1': '✨ Festive mood',
        'tag2': '🌙 After 8 PM',
        'tag3': '🪔 Diya Lights',
      },
    ];

    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: galleryItems.length,
          itemBuilder: (context, index) {
            final item = galleryItems[index];
            final imagePath = item['image']!;

            return Stack(
              fit: StackFit.expand,
              children: [
                // 1. Background Image
                Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[900]),
                ),

                // 2. Dark Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.9),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // 3. Top Header Bar (Theme Toggle at Top-Left & Profile Info)
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      // Theme Toggle Button at Top-Left
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        // child: IconButton(
                        //   icon: Icon(
                        //     isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        //     color: const Color.fromRGBO(10, 0, 0, 1),
                        //     size: 20,
                        //   ),
                        //   onPressed: () {
                        //     setState(() {
                        //       isDarkMode = !isDarkMode;
                        //     });
                        //   },
                        // ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: getProfileImage(),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Good morning, ${widget.user.userName.isNotEmpty ? widget.user.userName : "Maya"}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.grid_view_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),

                // 4. Right Side Action Icons
                Positioned(
                  right: 16,
                  bottom: 160,
                  child: Column(
                    children: [
                      _buildRightIconButton(Icons.bookmark_border),
                      const SizedBox(height: 12),
                      _buildRightIconButton(Icons.share_outlined),
                      const SizedBox(height: 12),
                      _buildRightIconButton(Icons.layers_outlined),
                      const SizedBox(height: 12),
                      _buildRightIconButton(Icons.map_outlined),
                    ],
                  ),
                ),

                // 5. Title, Location & Tags Layer
                Positioned(
                  left: 20,
                  right: 80,
                  bottom: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item['location']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['subtitle']!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _buildTag(item['tag1']!),
                          const SizedBox(width: 6),
                          _buildTag(item['tag2']!),
                          const SizedBox(width: 6),
                          _buildTag(item['tag3']!),
                        ],
                      ),
                    ],
                  ),
                ),

                // 6. Bottom Floating Mini Card Preview
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 70,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: getProfileImage(),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item['footerText']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            imagePath,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 40,
                                  height: 40,
                                  color: Colors.grey[800],
                                ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRightIconButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
        onPressed: () {},
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class PagesPage extends StatefulWidget {
  const PagesPage({super.key});

  @override
  State<PagesPage> createState() => _PagesPageState();
}

class _PagesPageState extends State<PagesPage> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    final bg = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final fg = isDarkMode ? Colors.white : Colors.black;
    final sub = isDarkMode ? Colors.grey : Colors.black54;
    final searchBg = isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[200]!;
    final searchBorder = isDarkMode ? Colors.white10 : Colors.black12;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TOP BAR WITH MAPS TOGGLE & THEME TOGGLE AT TOP-LEFT ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DiscoverMapPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.map_rounded,
                            color: Colors.blueAccent,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Map',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white10 : Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: isDarkMode ? Colors.white : Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          isDarkMode = !isDarkMode;
                        });
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.get('noteworthy'),
                    style: TextStyle(
                      color: fg,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.get('noteworthy_sub'),
                    style: TextStyle(color: sub, fontSize: 13),
                  ),
                ],
              ),
            ),
            // --- FIRST HORIZONTAL SCROLL WITH RIGHT-SIDE FADEOUT ---
            SizedBox(
              height: 210,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.white, Colors.white, Colors.transparent],
                    stops: [0.75, 0.90, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildNoteworthyCard(
                      title: AppStrings.get('mariachi_band'),
                      time: AppStrings.get('yesterday'),
                      duration: '0:23',
                      image: 'assets/Diwali_1.jpg',
                    ),
                    const SizedBox(width: 12),
                    _buildNoteworthyCard(
                      title: AppStrings.get('flower_delivery'),
                      time: AppStrings.get('yesterday'),
                      duration: '0:21',
                      image: 'assets/Diwali_2.jpg',
                    ),
                    const SizedBox(width: 12),
                    _buildNoteworthyCard(
                      title: 'the Boy',
                      time: AppStrings.get('yesterday'),
                      duration: '0:2',
                      image: 'assets/profile_1.jpeg',
                    ),
                    const SizedBox(width: 12),
                    _buildNoteworthyCard(
                      title: 'Cover Shot',
                      time: AppStrings.get('yesterday'),
                      duration: '0:21',
                      image: 'assets/profile_5.jpeg',
                    ),
                    const SizedBox(width: 12),
                    _buildNoteworthyCard(
                      title: 'Mirror Selfie',
                      time: AppStrings.get('yesterday'),
                      duration: '0:21',
                      image: 'assets/profile_2.jpeg',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'All Clips',
                style: TextStyle(
                  color: fg,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildClipTile(
                    title: 'People bought ice cream.',
                    subtitle: 'Yesterday, 6:48 PM\n0:17 • Front Porch',
                    image: 'assets/profile_1.jpeg',
                    fg: fg,
                    sub: sub,
                  ),
                  _buildClipTile(
                    title: 'Morgan and Santiago worked on a bike.',
                    subtitle: 'Yesterday, 4:35 PM\n0:45 • Driveway',
                    image: 'assets/profile_2.jpeg',
                    fg: fg,
                    sub: sub,
                  ),
                  _buildClipTile(
                    title: 'Morgan and Shauni gardened.',
                    subtitle: 'Saturday, 11:12 AM\n0:39 • Backyard',
                    image: 'assets/profile_3.jpeg',
                    fg: fg,
                    sub: sub,
                  ),
                  _buildClipTile(
                    title: 'A service van arrived.',
                    subtitle: 'Saturday, 10:23 AM\n0:22 • Driveway',
                    image: 'assets/profile_4.jpeg',
                    fg: fg,
                    sub: sub,
                  ),
                  _buildClipTile(
                    title: 'A service van arrived.',
                    subtitle: 'Saturday, 10:23 AM\n0:22 • Driveway',
                    image: 'assets/profile_5.jpeg',
                    fg: fg,
                    sub: sub,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: searchBg,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: searchBorder),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: sub, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search',
                        style: TextStyle(color: sub, fontSize: 15),
                      ),
                    ),
                    Icon(Icons.mic_none, color: sub, size: 20),
                    const SizedBox(width: 14),
                    Icon(Icons.close, color: sub, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteworthyCard({
    required String title,
    required String time,
    required String duration,
    required String image,
  }) {
    return Container(
      width: 170,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.grey[850]),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.all(12),
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          time,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    duration,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClipTile({
    required String title,
    required String subtitle,
    required String image,
    required Color fg,
    required Color sub,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[850],
                child: const Icon(
                  Icons.broken_image,
                  color: Colors.white54,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: sub, fontSize: 12, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    final bg = isDarkMode ? const Color(0xFF161616) : Colors.white;
    final fg = isDarkMode ? Colors.white : Colors.black;
    final sub = isDarkMode ? Colors.white70 : Colors.black54;
    final chipBg = isDarkMode ? const Color(0xFF262626) : Colors.grey[200]!;

    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: fg,
            ),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
          title: Text('Chats', style: TextStyle(color: fg)),
          actions: [
            IconButton(
              icon: Icon(Icons.camera_alt_outlined, color: fg),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TOP STATUS BAR ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.location_on, color: fg, size: 22),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FriendMapPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: chipBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person_add_alt_1, color: fg, size: 16),
                          const SizedBox(width: 4),
                          Icon(Icons.add, color: fg, size: 12),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: chipBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: sub,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '1 of 24 uploaded',
                            style: TextStyle(
                              color: sub,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // --- TOP HORIZONTAL STORY BUBBLES ---
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  children: [
                    _buildStoryBubble(
                      name: 'Ibiza',
                      image: 'assets/Chat_1.jpeg',
                      hasUnread: true,
                      fg: fg,
                    ),
                    _buildStoryBubble(
                      name: 'Blake',
                      image: 'assets/Chat_2.jpeg',
                      fg: fg,
                    ),
                    _buildStoryBubble(
                      name: 'Greece',
                      image: 'assets/Chat_3.jpeg',
                      fg: fg,
                    ),
                    _buildStoryBubble(
                      name: 'Greece',
                      image: 'assets/Chat_4.jpeg',
                      fg: fg,
                    ),
                    _buildStoryBubble(
                      name: 'Greece',
                      image: 'assets/Chat_5.jpeg',
                      fg: fg,
                    ),
                    _buildStoryBubble(
                      name: 'Greece',
                      image: 'assets/Chat_6.jpeg',
                      fg: fg,
                    ),
                    _buildStoryBubble(
                      name: 'Greece',
                      image: 'assets/Chat_5.jpeg',
                      fg: fg,
                    ),
                    _buildStoryBubble(
                      name: 'Greece',
                      image: 'assets/Chat_4.jpeg',
                      fg: fg,
                    ),
                    _buildStoryBubble(
                      name: 'Greece',
                      image: 'assets/Chat_3.jpeg',
                      fg: fg,
                    ),
                    _buildStoryBubble(
                      name: 'Greece',
                      image: 'assets/Chat_2.jpeg',
                      fg: fg,
                    ),
                    _buildStoryBubble(
                      name: 'Greece',
                      image: 'assets/Chat_1.jpeg',
                      fg: fg,
                    ),
                  ],
                ),
              ),

              // --- CHAT LIST ---
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    _buildChatTile(
                      name: 'Oliver Gibbs',
                      message: 'hahaha',
                      avatar: 'assets/Chat_1.jpeg',
                      hasUnreadDot: true,
                      fg: fg,
                      sub: sub,
                    ),
                    _buildChatTile(
                      name: 'Soho Farmhouse',
                      message: 'Will no photos! 📸',
                      avatar: 'assets/Chat_2.jpeg',
                      hasUnreadDot: true,
                      fg: fg,
                      sub: sub,
                    ),
                    _buildChatTile(
                      name: 'Poppy Jamie',
                      message: 'more invites pls',
                      avatar: 'assets/Chat_3.jpeg',
                      fg: fg,
                      sub: sub,
                    ),
                    _buildChatTile(
                      name: 'Jacob Riglin',
                      message: 'seriously love that shot',
                      avatar: 'assets/Chat_4.jpeg',
                      fg: fg,
                      sub: sub,
                    ),
                    _buildChatTile(
                      name: 'Christian Tierney',
                      message: '🔥🔥🔥',
                      avatar: 'assets/Chat_5.jpeg',
                      fg: fg,
                      sub: sub,
                    ),
                    _buildChatTile(
                      name: 'Team Lapse',
                      message: 'You just released a new build 🔥',
                      avatar: 'assets/Chat_6.jpeg',
                      isSystemBadge: true,
                      fg: fg,
                      sub: sub,
                    ),
                    _buildChatTile(
                      name: "Harry's 21st",
                      message: 'joe perfect 👌',
                      avatar: 'assets/Chat_1.jpeg',
                      fg: fg,
                      sub: sub,
                    ),
                    _buildChatTile(
                      name: 'Anita Grig',
                      message: 'Active recently',
                      avatar: 'assets/Chat_2.jpeg',
                      fg: fg,
                      sub: sub,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryBubble({
    required String name,
    required String image,
    required Color fg,
    bool hasUnread = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 18.0),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: hasUnread ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(image),
                onBackgroundImageError: (_, _) {},
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasUnread)
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                name,
                style: TextStyle(
                  color: fg.withValues(alpha: 0.75),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile({
    required String name,
    required String message,
    required String avatar,
    required Color fg,
    required Color sub,
    bool hasUnreadDot = false,
    bool isSystemBadge = false,
  }) {
    return ListTile(
      dense: true,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12), // square with rounded corners
        child: Image.asset(
          avatar,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 40,
            height: 40,
            color: Colors.grey[300],
            child: const Icon(Icons.person, color: Colors.grey, size: 20),
          ),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(message, style: TextStyle(color: sub, fontSize: 12)),
      trailing: hasUnreadDot
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            )
          : isSystemBadge
          ? const Icon(
              Icons.local_fire_department,
              color: Colors.deepOrange,
              size: 16,
            )
          : null,
    );
  }
}

// --- FRIEND MAP PAGE (Accessed via Chat Tab) ---
class FriendMapPage extends StatelessWidget {
  const FriendMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC7E2D0),
      body: SafeArea(
        child: Stack(
          children: [
            InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(600),
              minScale: 0.6,
              maxScale: 3.0,
              child: SizedBox(
                width: 1400,
                height: 1400,
                child: Stack(
                  children: [
                    Container(color: const Color(0xFFC6E5BA)),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 480,
                      child: Container(color: const Color(0xFF90D5EC)),
                    ),
                    Positioned(
                      top: 140,
                      left: 0,
                      width: 500,
                      height: 380,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFC6E5BA),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(180),
                            bottomRight: Radius.circular(120),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      left: 200,
                      child: Transform.rotate(
                        angle: -0.65,
                        child: Container(
                          width: 1100,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFFBAC2CB),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 480,
                      left: 100,
                      child: Transform.rotate(
                        angle: -0.3,
                        child: Container(
                          width: 1000,
                          height: 8,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 320,
                      left: 200,
                      child: Text(
                        'Bair\nIsland',
                        style: TextStyle(
                          color: Color(0xFF7A9E7E),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 490,
                      left: 440,
                      child: Text(
                        'Menlo Park',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 530,
                      left: 390,
                      child: Text(
                        'Palo Alto',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 680,
                      left: 780,
                      child: Text(
                        'Mountain\nView',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildParkLabel('Windy Hill Preserve', top: 760, left: 160),
                    _buildParkLabel('Foothills Park', top: 750, left: 440),
                    _buildFriendPhotoPin(
                      postImage: 'assets/profile_1.jpeg',
                      avatarImage: 'assets/profile_2.jpeg',
                      top: 210,
                      left: 640,
                      hasSecondaryCard: false,
                    ),
                    _buildFriendPhotoPin(
                      postImage: 'assets/profile_3.jpeg',
                      avatarImage: 'assets/profile_4.jpeg',
                      top: 360,
                      left: 140,
                      hasSecondaryCard: true,
                    ),
                    _buildFriendPhotoPin(
                      postImage: 'assets/profile_5.jpeg',
                      avatarImage: 'assets/profile_6.jpeg',
                      top: 460,
                      left: 700,
                      hasSecondaryCard: false,
                    ),
                    Positioned(
                      top: 580,
                      left: 480,
                      child: Container(
                        padding: const EdgeInsets.all(3.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC4B5FD),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/profile_1.jpeg'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 19,
                        backgroundImage: AssetImage('assets/profile_1.jpeg'),
                      ),
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Colors.black87,
                        size: 22,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.grey,
                                  size: 22,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'San Fransisco',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.explore_outlined,
                            color: Colors.black54,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.explore_outlined,
                            color: Colors.grey,
                            size: 26,
                          ),
                          onPressed: () {},
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.map_rounded,
                              color: Color(0xFF3B82F6),
                              size: 26,
                            ),
                            Container(
                              width: 5,
                              height: 5,
                              margin: const EdgeInsets.only(top: 3),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 30,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.flight_outlined,
                            color: Colors.grey,
                            size: 26,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.grey,
                            size: 26,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendPhotoPin({
    required String postImage,
    required String avatarImage,
    required double top,
    required double left,
    required bool hasSecondaryCard,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              if (hasSecondaryCard)
                Positioned(
                  right: -12,
                  top: 0,
                  child: Container(
                    width: 100,
                    height: 115,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4B94BE),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              Container(
                width: 110,
                height: 125,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3.5),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        postImage,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey[300]),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.all(1.5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: AssetImage(avatarImage),
                          onBackgroundImageError: (_, _) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParkLabel(
    String title, {
    required double top,
    required double left,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF15803D),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF15803D),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class MapsPage extends StatelessWidget {
  final bool isFromPages;
  const MapsPage({super.key, this.isFromPages = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maps')),
      body: const Center(
        child: Text('Maps View', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const _notifications = [
    {
      'icon': Icons.favorite,
      'color': Colors.red,
      'title': 'Bunny liked your story',
      'subtitle': 'Diwali looks after night',
      'time': '5m ago',
      'read': false,
    },
    {
      'icon': Icons.location_on,
      'color': Colors.orange,
      'title': 'New celebration spot discovered',
      'subtitle': 'Celebration hub • 8 min away in Hyderabad',
      'time': '45m ago',
      'read': false,
    },
    {
      'icon': Icons.person_add,
      'color': Colors.blue,
      'title': 'Priya Sharma started following you',
      'subtitle': 'Connect with other local creators',
      'time': '2h ago',
      'read': true,
    },
    {
      'icon': Icons.mode_comment,
      'color': Colors.teal,
      'title': 'Alex Chen replied to your story',
      'subtitle': '"The lights look fantastic! ✨"',
      'time': '5h ago',
      'read': true,
    },
    {
      'icon': Icons.star,
      'color': Colors.amber,
      'title': 'Trending in Hyderabad',
      'subtitle': 'Festival of Lights has 1.2k nearby viewers',
      'time': '1d ago',
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppStrings.get('notifications', globalLanguageNotifier.value),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Mark all read',
              style: TextStyle(color: Color(0xFF8A2BE2)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Filter Chips
          Row(
            children: [
              _buildFilterChip('All', isSelected: true),
              const SizedBox(width: 8),
              _buildFilterChip('Unread', isSelected: false),
              const SizedBox(width: 8),
              _buildFilterChip('Nearby', isSelected: false),
            ],
          ),
          const SizedBox(height: 16),

          ..._notifications.map((n) {
            final isRead = n['read'] as bool;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isRead ? Colors.grey[50] : const Color(0xFFFBF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isRead ? Colors.grey[200]! : const Color(0xFFE5D5F9),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: (n['color'] as Color).withValues(
                      alpha: 0.15,
                    ),
                    child: Icon(
                      n['icon'] as IconData,
                      color: n['color'] as Color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          n['title'] as String,
                          style: TextStyle(
                            fontWeight: isRead
                                ? FontWeight.w600
                                : FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          n['subtitle'] as String,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          n['time'] as String,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isRead)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF8A2BE2),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8A2BE2) : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final UserProfile user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: globalLanguageNotifier,
      builder: (context, currentLang, _) {
        ImageProvider getProfileImage() {
          if (widget.user.profileImagePath.startsWith('assets/')) {
            return AssetImage(widget.user.profileImagePath);
          }
          return FileImage(File(widget.user.profileImagePath));
        }

        final List<Map<String, String>> posts = [
          {'image': 'assets/profile_1.jpeg', 'time': '0:45', 'views': '24.8K'},
          {'image': 'assets/profile_2.jpeg', 'time': '0:32', 'views': '18.2K'},
          {'image': 'assets/profile_3.jpeg', 'time': '0:27', 'views': '12.6K'},
          {'image': 'assets/profile_4.jpeg', 'time': '0:39', 'views': '22.1K'},
          {'image': 'assets/profile_5.jpeg', 'time': '0:21', 'views': '9.8K'},
          {'image': 'assets/profile_6.jpeg', 'time': '0:36', 'views': '16.4K'},
        ];

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // --- TOP APPBAR ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 22,
                        ),
                        onPressed: () {
                          globalTabIndexNotifier.value = 0;
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                              ) => MainScreen(user: widget.user),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    const begin = Offset(-1.0, 0.0);
                                    const end = Offset.zero;
                                    final tween = Tween(begin: begin, end: end)
                                        .chain(
                                          CurveTween(
                                            curve: Curves.easeInOutCubic,
                                          ),
                                        );
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                              transitionDuration: const Duration(
                                milliseconds: 300,
                              ),
                            ),
                          );
                        },
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none,
                              color: Colors.black87,
                              size: 22,
                            ),
                            onPressed: () {
                              // Add your notification action here
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.settings_outlined,
                              color: Colors.black87,
                              size: 22,
                            ),
                            onPressed: () {
                              navigateWithSlide(context, const SettingsPage());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // --- HEADER INFO: Avatar Left, Name & Bio Right ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _openFullScreenViewer(
                          context,
                          widget.user.profileImagePath,
                          widget.user.userName.isNotEmpty
                              ? widget.user.userName
                              : 'user',
                          'Profile Picture',
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: getProfileImage(),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.user.userName.isNotEmpty
                                      ? widget.user.userName
                                      : 'user',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                  size: 15,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '@${widget.user.userName.isNotEmpty ? widget.user.userName.toLowerCase().replaceAll(' ', '') : 'user'}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.user.bio.isNotEmpty
                                  ? widget.user.bio
                                  : 'User',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // --- POSTS, FOLLOWERS & FOLLOWING STATS ROW ---
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            const Text(
                              '48',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              AppStrings.get('posts'),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Container(height: 24, width: 1, color: Colors.grey[300]),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () {
                          navigateWithSlide(
                            context,
                            const FollowersFollowingPage(title: 'Followers'),
                          );
                        },
                        child: Column(
                          children: [
                            const Text(
                              '1,420',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              AppStrings.get('followers'),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Container(height: 24, width: 1, color: Colors.grey[300]),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () {
                          navigateWithSlide(
                            context,
                            const FollowersFollowingPage(title: 'Following'),
                          );
                        },
                        child: Column(
                          children: [
                            const Text(
                              '384',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              AppStrings.get('following'),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // --- EDIT PROFILE BUTTON & ADD FRIEND ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Action when Edit Profile is tapped
                          },
                          child: Container(
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings.get('edit_profile', currentLang),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // Action when Add Friend is tapped
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.person_add_outlined,
                            color: Colors.black87,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // --- TABS ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTabItem(
                      Icons.play_circle_outline,
                      'Videos',
                      _selectedTab == 0,
                      () => setState(() => _selectedTab = 0),
                    ),
                    _buildTabItem(
                      Icons.favorite_border,
                      'Liked',
                      _selectedTab == 1,
                      () => setState(() => _selectedTab = 1),
                    ),
                    _buildTabItem(
                      Icons.bookmark_border,
                      'Saved',
                      _selectedTab == 2,
                      () => setState(() => _selectedTab = 2),
                    ),
                  ],
                ),
                Divider(color: Colors.grey[200], thickness: 1, height: 1),

                // --- POSTS GRID WITH EXACT ASPECT RATIO ---
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(1),
                    itemCount: posts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1.5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio:
                              0.72, // Matches the reference height ratio
                        ),
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return GestureDetector(
                        onTap: () => _openFullScreenViewer(
                          context,
                          post['image']!,
                          'Post #${index + 1}',
                          '${post['time']} • ${post['views']}',
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                post['image']!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(color: Colors.grey[200]),
                              ),
                              Positioned(
                                bottom: 6,
                                left: 6,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${post['time']}    ${post['views']}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isActive ? Colors.black : Colors.black45,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: isActive ? Colors.black : Colors.black45,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 2,
              color: isActive ? Colors.black : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  void _openFullScreenViewer(
    BuildContext context,
    String imagePath,
    String title,
    String stats,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: imagePath.startsWith('assets/')
                      ? Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.white54,
                                  size: 48,
                                ),
                              ),
                        )
                      : Image.file(
                          File(imagePath),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.white54,
                                  size: 48,
                                ),
                              ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    '$title • $stats',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
