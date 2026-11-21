import 'package:material_ui/material_ui.dart';

import 'app_strings.dart';

class FollowersFollowingPage extends StatefulWidget {
  final String title;

  const FollowersFollowingPage({super.key, required this.title});

  @override
  State<FollowersFollowingPage> createState() => _FollowersFollowingPageState();
}

class _FollowersFollowingPageState extends State<FollowersFollowingPage> {
  final List<Map<String, dynamic>> _users = [
    {
      'name': 'Sophia Carter',
      'handle': '@sophia_c',
      'image': 'assets/profile_1.jpeg',
      'isFollowing': true,
    },
    {
      'name': 'Liam Johnson',
      'handle': '@liam_j_dev',
      'image': 'assets/profile_2.jpeg',
      'isFollowing': false,
    },
    {
      'name': 'Aarav Sharma',
      'handle': '@aarav_tech',
      'image': 'assets/profile_3.jpeg',
      'isFollowing': true,
    },
    {
      'name': 'Ananya Patel',
      'handle': '@ananya_ui',
      'image': 'assets/profile_4.jpeg',
      'isFollowing': false,
    },
    {
      'name': 'Lucas Martin',
      'handle': '@lucas_flutter',
      'image': 'assets/profile_5.jpeg',
      'isFollowing': true,
    },
    {
      'name': 'Emma Watson',
      'handle': '@emma_official',
      'image': 'assets/profile_1.jpeg',
      'isFollowing': true,
    },
    {
      'name': 'Noah Smith',
      'handle': '@noah_creates',
      'image': 'assets/profile_2.jpeg',
      'isFollowing': false,
    },
    {
      'name': 'Rohan Verma',
      'handle': '@rohan_v',
      'image': 'assets/profile_3.jpeg',
      'isFollowing': true,
    },
    {
      'name': 'Priya Nair',
      'handle': '@priya_designs',
      'image': 'assets/profile_4.jpeg',
      'isFollowing': false,
    },
    {
      'name': 'Ethan Hunt',
      'handle': '@ethan_h',
      'image': 'assets/profile_5.jpeg',
      'isFollowing': true,
    },
    {
      'name': 'Chloe Grace',
      'handle': '@chloe_g',
      'image': 'assets/profile_1.jpeg',
      'isFollowing': false,
    },
    {
      'name': 'Kabir Khan',
      'handle': '@kabir_codes',
      'image': 'assets/profile_2.jpeg',
      'isFollowing': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isFollowersTab = widget.title == 'Followers';
    final displayTitle = widget.title == 'Followers'
        ? AppStrings.get('followers')
        : widget.title == 'Following'
            ? AppStrings.get('following')
            : widget.title;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          displayTitle,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          final bool isFollowing = user['isFollowing'] as bool;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage(user['image'] as String),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user['handle'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowing
                          ? Colors.grey[200]
                          : const Color(0xFF0095F6),
                      foregroundColor: isFollowing
                          ? Colors.black87
                          : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    onPressed: () {
                      setState(() {
                        user['isFollowing'] = !isFollowing;
                      });
                    },
                    child: Text(
                      isFollowing
                          ? AppStrings.get('following')
                          : AppStrings.get('follow'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (isFollowersTab) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _users.removeAt(index);
                      });
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
