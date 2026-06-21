import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/chat/chat_controller/chat_controller.dart';
//import 'package:ride_sharing/features/chat/chat_model/chat_model.dart';

// class ChatBubble extends StatelessWidget {
//   final ChatMessage message;

//   const ChatBubble({super.key, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     bool isMe = message.sender == MessageSender.me;

//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: Column(
//         crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.end, 
//             children: [
//               // Reverse order logic exactly like image_8.png
//               if (isMe) _buildTime(message.time, isMe),
//               if (isMe) SizedBox(width: 8.w),
              
//               Flexible(
//                 child: Container(
//                   constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7), 
//                   padding: EdgeInsets.all(15.w), 
//                   decoration: BoxDecoration(
//                     color: isMe ? const Color(0xFF1E1E1E) : const Color(0xFFF3F3F3), 
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(15.r),
//                       topRight: Radius.circular(15.r),
//                       bottomLeft: Radius.circular(isMe ? 15.r : 0),
//                       bottomRight: Radius.circular(isMe ? 0 : 15.r),
//                     ),
//                   ),
//                   child: Text(
//                     message.text,
//                     style: GoogleFonts.inter(
//                       fontSize: 16.sp,
//                       color: isMe ? Colors.white : Colors.black, 
//                       fontWeight: FontWeight.w400, 
//                     ),
//                   ),
//                 ),
//               ),
//               if (!isMe) SizedBox(width: 8.w),
//               if (!isMe) _buildTime(message.time, isMe),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method for standard time label layout
//   Widget _buildTime(String time, bool isMe) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 2.h),
//       child: Text(
//         time,
//         style: GoogleFonts.inter(
//           fontSize: 12.sp,
//           color: Colors.grey, 
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     );
//   }
// }

// class ChatBubble extends StatelessWidget {
//   final String text;
//   final String time;
//   final bool isMe;

//   const ChatBubble({
//     super.key, 
//     required this.text, 
//     required this.time, 
//     required this.isMe,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: Column(
//         crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.end, 
//             children: [
//               if (isMe) _buildTime(time),
//               if (isMe) SizedBox(width: 8.w),
              
//               Flexible(
//                 child: Container(
//                   constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7), 
//                   padding: EdgeInsets.all(15.w), 
//                   decoration: BoxDecoration(
//                     color: isMe ? const Color(0xFF1E1E1E) : const Color(0xFFF3F3F3), 
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(15.r),
//                       topRight: Radius.circular(15.r),
//                       bottomLeft: Radius.circular(isMe ? 15.r : 0),
//                       bottomRight: Radius.circular(isMe ? 0 : 15.r),
//                     ),
//                   ),
//                   child: Text(
//                     text,
//                     style: GoogleFonts.inter(
//                       fontSize: 16.sp,
//                       color: isMe ? Colors.white : Colors.black, 
//                       fontWeight: FontWeight.w400, 
//                     ),
//                   ),
//                 ),
//               ),
//               if (!isMe) SizedBox(width: 8.w),
//               if (!isMe) _buildTime(time),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTime(String time) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 2.h),
//       child: Text(
//         time,
//         style: GoogleFonts.inter(
//           fontSize: 12.sp,
//           color: Colors.grey, 
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     );
//   }
// }

class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMe;

  const ChatBubble({
    super.key, 
    required this.text, 
    required this.time, 
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    if (!isMe) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.read<ChatController>().markAsRead();
        }
      });
    }

    // FIXED: Detect if this bubble contains an offer payload string
    final bool isOffer = text.contains('💰');

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end, 
            children: [
              if (isMe) _buildTime(time),
              if (isMe) SizedBox(width: 8.w),
              
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7), 
                  padding: EdgeInsets.all(15.w), 
                  decoration: BoxDecoration(
                    // FIXED: Dynamic coloration context depending on whether it's an offer or normal message text
                    color: isOffer 
                        ? (isMe ? const Color(0xFF2A2E3D) : const Color(0xFFE8EAF6))
                        : (isMe ? const Color(0xFF1E1E1E) : const Color(0xFFF3F3F3)), 
                    border: isOffer ? Border.all(color: Colors.blueAccent.shade200, width: 1) : null,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r),
                      bottomLeft: Radius.circular(isMe ? 15.r : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 15.r),
                    ),
                  ),
                  child: Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      // FIXED: Match contrast text coloring dynamically
                      color: isOffer 
                          ? (isMe ? Colors.amber.shade200 : Colors.indigo.shade900)
                          : (isMe ? Colors.white : Colors.black), 
                      fontWeight: isOffer ? FontWeight.w600 : FontWeight.w400, 
                    ),
                  ),
                ),
              ),
              if (!isMe) SizedBox(width: 8.w),
              if (!isMe) _buildTime(time),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTime(String time) {
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