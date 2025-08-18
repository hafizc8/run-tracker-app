import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zest_mobile/app/core/extension/initial_profile_empty.dart';
import 'package:zest_mobile/app/core/extension/time_extension.dart';
import 'package:zest_mobile/app/core/models/model/chat_model_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    this.isSender = false,
    this.chat,
    this.showUserInfo = true, // tambahkan parameter baru
  });

  final bool isSender;
  final ChatModel? chat;
  final bool showUserInfo;

  Widget _buildAvatar() {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: chat?.user?.imageUrl ?? '',
        width: 27.r,
        height: 27.r,
        fit: BoxFit.cover,
        placeholder: (context, url) => ShimmerLoadingCircle(
          size: 27.r,
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: 17.r,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          child: Text(
            (chat?.user?.name ?? '-').toInitials(),
          ),
        ),
      ),
    );
  }

  Widget _buildMsgIsSender(
      BuildContext buildContext, Color bgColor, Color textColor) {
    return Row(
      children: [
        Text(
          chat?.createdAt != null ? chat!.createdAt!.toLocalHourMinute() : '',
          style: TextStyle(
            color: Color(0xFF707070),
            fontSize: 10.sp,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(buildContext).size.width * 0.7),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            chat?.message ?? '',
            style: TextStyle(
              color: textColor,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMsgIsNotSender(
      BuildContext buildContext, Color bgColor, Color textColor) {
    // Kalau showUserInfo == false, sembunyikan avatar dan nama, tapi beri padding agar rata
    if (!showUserInfo) {
      return Padding(
        padding: EdgeInsets.only(left: 28.w),
        child: Row(
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(buildContext).size.width * 0.7),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                chat?.message ?? '',
                style: Theme.of(buildContext).textTheme.bodyMedium?.copyWith(
                      color: Color(0xFFA5A5A5),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              chat?.createdAt != null
                  ? chat!.createdAt!.toLocalHourMinute()
                  : '',
              style: TextStyle(
                color: Color(0xFF707070),
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      );
    }

    // Jika showUserInfo == true, tampilkan avatar dan nama seperti biasa
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatar(),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chat?.user?.name ?? '',
              style: Theme.of(buildContext).textTheme.bodyMedium?.copyWith(
                    color: Color(0xFFA5A5A5),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(buildContext).size.width * 0.7),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    chat?.message ?? '',
                    style:
                        Theme.of(buildContext).textTheme.bodyMedium?.copyWith(
                              color: Color(0xFFA5A5A5),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  chat?.createdAt != null
                      ? chat!.createdAt!.toLocalHourMinute()
                      : '',
                  style: TextStyle(
                    color: Color(0xFF707070),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isSender ? const Color(0xFFbfff00) : const Color(0xFF393939);
    final textColor = isSender ? Colors.black : Colors.white;

    switch (chat?.type) {
      case 3:
        return Row(
          mainAxisAlignment:
              isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            isSender
                ? _buildMsgIsSender(context, bgColor, textColor)
                : _buildMsgIsNotSender(context, bgColor, textColor),
          ],
        );
      default:
        return Text(
          chat?.message ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFA5A5A5),
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
        );
    }
  }
}
