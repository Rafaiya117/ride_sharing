import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/core/theme/background_template/back_ground_template.dart';
import 'package:ride_sharing/features/sharetrip/share_trip_controller/share_trip_controller.dart';
import 'package:ride_sharing/features/sharetrip/widget/sharetrip_card_widget.dart';

class ShareTripView extends StatelessWidget {
  const ShareTripView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ShareTripController>(context);
    const iconColor = Colors.white;

    return BaseScaffold(
      title: "Share Trip", 
      titleAlign: TextAlign.center,
      isCurved: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: iconColor),
        onPressed: () => controller.navigateBack(context),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          const ShareTripCard(),
          _buildSectionTitle('assets/icons/share.svg', "Quick Share"),
          SizedBox(height: 15.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.quickShareOptions.length,
            itemBuilder: (context, index) {
              final option = controller.quickShareOptions[index];
              return _buildQuickShareItem(controller, context, option);
            },
          ),
          SizedBox(height: 35.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF2FF),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What will be shared?",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp, 
                    fontWeight: FontWeight.bold, 
                    color: const Color(0xFF1E1E1E),
                  ),
                ),
                SizedBox(height: 15.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.sharedDetailsInfo
                      .map((infoText) => _buildBulletPoint(infoText))
                      .toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildQuickShareItem(ShareTripController controller, BuildContext context, Map<String, String> option) {
    return GestureDetector(
      onTap: () => controller.handleQuickShare(context, option['id']!),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              option['iconPath']!,
              width: 20.w,
              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Text(
                option['label']!,
                style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String iconPath, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath, 
            width: 20.r, 
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 20.sp, 
              fontWeight: FontWeight.bold, 
              color: const Color(0xFF1E1E1E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String infoText) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: const CircleAvatar(radius: 2, backgroundColor: Colors.black54),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              infoText,
              style: GoogleFonts.inter(
                fontSize: 14.sp, 
                color: Colors.black.withOpacity(0.85), 
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}