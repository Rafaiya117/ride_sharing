import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/core/utils/bottom_nav.dart';
import 'package:ride_sharing/features/chat/chat_view/chat_view.dart';
import 'package:ride_sharing/features/message_screen/controller/message_screen_controller.dart';
import 'package:ride_sharing/features/message_screen/model/message_screen_model.dart';


class Message extends StatelessWidget {
  const Message({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MessageController();

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return BaseScaffold(
          // --- Header Implementation ---
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Message",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          isCurved: false,
          bottomNavigationBar: CustomBottomNavbar(
            currentIndex: controller.currentNavbarIndex,
            onTap: (index) => controller.setNavbarIndex(index), 
          ),
          
          // --- Body Implementation ---
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                child: TextField(
                  // FIXED: Hooked query inputs to request tracking logic execution pipelines
                  onChanged: (value) => controller.searchMessages(value),
                  decoration: InputDecoration(
                    hintText: 'Search message...',
                    hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14.sp),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 22.r),
                    filled: true,
                    fillColor: const Color(0xFFF8F9FA),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // Optional: Render loading spinner if fetching results
              if (controller.isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()))
              else
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final item = controller.messages[index];
                  return MessageTile(
                    messageData: item,
                    onTap: () {
                      GoRouter.of(context).push('/chat', extra: item.id);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- Internal Component Sub-View ---
class MessageTile extends StatelessWidget {
  final MessageModel messageData;
  final VoidCallback onTap; // Added Callback reference

  const MessageTile({
    super.key,
    required this.messageData,
    required this.onTap, // Received via constructor
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Wrapped item layout with interaction detection
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26.sp,
                  backgroundImage: NetworkImage(messageData.avatarUrl),
                  backgroundColor: const Color(0xFFC4EED3),
                ),
                if (messageData.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14.sp,
                      height: 14.sp,
                      decoration: BoxDecoration(
                        color: const Color(0xFF13D35B),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            messageData.name,
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (messageData.isYou)
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: Text(
                                "You",
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF888888),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        messageData.timestamp,
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    messageData.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF888888),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}