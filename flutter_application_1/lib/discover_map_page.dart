import 'package:material_ui/material_ui.dart';

import 'app_strings.dart';

class DiscoverMapPage extends StatefulWidget {
  const DiscoverMapPage({super.key});

  @override
  State<DiscoverMapPage> createState() => _DiscoverMapPageState();
}

class _DiscoverMapPageState extends State<DiscoverMapPage> {
  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: globalLanguageNotifier,
      builder: (context, currentLang, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFFDE8D7),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          AppStrings.get('find_awesome_spots', currentLang),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4F8),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Stack(
                        children: [
                          InteractiveViewer(
                            boundaryMargin: const EdgeInsets.all(400),
                            minScale: 0.8,
                            maxScale: 2.5,
                            child: SizedBox(
                              width: 1200,
                              height: 1200,
                              child: Stack(
                                children: [
                                  Container(color: const Color(0xFFF3F4F6)),
                                  Positioned(
                                    top: 30,
                                    left: 30,
                                    right: 30,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        focusNode: _searchFocus,
                                        controller: _searchController,
                                        onChanged: (_) => setState(() {}),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          filled: true,
                                          hintText: AppStrings.get(
                                            'search',
                                            currentLang,
                                          ),
                                          fillColor: Colors.transparent,
                                          prefixIcon: const Icon(
                                            Icons.search,
                                            color: Colors.black54,
                                            size: 20,
                                          ),
                                          suffixIcon:
                                              _searchController.text
                                                      .trim()
                                                      .isEmpty ||
                                                  !_searchFocus.hasFocus
                                              ? const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 12,
                                                      backgroundImage:
                                                          AssetImage(
                                                            'assets/profile_1.jpeg',
                                                          ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Icon(
                                                      Icons.notifications_none,
                                                      size: 18,
                                                      color: Colors.black54,
                                                    ),
                                                    SizedBox(width: 8),
                                                  ],
                                                )
                                              : IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: const Icon(Icons.close),
                                                  onPressed: () {
                                                    _searchController.clear();
                                                    setState(() {});
                                                  },
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  _buildDiscoverSpotPin(
                                    top: 220,
                                    left: 260,
                                    title: 'Origin Coffee Ro...',
                                    image: 'assets/profile_3.jpeg',
                                  ),
                                  _buildDiscoverSpotPin(
                                    top: 360,
                                    left: 480,
                                    title: 'The Pink Candy...',
                                    image: 'assets/profile_2.jpeg',
                                  ),
                                  _buildDiscoverSpotPin(
                                    top: 480,
                                    left: 560,
                                    title: 'VIXI Social House',
                                    image: 'assets/profile_5.jpeg',
                                  ),
                                  _buildDiscoverSpotPin(
                                    top: 610,
                                    left: 450,
                                    title: 'Kasteel Café',
                                    image: 'assets/profile_6.jpeg',
                                  ),
                                  _buildDiscoverSpotPin(
                                    top: 760,
                                    left: 300,
                                    title: 'Openwine',
                                    image: 'assets/profile_1.jpeg',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    AppStrings.get('search_here', currentLang),
                                    style: const TextStyle(
                                      color: Colors.black45,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.search,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(
                                    Icons.navigation_outlined,
                                    color: Colors.black54,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildDiscoverCategoryChip(
                          AppStrings.get('eat', currentLang),
                          Icons.restaurant_rounded,
                        ),
                        const SizedBox(width: 10),
                        _buildDiscoverCategoryChip(
                          AppStrings.get('cafe', currentLang),
                          Icons.coffee_rounded,
                        ),
                        const SizedBox(width: 10),
                        _buildDiscoverCategoryChip(
                          AppStrings.get('coliving', currentLang),
                          Icons.home_rounded,
                        ),
                        const SizedBox(width: 10),
                        _buildDiscoverCategoryChip(
                          AppStrings.get('bar', currentLang),
                          Icons.local_bar_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiscoverSpotPin({
    required double top,
    required double left,
    required String title,
    required String image,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                image,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(width: 44, height: 44, color: Colors.grey[300]),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverCategoryChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black87),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
