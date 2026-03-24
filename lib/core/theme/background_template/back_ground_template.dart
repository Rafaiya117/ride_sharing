import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseScaffold extends StatelessWidget {
  final dynamic title; // Changed from String to dynamic to support Widgets
  final Widget child;
  final bool isCurved;
  final List<Widget>? actions;
  final Widget? leading;
  final TextAlign titleAlign; 
  final Widget? headerBackground; 

  const BaseScaffold({
    super.key,
    required this.title,
    required this.child,
    this.isCurved = false,
    this.actions,
    this.leading,
    this.headerBackground,
    this.titleAlign = TextAlign.left, 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: isCurved
                  ? BorderRadius.vertical(bottom: Radius.circular(25.r))
                  : BorderRadius.zero,
            ),
            child: Stack(
              children: [
                if (headerBackground != null) headerBackground!,
                SafeArea(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (leading != null) leading!,
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: leading != null ? 12.w : 0),
                              child: title is Widget 
                                ? title 
                                : Text( 
                                    title.toString(),
                                    textAlign: titleAlign,
                                    style: TextStyle(
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
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}