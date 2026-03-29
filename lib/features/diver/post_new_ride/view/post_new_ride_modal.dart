import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/features/diver/post_new_ride/controller/post_new_ride_controller.dart';

class PostRideView extends StatelessWidget {
  const PostRideView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PostRideController>();
    final ride = controller.ride;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 20.h),

            _buildLabel("Pickup Location"),
            // Asset path instead of Icons.circle
            _buildTextField(hint: "Starting location", iconPath: 'assets/icons/pickup_marker.svg', iconColor: Colors.grey),
            SizedBox(height: 15.h),
            
            _buildLabel("Drop-off Location"),
            _buildTextField(hint: "Destination", iconPath: 'assets/icons/dropoff_marker.svg', iconColor: Colors.black),
            SizedBox(height: 15.h),

            _buildDateTimeRow(),
            SizedBox(height: 15.h),

            _buildSeatsPriceRow(controller),
            SizedBox(height: 20.h),

            _buildToggleRow("Door Pick-up", ride.isDoorPickUp, controller.toggleDoorPickUp),
            if (ride.isDoorPickUp) _buildActionInput(controller.pickupChargesController),
            
            SizedBox(height: 10.h),
            
            _buildToggleRow("Door Drop-off", ride.isDoorDropOff, controller.toggleDoorDropOff),
            if (ride.isDoorDropOff) _buildActionInput(controller.dropoffChargesController),

            SizedBox(height: 25.h),

            _buildDocSection(),

            SizedBox(height: 25.h),

            _buildSubmitButton(context, controller),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 30),
              Text("Post New Ride", style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              IconButton(
                // Close button icon as SVG
                icon: SvgPicture.asset('assets/icons/close.svg', width: 20.sp, height: 20.sp), 
                onPressed: () => Navigator.pop(context)
              ),
            ],
          ),
          Text("Create a new ride listing for passengers", style: GoogleFonts.inter(color: Colors.grey, fontSize: 13.sp)),
        ],
      ),
    );
  }

  Widget _buildDateTimeRow() {
    return Column(
      children: [
        Row(children: [
          Expanded(child: _buildLabel("Date")),
          SizedBox(width: 15.w),
          Expanded(child: _buildLabel("Time")),
        ]),
        Row(children: [
          Expanded(child: _buildTextField(hint: "mm/dd/yyyy", iconPath: 'assets/icons/calendar.svg')),
          SizedBox(width: 15.w),
          Expanded(child: _buildTextField(hint: ".. : ..", iconPath: 'assets/icons/clock.svg')),
        ]),
      ],
    );
  }

  Widget _buildSeatsPriceRow(PostRideController controller) {
    return Column(
      children: [
        Row(children: [
          Expanded(child: _buildLabel("Available Seats")),
          SizedBox(width: 15.w),
          Expanded(child: _buildLabel("Price per Seat")),
        ]),
        Row(children: [
          Expanded(child: _buildTextField(hint: "1 Seat", iconPath: 'assets/icons/seats.svg')),
          SizedBox(width: 15.w),
          Expanded(child: _buildTextField(hint: "45", iconPath: 'assets/icons/dollar.svg', controller: controller.priceController)),
        ]),
      ],
    );
  }

  Widget _buildDocSection() {
    return Column(
      children: [
        _buildDocTile("Selfie Verification", "Take a live selfie (no uploads)", 'assets/icons/selfie_icon.svg', const Color(0xFFE3F2FD), Colors.blue),
        _buildDocTile("Car Photo", "Capture car photo (no uploads)", 'assets/icons/car_icon.svg', const Color(0xFFE8F5E9), Colors.green),
        _buildDocTile("Number Plate", "Capture plate photo (no uploads)", 'assets/icons/number_plate_icon.svg', const Color(0xFFFFF3E0), Colors.orange),
        _buildDocTile("Driving License", "Capture or upload license", 'assets/icons/license_icon.svg', const Color(0xFFF3E5F5), Colors.purple, showUpload: true),
      ],
    );
  }

  // --- Updated Helper Methods with SvgPicture.asset ---

  Widget _buildTextField({required String hint, required String iconPath, Color? iconColor, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.grey),
        prefixIcon: Padding(
          padding: EdgeInsets.all(12.r), // Adjust padding to center SVG correctly
          child: SvgPicture.asset(
            iconPath, 
            colorFilter: ColorFilter.mode(iconColor ?? Colors.grey, BlendMode.srcIn),
            width: 8.sp,
            height: 8.sp,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(vertical: 15.h),
      ),
    );
  }

  Widget _buildDocTile(String title, String subtitle, String iconPath, Color bgColor, Color iconColor, {bool showUpload = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FB), borderRadius: BorderRadius.circular(15.r)),
      child: Row(children: [
        Container(
          padding: EdgeInsets.all(10.r), 
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10.r)), 
          child: SvgPicture.asset(iconPath, colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn), width: 24.sp, height: 24.sp)
        ),
        SizedBox(width: 15.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15.sp)), Text(subtitle, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12.sp))])),
        if (showUpload) IconButton(
          icon: SvgPicture.asset('assets/icons/upload.svg', colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn), width: 20.sp), 
          onPressed: () {}
        ),
        Container(
          padding: EdgeInsets.all(5.r), 
          decoration: BoxDecoration(color: const Color(0xFFFFEBEE), shape: BoxShape.circle), 
          child: SvgPicture.asset('assets/icons/camera.svg', colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn), width: 18.sp)
        ),
      ]),
    );
  }

  // Rest of original submit/label/toggle logic remains the same...
  Widget _buildSubmitButton(BuildContext context, PostRideController controller) {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        onPressed: () => controller.submitRide(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        child: Text("Post Ride", style: GoogleFonts.inter(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(padding: EdgeInsets.only(bottom: 8.h), child: Text(text, style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600)));

  Widget _buildToggleRow(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
      children: [
        Text(title, style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600)),
        Switch(
          value: value, 
          onChanged: onChanged, 
          activeTrackColor: Colors.black, 
          activeThumbColor: Colors.white,      
          inactiveTrackColor: Colors.grey.shade300,
        ),
      ],
    );
  }

  Widget _buildActionInput(TextEditingController controller) {
    return Padding(padding: EdgeInsets.only(top: 8.h, bottom: 8.h), child: Row(children: [
      Expanded(child: _buildTextField(hint: "Enter charges", iconPath: 'assets/icons/dollar.svg', controller: controller)),
      SizedBox(width: 10.w),
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1A1A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
        child: Text("Save", style: GoogleFonts.inter(color: Colors.white)),
      )
    ]));
  }
}