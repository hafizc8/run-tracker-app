import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zest_mobile/app/core/extension/time_extension.dart';
import 'package:zest_mobile/app/core/models/model/chat_model_model.dart';

class ChatBubbleUser extends StatelessWidget {
  final ChatModel chat;
  final bool isSender;

  const ChatBubbleUser({
    super.key,
    required this.chat,
    required this.isSender,
  });

  Widget _buildMsgIsSender(buildContext, bgColor, textColor) {
    return Row(
      children: [
        Text(
          chat.createdAt != null ? chat.createdAt!.toLocalHourMinute() : '',
          style: TextStyle(
            color: Color(0xFF707070),
            fontSize: 10.sp,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(buildContext).size.width * 0.7),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.r),
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
    );
  }

  Widget _buildMsgIsNotSender(buildContext, bgColor, textColor) {
    return Row(
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(buildContext).size.width * 0.7),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            chat.message ?? '',
            style: TextStyle(
              color: textColor,
              fontSize: 14.sp,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          chat.createdAt != null ? chat.createdAt!.toLocalHourMinute() : '',
          style: TextStyle(
            color: Color(0xFF707070),
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isSender ? Color(0xFFbfff00) : Color(0xFF4a4a4a);
    final textColor = isSender ? Colors.black : Colors.white;

    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        isSender
            ? _buildMsgIsSender(context, bgColor, textColor)
            : _buildMsgIsNotSender(context, bgColor, textColor)
      ],
    );
  }
}
