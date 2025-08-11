import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/extension/initial_profile_empty.dart';
import 'package:zest_mobile/app/core/models/model/chat_model_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, this.isSender = false, this.chat});
  final bool isSender;
  final ChatModel? chat;

  Widget _buildAvatar() {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: chat?.user?.imageUrl ?? '',
        width: 50.r,
        height: 50.r,
        fit: BoxFit.cover,
        placeholder: (context, url) => ShimmerLoadingCircle(
          size: 50.r,
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: 32.r,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          child: Text(
            (chat?.user?.name ?? '-').toInitials(),
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth:
            MediaQuery.of(context).size.width * 0.7, // 70% of screen width
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Date
          Row(
            children: [
              Flexible(
                child: Text(
                  chat?.user?.name ?? "-",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        color: const Color(0xFFA5A5A5),
                      ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                chat?.createdAt!.todMMMString() ?? "-",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13.sp,
                      color: const Color(0xFF616161),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Message text
          Text(
            chat?.message ?? "-",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: const Color(0xFFA5A5A5),
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: isSender
          ? [
              // Bubble pesan (kanan)
              _buildMessage(context),
              SizedBox(width: 8.w),
              _buildAvatar(),
            ]
          : [
              // Avatar dulu (kiri)
              _buildAvatar(),
              SizedBox(width: 8.w),
              _buildMessage(context),
            ],
    );
  }
}
