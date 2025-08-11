import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zest_mobile/app/core/extension/initial_profile_empty.dart';
import 'package:zest_mobile/app/core/models/model/chat_model_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';

class ChatBubbleUser extends StatelessWidget {
  final ChatModel chat;
  final bool isSender;

  const ChatBubbleUser({
    super.key,
    required this.chat,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSender ? Color(0xFFbfff00) : Color(0xFF4a4a4a);
    final textColor = isSender ? Colors.black : Colors.white;

    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // if (!isSender)
        //   ClipOval(
        //     child: CachedNetworkImage(
        //       imageUrl: chat.user?.imageUrl ?? '',
        //       width: 43.r,
        //       height: 43.r,
        //       fit: BoxFit.cover,
        //       placeholder: (context, url) => ShimmerLoadingCircle(
        //         size: 50.r,
        //       ),
        //       errorWidget: (context, url, error) => CircleAvatar(
        //         radius: 32.r,
        //         backgroundColor: Theme.of(context).colorScheme.onBackground,
        //         child: Text(
        //           (chat.user?.name ?? '-').toInitials(),
        //         ),
        //       ),
        //     ),
        //   ),

        Row(
          children: [
            Text(
              chat.createdAt != null
                  ? "${chat.createdAt!.hour.toString().padLeft(2, '0')}:${chat.createdAt!.minute.toString().padLeft(2, '0')}"
                  : '',
              style: TextStyle(
                color: Color(0xFF707070),
                fontSize: 10.sp,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                  bottomLeft:
                      isSender ? Radius.circular(12.r) : Radius.circular(0),
                  bottomRight:
                      isSender ? Radius.circular(0) : Radius.circular(12.r),
                ),
              ),
              child: Text(
                chat.message ?? '',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
