import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/components/chat_bubble.dart';
import 'package:ride_sharing/core/components/custom_text_field.dart';
import 'package:ride_sharing/core/components/reusable_primary_button.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/chat/chat_controller/chat_controller.dart';
import 'package:ride_sharing/features/chat/widget/trip_context.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChatController>();
    const iconColor = Colors.white;

    return BaseScaffold(
      title: controller.driverName,
      titleAlign: TextAlign.center,
      isCurved: false, 
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => controller.navigateBack(context),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset('assets/icons/call.svg', width: 24.w, colorFilter: const ColorFilter.mode(iconColor, BlendMode.srcIn)),
          onPressed: () => controller.callDriver(),
        ),
      ],
      
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 20.h, bottom: 220.h), 
              itemCount: controller.messages.length + 1, 
              itemBuilder: (context, index) {
                if (index == 0) return const TripContextWidget();
                return ChatBubble(message: controller.messages[index - 1]);
              },
            ),
          ),

          // --- Footer Area ---
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSectionTitle("Make an Offer"),
                  SizedBox(height: 15.h),
                  
                  // DYNAMIC UI SWAP
                  controller.showOfferInput 
                    ? _buildDynamicOfferInputRow(controller, context)
                    : _buildMakeOfferButton(controller, context),

                  SizedBox(height: 25.h),
                  const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                  SizedBox(height: 15.h),

                  // --- Message Input ---
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48.h,
                          decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(15.r)),
                          child: TextField(
                            controller: controller.messageInputController,
                            decoration: InputDecoration(
                              hintText: "Type your message...",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      GestureDetector(
                        onTap: () => controller.sendMessage(context),
                        child: SvgPicture.asset('assets/icons/send.svg', width: 48.w),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
    );
  }

  // Shown by default
  Widget _buildMakeOfferButton(ChatController controller, BuildContext context) {
    return ReusablePrimaryButton( 
      text: "\$  Make a Price Offer",
      onTap: () => controller.toggleOfferInput(true),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 50.h),
        side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5), 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)), 
        backgroundColor: Colors.white,
      ),
      textStyle: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
    );
  }

  // Shown when "Make a price offer" is clicked
  Widget _buildDynamicOfferInputRow(ChatController controller, BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CustomTextField(
            controller: controller.offerInputController,
            hintText: "Enter amount",
            prefixIconPath: 'assets/icons/dollar.svg',
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: ReusablePrimaryButton(
            text: "Send",
            onTap: () => controller.sendOffer(context),
            backgroundColor: Colors.black,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(0, 50.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: ReusablePrimaryButton(
            text: "Cancel",
            onTap: () => controller.toggleOfferInput(false),
            backgroundColor: Colors.white,
            style: OutlinedButton.styleFrom(
              minimumSize: Size(0, 50.h),
              side: const BorderSide(color: Color(0xFFE0E0E0)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            textStyle: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}