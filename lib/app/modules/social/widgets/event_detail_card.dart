import 'package:flutter/material.dart';

class EventDetailCard extends StatelessWidget {
  const EventDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Valentine\'s Date',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Icon(
                Icons.share_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Image
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              // borderRadius: BorderRadius.circular(12),
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
          ),
          const SizedBox(height: 15),
          // title
          Row(
            children: [
              CircleAvatar(
                radius: 18, 
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ORGANIZED BY', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onTertiary)),
                  Text('[INDIVIDUAL/CLUB NAME]', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          // description
          Text(
            'Description The sky\'s the limit for this challenge. Run repeats on your local hill or gear up for a huge mountain adventure – however you do it, climb at least 2,000 meters over as many activities as you like. You\'ll get a sweet finisher\'s badge plus race-ready legs!',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.track_changes_outlined,
                      title: 'TARGET',
                      subtitle: '10.000',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.date_range_outlined,
                      title: 'PERIOD',
                      subtitle: '14 February 2025',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.map_outlined,
                      title: 'LOCATION',
                      subtitle: 'Anywhere',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.confirmation_num_outlined,
                      title: 'HTM',
                      subtitle: 'Free',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Going list
          _personGridList(
            context: context,
            title: 'Going',
            itemCount: 3,
            itemBuilder: (context, index) => _buildPersonList(context),
          ),
          const SizedBox(height: 15),
          // Waitlist
          _personGridList(
            context: context,
            title: 'Waitlist',
            itemCount: 3,
            itemBuilder: (context, index) => _buildPersonList(context),
          ),
        ],
      ),
    );
  }

  Widget _personGridList({required BuildContext context, required String title, required int itemCount, required Widget Function(BuildContext, int) itemBuilder}) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title ($itemCount)',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          GridView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'John Doe',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}