import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';

class EventDetailCard extends StatelessWidget {
  const EventDetailCard({super.key, required this.event});
  final EventModel? event;
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
              Expanded(
                child: Text(
                  event?.title ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
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
                child: CachedNetworkImage(
                  imageUrl: event?.imageUrl ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: const SizedBox.shrink(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 64, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Image Placeholder',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // title
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: event?.user?.imageUrl ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: const SizedBox.shrink(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ORGANIZED BY',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onTertiary)),
                  Text('[${event?.user?.name}]',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          // description
          Text(
            event?.description ?? '-',
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
                      title: 'Quota',
                      subtitle: '${event?.quota}',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.date_range_outlined,
                      title: 'PERIOD',
                      subtitle: event?.datetime?.toYyyyMmDdString() ?? '-',
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
                      subtitle: event?.address ?? '-',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      icon: Icons.confirmation_num_outlined,
                      title: 'HTM',
                      subtitle:
                          (event?.price ?? 0) > 0 ? '${event?.price}' : 'Free',
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

  Widget _personGridList(
      {required BuildContext context,
      required String title,
      required int itemCount,
      required Widget Function(BuildContext, int) itemBuilder}) {
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
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
