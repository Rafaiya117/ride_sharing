import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReusablePrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final String iconPath;
  final ButtonStyle? style; // Add this
  final TextStyle? textStyle; // Add this

  const ReusablePrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.iconPath = 'assets/icons/chevron_right.svg',
    this.backgroundColor = const Color(0xFF555555),
    this.textColor = Colors.white,
    this.style, // Initialize this
    this.textStyle, // Initialize this
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        // Use the passed style if available, otherwise use default
        style: style ?? ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              // Use the passed textStyle if available, otherwise use default
              style: textStyle ?? TextStyle(
                fontSize: 18,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(
                textStyle?.color ?? textColor, 
                BlendMode.srcIn
              ),
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}