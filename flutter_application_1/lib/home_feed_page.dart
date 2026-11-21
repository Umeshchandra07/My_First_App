import 'package:material_ui/material_ui.dart';

import 'app_strings.dart';

class InteractivePostCard extends StatefulWidget {
  final String imagePath;
  final String heroTag;
  final String likesLabel;
  final VoidCallback? onCommentTap;

  const InteractivePostCard({
    super.key,
    required this.imagePath,
    required this.heroTag,
    this.likesLabel = '107k Liked',
    this.onCommentTap,
  });

  @override
  State<InteractivePostCard> createState() => _InteractivePostCardState();
}

class _InteractivePostCardState extends State<InteractivePostCard>
    with TickerProviderStateMixin {
  bool _isLiked = false;
  bool _showHeartOverlay = false;
  late AnimationController _heartController;
  late Animation<double> _heartScale;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Playful float controller for the floating avatars
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0.0, end: -6.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );

    _heartScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 45,
      ),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 20),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 35,
      ),
    ]).animate(_heartController);

    _heartController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _showHeartOverlay = false);
      }
    });
  }

  void _triggerDoubleTapLike() {
    setState(() {
      _isLiked = true;
      _showHeartOverlay = true;
    });
    _heartController.forward(from: 0.0);
  }

  void _toggleLikeButton() {
    setState(() => _isLiked = !_isLiked);
  }

  @override
  void dispose() {
    _heartController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double cutoutWidth = 410 * 0.5; // 50% of the image width
    const double cutoutHeight = 45.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. CURVED IMAGE WITH BOTTOM-LEFT ACTION CUTOUT
        GestureDetector(
          onDoubleTap: _triggerDoubleTapLike,
          child: SizedBox(
            height: 410,
            width: double.infinity,
            child: Stack(
              children: [
                // Main Clipped Image
                Positioned.fill(
                  child: Hero(
                    tag: widget.heroTag,
                    child: ClipPath(
                      clipper: _PostCardCutoutClipper(
                        cutoutWidth: cutoutWidth,
                        cutoutHeight: cutoutHeight,
                        radius: 28,
                      ),
                      child: Image.asset(widget.imagePath, fit: BoxFit.cover),
                    ),
                  ),
                ),

                // Subtle top & bottom gradients for text readability
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 90,
                  child: IgnorePointer(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.45),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Top Profile Bar Overlay
                Positioned(
                  top: 14,
                  left: 14,
                  right: 14,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.purple, Colors.orange, Colors.pink],
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 19,
                          backgroundImage: AssetImage('assets/profile_1.jpeg'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'mindcast',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.verified,
                                  color: Color(0xFF9B51E0), // Purple badge
                                  size: 15,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Handle music note tap
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(
                                      Icons.music_note,
                                      color: Colors.black87,
                                      size: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Expanded(
                                  child: Text(
                                    'Imam Majboor, Neha Nair, Kinavu Kondu',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Off-white circle menu button
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.more_vert,
                            color: Color.fromARGB(221, 241, 241, 241),
                            size: 18,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),

                // Staggered Floating Avatars with Playful Bobbing Animation
                Positioned(
                  bottom: cutoutHeight + 28,
                  left: 22,
                  child: AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: child,
                      );
                    },
                    child: _buildFloatingAvatarWithHeart(
                      'assets/profile_2.jpeg',
                    ),
                  ),
                ),
                Positioned(
                  bottom: cutoutHeight + 10,
                  left: 62,
                  child: AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      // Slight phase shift for organic playful movement
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value * 0.7),
                        child: child,
                      );
                    },
                    child: _buildFloatingAvatarWithHeart(
                      'assets/profile_3.jpeg',
                    ),
                  ),
                ),

                // Bottom-Left Action Icons inside the White Cutout
                Positioned(
                  bottom: 5,
                  // right: 0,
                  left: 8,
                  width: cutoutWidth - 50,
                  height: cutoutHeight - 25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _toggleLikeButton,
                        child: AnimatedScale(
                          scale: _isLiked ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOutBack,
                          child: Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            color: _isLiked ? Colors.red : Colors.black87,
                            size: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onCommentTap,
                        child: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.black87,
                          size: 30,
                        ),
                      ),
                      const Icon(
                        Icons.send_outlined,
                        color: Colors.black87,
                        size: 30,
                      ),
                      const Icon(
                        Icons.add_reaction_outlined,
                        color: Colors.black87,
                        size: 30,
                      ),
                    ],
                  ),
                ),

                // Bottom-Right Liker Avatars + "107k Liked" Overlay on Photo
                Positioned(
                  bottom: 15,
                  right: 14,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 44,
                        height: 26,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              child: _circleAvatar('assets/profile_2.jpeg', 12),
                            ),
                            Positioned(
                              left: 14,
                              child: _circleAvatar('assets/profile_3.jpeg', 12),
                            ),
                            Positioned(
                              left: 28,
                              child: _circleAvatar('assets/profile_4.jpeg', 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.likesLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 6, color: Colors.black54),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Double-Tap Heart Animation
                if (_showHeartOverlay)
                  Positioned.fill(
                    child: Center(
                      child: ScaleTransition(
                        scale: _heartScale,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 98,
                          shadows: [
                            Shadow(blurRadius: 20, color: Colors.black45),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // 2. TIMESTAMP & CAPTION SECTION
        const Text(
          '12h ago',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 4),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.grey, fontSize: 12.5),
            children: [
              TextSpan(
                text: '@vibeteller, @mooddreamlms ',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              TextSpan(text: 'and others liked this post!'),
            ],
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              color: Colors.black87,
              fontSize: 13.5,
              height: 1.3,
            ),
            children: [
              TextSpan(
                text: '@mindcast ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'soft hues, slow days, and a heart full of stillness 🤍✨',
              ),
              TextSpan(
                text: '...more',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingAvatarWithHeart(String assetPath) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(assetPath),
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.all(2.5),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite, color: Colors.red, size: 10),
          ),
        ),
      ],
    );
  }

  Widget _circleAvatar(String imagePath, double radius) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.2),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(imagePath),
      ),
    );
  }
}

