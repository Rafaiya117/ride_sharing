import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_sharing/features/chat/chat_model/chat_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isMe = message.sender == MessageSender.me;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end, 
            children: [
              // Reverse order logic exactly like image_8.png
              if (isMe) _buildTime(message.time, isMe),
              if (isMe) SizedBox(width: 8.w),
              
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7), 
                padding: EdgeInsets.all(15.w), 
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFF1E1E1E) : const Color(0xFFF3F3F3), 
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    topRight: Radius.circular(15.r),
                    bottomLeft: Radius.circular(isMe ? 15.r : 0),
                    bottomRight: Radius.circular(isMe ? 0 : 15.r),
                  ),
                ),
                child: Text(
                  message.text,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: isMe ? Colors.white : Colors.black, 
                    fontWeight: FontWeight.w400, 
                  ),
                ),
              ),
              if (!isMe) SizedBox(width: 8.w),
              if (!isMe) _buildTime(message.time, isMe),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method for standard time label layout
  Widget _buildTime(String time, bool isMe) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Text(
        time,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          color: Colors.grey, 
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}