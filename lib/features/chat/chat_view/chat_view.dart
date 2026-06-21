import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/chat_bubble.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/core/token/token_storage.dart';
import 'package:ride_sharing/features/chat/chat_controller/chat_controller.dart';
import 'package:ride_sharing/features/chat/chat_model/chat_model.dart';
import 'package:ride_sharing/features/chat/widget/trip_context.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChatController>();

    return BaseScaffold(
      isCurved: true,
      // 1. Title Section: Driver Name
      title: Padding(
        padding: EdgeInsets.only(
          bottom: 10.h,
        ), // Consistent space below the name
        child: Text(
          controller.driverName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // 2. Leading Section: Back Arrow + Avatar
      leading: Padding(
        padding: EdgeInsets.only(
          bottom: 10.h,
        ), // Consistent space below arrow & avatar
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              constraints: const BoxConstraints(), // Removes default padding
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => controller.navigateBack(context),
            ),
            SizedBox(width: 8.w),
            CircleAvatar(
              radius: 18.r,
              backgroundColor: Colors.white,
              child: Text(
                controller.driverName.isNotEmpty
                    ? controller.driverName[0].toUpperCase()
                    : "L",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),

      // 3. Actions Section: Phone Icon
      actions: [
        Padding(
          padding: EdgeInsets.only(
            bottom: 10.h,
            left: 80.w,
          ), // Space below phone icon
          child: IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              'assets/icons/call.svg', // Ensure path is correct
              width: 16.56.w,
              height: 16.6.w,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => controller.callDriver(),
          ),
        ),
      ],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // FIXED: This dynamically switches based on who sent the last offer and their role
          _buildActiveNegotiationBar(controller, context),
          
          // Black Message Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, MediaQuery.of(context).padding.bottom + 10.h),
            decoration: const BoxDecoration(color: Color(0xFF121212)),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 54.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F2F6),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: controller.messageInputController,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        hintStyle: TextStyle(color: const Color(0xFF8E8E93), fontSize: 15.sp),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: () => controller.sendMessage(context),
                  child: Container(
                    width: 54.w,
                    height: 54.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/send.svg',
                      width: 22.w,
                      colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 20.h),
        itemCount: controller.messages.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return const TripContextWidget();
          final message = controller.messages[index - 1];
          return ChatBubble(
            text: message.text,
            time: message.time,
            isMe: message.sender == MessageSender.me,
          );
        },
      ),
    );
  }

  // FIXED: Logic to support the complete contextual counter-offer flow dynamically
  Widget _buildActiveNegotiationBar(ChatController controller, BuildContext context) {
    final offerMsg = controller.messages.firstWhere(
      (msg) => msg.text.contains('💰'),
      orElse: () => ChatMessage(text: '', time: '', sender: MessageSender.me),
    );

    // Case 1: No active offer framework yet -> Show original selection inputs
    if (offerMsg.text.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Make an Offer",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: Colors.black),
            ),
            SizedBox(height: 12.h),
            controller.showOfferInput
                ? _buildDynamicOfferInputRow(controller, context)
                : _buildMakeOfferButton(controller),
          ],
        ),
      );
    }

    final bool isMe = offerMsg.sender == MessageSender.me;
    final bool isPending = offerMsg.text.toLowerCase().contains('pending');
    final bool isAccepted = offerMsg.text.toLowerCase().contains('accepted');
    final String amountStr = RegExp(r'\d+').stringMatch(offerMsg.text) ?? "0";

    // Case 2: Deal is Accepted
    if (isAccepted) {
      if (TokenStorage.isDriver) {
        return Container(
          width: double.infinity,
          color: const Color(0xFFE8F5E9),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
          child: Text(
            "🤝 Offer accepted at \$$amountStr. Awaiting trip complete payment.",
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.green.shade900),
            textAlign: TextAlign.center,
          ),
        );
      } else {
        return Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
          child: Row(
            children: [
              _buildActionButton(
                "Proceed to Pay \$$amountStr", 
                Colors.green, 
                Colors.white, 
                () => GoRouter.of(context).push('/payment'),
              ),
            ],
          ),
        );
      }
    }

    // Case 3: I made the offer -> Show holding tray status panel
    if (isPending && isMe) {
      return Container(
        width: double.infinity,
        color: const Color(0xFFFFF3E0),
        padding: EdgeInsets.all(14.h),
        alignment: Alignment.center,
        child: Text(
          "⏳ You have offered \$$amountStr. Waiting for response...",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.orange.shade900),
        ),
      );
    }

    // Case 4: Other side made the offer -> Provide counter/accept utilities
    if (isPending && !isMe) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Counter Offer Received: \$$amountStr",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: Colors.black),
            ),
            SizedBox(height: 12.h),
            controller.showOfferInput
                ? _buildDynamicOfferInputRow(controller, context)
                : Row(
                    children: [
                      _buildActionButton(
                        "Accept", 
                        Colors.green, 
                        Colors.white, 
                        () {
                          controller.respondToOffer(context,'accept');
                        } 
                      ),
                      SizedBox(width: 10.w),
                      _buildActionButton(
                        "Counter Offer", 
                        Colors.white, 
                        Colors.black, 
                        () => controller.toggleOfferInput(true),
                        isOutlined: true,
                      ),
                    ],
                  ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildMakeOfferButton(ChatController controller) {
    return InkWell(
      onTap: () => controller.toggleOfferInput(true),
      child: Container(
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F2F6),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.black, width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.attach_money, color: Colors.black, size: 20),
            SizedBox(width: 8.w),
            Text(
              "Make a Price Offer", 
              style: TextStyle(color: Colors.black, fontSize: 15.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicOfferInputRow(ChatController controller, BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F2F6),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: TextField(
              controller: controller.offerInputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter amount",
                prefixIcon: Icon(Icons.attach_money, color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        _buildActionButton("Send", const Color(0xFF121212), Colors.white, () => controller.sendOffer(context)),
        SizedBox(width: 10.w),
        _buildActionButton("Cancel", Colors.white, Colors.black, () => controller.toggleOfferInput(false), isOutlined: true),
      ],
    );
  }

  Widget _buildActionButton(String text, Color bg, Color textCol, VoidCallback onTap, {bool isOutlined = false}) {
    return Expanded(
      flex: 2,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: textCol,
          elevation: 0,
          side: isOutlined ? BorderSide(color: Colors.grey.shade300) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          minimumSize: Size(0, 50.h),
        ),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
      ),
    );
  }
}