import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 16,
        ),
        SizedBox(width: 10),

        // Chat bubble container
        Container(
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
                      "John Doe",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13.sp,
                            color: const Color(0xFFA5A5A5),
                          ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "18 Feb",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp,
                          color: const Color(0xFF616161),
                        ),
                  ),
                ],
              ),
              SizedBox(height: 4),

              // Message text
              Text(
                "Hello all kapan lari lagi nih!?",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13.sp,
                      color: const Color(0xFFA5A5A5),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