class _PostCardCutoutClipper extends CustomClipper<Path> {
  final double cutoutWidth;
  final double cutoutHeight;
  final double radius;

  _PostCardCutoutClipper({
    required this.cutoutWidth,
    required this.cutoutHeight,
    this.radius = 28.0,
  });

  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;
    final double r = radius;
    const double notchR = 22.0;

    return Path()
      ..moveTo(r, 0)
      ..lineTo(w - r, 0)
      ..quadraticBezierTo(w, 0, w, r)
      ..lineTo(w, h - r)
      ..quadraticBezierTo(w, h, w - r, h)
      // Bottom-right tab leading into the inner curve
      ..lineTo(cutoutWidth + notchR, h)
      ..quadraticBezierTo(cutoutWidth, h, cutoutWidth, h - notchR)
      // Vertical rise of the cutout
      ..lineTo(cutoutWidth, h - cutoutHeight + notchR)
      ..quadraticBezierTo(
        cutoutWidth,
        h - cutoutHeight,
        cutoutWidth - notchR,
        h - cutoutHeight,
      )
      // Left corner above the action icons
      ..lineTo(r, h - cutoutHeight)
      ..quadraticBezierTo(0, h - cutoutHeight, 0, h - cutoutHeight - r)
      ..lineTo(0, r)
      ..quadraticBezierTo(0, 0, r, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant _PostCardCutoutClipper oldClipper) {
    return oldClipper.cutoutWidth != cutoutWidth ||
        oldClipper.cutoutHeight != cutoutHeight ||
        oldClipper.radius != radius;
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder<String>(
        valueListenable: globalLanguageNotifier,
        builder: (context, currentLang, _) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 98,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            final names = [
                              'nikhil_01',
                              'naresh_ju',
                              'medipallia',
                              'sofiyan_72',
                              'kabhi_97',
                              'abdul_shif',
                              'ananya_ui',
                              'rohan_v',
                            ];
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2.5),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFFBAA47),
                                          Color(0xFFD91A46),
                                          Color(0xFFA60F93),
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      ),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircleAvatar(
                                        radius: 28,
                                        backgroundImage: AssetImage(
                                          'assets/profile_${(index % 5) + 1}.jpeg',
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: 68,
                                    child: Text(
                                      names[index],
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFeedPost(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedPost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/profile_2.jpeg'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'frontlinesmedia',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        color: Color(0xFF0095F6),
                        size: 15,
                      ),
                      Text(
                        ' • 1d',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'AI content',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.more_horiz, color: Colors.black87),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/Diwali_1.jpg',
            width: double.infinity,
            height: 460,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Icon(Icons.favorite_border, color: Colors.black87, size: 26),
            SizedBox(width: 16),
            Icon(Icons.chat_bubble_outline, color: Colors.black87, size: 24),
            SizedBox(width: 16),
            Icon(Icons.send_outlined, color: Colors.black87, size: 24),
            Spacer(),
            Icon(Icons.bookmark_border, color: Colors.black87, size: 26),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Liked by sakethyalamanchili and others',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}
