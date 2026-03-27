import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 20.h),

            _buildLabel("Pickup Location"),
            _buildTextField(hint: "Starting location", icon: Icons.circle, iconColor: Colors.grey),
            SizedBox(height: 15.h),
            
            _buildLabel("Drop-off Location"),
            _buildTextField(hint: "Destination", icon: Icons.circle, iconColor: Colors.black),
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

  // --- UI Component Helpers (Extracted for Clarity) ---

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 30),
              Text("Post New Ride", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          Text("Create a new ride listing for passengers", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
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
          Expanded(child: _buildTextField(hint: "mm/dd/yyyy", icon: Icons.calendar_today_outlined)),
          SizedBox(width: 15.w),
          Expanded(child: _buildTextField(hint: ".. : ..", icon: Icons.access_time)),
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
          Expanded(child: _buildTextField(hint: "1 Seat", icon: Icons.people_outline)),
          SizedBox(width: 15.w),
          Expanded(child: _buildTextField(hint: "45", icon: Icons.attach_money, controller: controller.priceController)),
        ]),
      ],
    );
  }

  Widget _buildDocSection() {
    return Column(
      children: [
        _buildDocTile("Selfie Verification", "Take a live selfie (no uploads)", Icons.person_outline, const Color(0xFFE3F2FD), Colors.blue),
        _buildDocTile("Car Photo", "Capture car photo (no uploads)", Icons.directions_car_filled_outlined, const Color(0xFFE8F5E9), Colors.green),
        _buildDocTile("Number Plate", "Capture plate photo (no uploads)", Icons.assignment_outlined, const Color(0xFFFFF3E0), Colors.orange),
        _buildDocTile("Driving License", "Capture or upload license", Icons.credit_card_outlined, const Color(0xFFF3E5F5), Colors.purple, showUpload: true),
      ],
    );
  }

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
        child: Text("Post Ride", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // Reuse the existing helper methods from your original code
  Widget _buildLabel(String text) => Padding(padding: EdgeInsets.only(bottom: 8.h), child: Text(text, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)));

  Widget _buildTextField({required String hint, required IconData icon, Color? iconColor, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: iconColor ?? Colors.grey, size: 20.sp),
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(vertical: 15.h),
      ),
    );
  }

  Widget _buildToggleRow(String title, bool value, Function(bool) onChanged) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
      Switch(value: value, onChanged: onChanged, activeColor: Colors.black),
    ]);
  }

  Widget _buildActionInput(TextEditingController controller) {
    return Padding(padding: EdgeInsets.only(top: 8.h, bottom: 8.h), child: Row(children: [
      Expanded(child: _buildTextField(hint: "Enter charges", icon: Icons.attach_money, controller: controller)),
      SizedBox(width: 10.w),
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1A1A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
        child: const Text("Save", style: TextStyle(color: Colors.white)),
      )
    ]));
  }

  Widget _buildDocTile(String title, String subtitle, IconData icon, Color bgColor, Color iconColor, {bool showUpload = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FB), borderRadius: BorderRadius.circular(15.r)),
      child: Row(children: [
        Container(padding: EdgeInsets.all(10.r), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10.r)), child: Icon(icon, color: iconColor, size: 24.sp)),
        SizedBox(width: 15.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)), Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 12.sp))])),
        if (showUpload) IconButton(icon: const Icon(Icons.file_upload_outlined, color: Colors.grey), onPressed: () {}),
        Container(padding: EdgeInsets.all(5.r), decoration: BoxDecoration(color: const Color(0xFFFFEBEE), shape: BoxShape.circle), child: Icon(Icons.camera_alt_outlined, color: Colors.red, size: 18.sp)),
      ]),
    );
  }
}