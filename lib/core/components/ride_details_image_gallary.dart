import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class VehicleImageGallery extends StatelessWidget {
  final List<String> imageUrls;
  const VehicleImageGallery({
    super.key,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Text(
            'Vehicle Information',
            style: GoogleFonts.inter(
              fontSize: 18.sp, 
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E2732),
            ),
          ),
        ),        
        // Main Image with fixed height to prevent UI shift
        _buildNetworkImage(
          url: imageUrls.isNotEmpty ? imageUrls[0] : '',
          width: double.infinity,
          height: 180.h,
          radius: 24.r,
        ),        
        SizedBox(height: 10.h),
        // Thumbnail Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(3, (index) {
            // Check if backend provided enough images, otherwise show empty state
            String url = (imageUrls.length > index + 1) ? imageUrls[index + 1] : '';
            return _buildNetworkImage(
              url: url,
              width: 105.w,
              height: 70.h,
              radius: 16.r,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildNetworkImage({
    required String url,
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3), 
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: url.isEmpty
          ? const Center(child: Icon(Icons.image, color: Colors.grey))
          : Image.network(
            url,
            fit: BoxFit.cover,               
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
                return Container(color: const Color(0xFFF3F3F3));
              },
              // Prevents UI crash if URL is broken
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
              },
            ),
          ),
        );
      }
    }