import 'package:flutter/material.dart';
import 'package:zest_mobile/app/modules/social/widgets/social_action_button.dart';
import 'package:zest_mobile/app/modules/social/widgets/statistic_column.dart';

class ActivityDetailCard extends StatelessWidget {
  const ActivityDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(context),
          const SizedBox(height: 8),
          _buildCardContent(context),
          const SizedBox(height: 15),
          _buildMapPlaceholder(),
          const SizedBox(height: 10),
          _buildStatisticsSection(context),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.yellow.shade100,
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(Icons.monetization_on_outlined, color: Colors.yellow.shade900),
                const SizedBox(width: 8),
                Text('Earned', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('Rp 20.000', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            '126 likes',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
          ),
          const SizedBox(height: 15),
          _buildSocialActions(),
          const SizedBox(height: 15),
          _buildCommentSection(context),
        ],
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16, 
          backgroundColor: Colors.grey.shade300,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('John Doe', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            Text('Today, San Francisco, 05:00 AM', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onTertiary)),
          ],
        ),
      ],
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Morning Walk', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 5),
        Text('Freezing morning run', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
      ],
    );
  }

  Widget _buildMapPlaceholder() {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.grey.shade300,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('Map Placeholder', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.grey.shade300,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('Image Placeholder', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: Theme.of(context).colorScheme.primary,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatisticsColumn(title: 'DISTANCE', value: '2.57 km'),
          StatisticsColumn(title: 'STEPS', value: '4,052'),
          StatisticsColumn(title: 'AVG. PACE', value: '8:10'),
          StatisticsColumn(title: 'MOVING TIME', value: '37:17'),
        ],
      ),
    );
  }

  Widget _buildSocialActions() {
    return Row(
      children: [
        Expanded(child: SocialActionButton(icon: Icons.local_fire_department_outlined, label: 'Like', onTap: () {})),
        const SizedBox(width: 8),
        Expanded(child: SocialActionButton(icon: Icons.chat_bubble_outline, label: 'Comment', onTap: () {})),
        const SizedBox(width: 8),
        Expanded(child: SocialActionButton(icon: Icons.share_outlined, label: 'Share', onTap: () {})),
      ],
    );
  }

  Widget _buildCommentSection(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: Theme.of(context).colorScheme.onTertiary, thickness: 0.3),
              const SizedBox(height: 15),
              Text(
                'Comments',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildCommentItem(
                    context: context,
                    profileImageUrl: 'https://example.com/photo1.jpg',
                    name: 'Ralph',
                    date: '18 Feb',
                    comment: 'That walk looks amazing! Nothing beats spending time outdoors, getting fresh air, and moving your body. I bet it was super refreshing and a great way to clear your mind.',
                    replies: [
                      _buildCommentItem(
                        context: context,
                        profileImageUrl: 'https://example.com/photo2.jpg',
                        name: 'Jane Doe',
                        date: 'Just Now',
                        comment: 'Thanks! Mind to join?',
                      ),
                    ],
                  ),
                  _buildCommentItem(
                    context: context,
                    profileImageUrl: 'https://example.com/photo1.jpg',
                    name: 'Ralph',
                    date: '18 Feb',
                    comment: 'That walk looks amazing! Nothing beats spending time outdoors, getting fresh air, and moving your body. I bet it was super refreshing and a great way to clear your mind.',
                    replies: [
                      _buildCommentItem(
                        context: context,
                        profileImageUrl: 'https://example.com/photo2.jpg',
                        name: 'Jane Doe',
                        date: 'Just Now',
                        comment: 'Thanks! Mind to join?',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your comment',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem({
    required BuildContext context,
    required String profileImageUrl,
    required String name,
    required String date,
    required String comment,
    List<Widget>? replies,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto Profil
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 10),
              // Name & Date
              Text(
                name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(width: 5),
              Text(
                date,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onTertiary
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Isi Komentar
          Padding(
            padding: const EdgeInsets.only(left: 35), // ngikut foto profil
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // Hapus semua padding
                    minimumSize: const Size(0, 0), // Minimum size 0
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Hapus area klik yang lebar
                    alignment: Alignment.centerLeft, // Biar text nempel kiri
                  ),
                  child: Text(
                    'Reply',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 12)
                  ),
                ),
                const SizedBox(height: 6),
                // Kalau ada balasan (nested replies)
                if (replies != null) ...replies,
              ],
            ),
          ),
        ],
      ),
    );
  }

}