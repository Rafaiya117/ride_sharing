import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BaseScaffold extends StatelessWidget {
  final dynamic title;
  final Widget child;
  final bool isCurved;
  final List<Widget>? actions;
  final Widget? leading;
  final TextAlign titleAlign;
  final Widget? headerBackground;
  final Widget? bottomNavigationBar; // Added this line

  const BaseScaffold({
    super.key,
    required this.title,
    required this.child,
    this.isCurved = false,
    this.actions,
    this.leading,
    this.headerBackground,
    this.titleAlign = TextAlign.left,
    this.bottomNavigationBar, // Added this line
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Pass the bottomNavigationBar to the internal Scaffold
      bottomNavigationBar: bottomNavigationBar, 
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: isCurved
                  ? BorderRadius.vertical(bottom: Radius.circular(25.r))
                  : BorderRadius.zero,
            ),
            child: Stack(
              children: [
                ?headerBackground,
                SafeArea(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ?leading,
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: leading != null ? 12.w : 0),
                              child: title is Widget 
                                ? title 
                                : Text( 
                                  title.toString(),
                                    textAlign: titleAlign,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            ),
                          ),
                          if (actions != null)
                            Row(children: actions!)
                          else if (titleAlign == TextAlign.center && leading != null)
                            SizedBox(width: 48.w), 
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              // Removed vertical padding here so content can reach bottom if needed
              padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h ),//vertical: 20.h
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}