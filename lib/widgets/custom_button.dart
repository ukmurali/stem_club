import 'package:flutter/material.dart';
import 'package:stem_club/colors/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool isWeb;
  final bool isIcon;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.isWeb = false,
    this.isIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        padding: isWeb
            ? const EdgeInsets.symmetric(horizontal: 60, vertical: 20)
            : const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        textStyle: TextStyle(
          fontSize: isWeb ? 18 : 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 12,
      ),
      child: isIcon
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center content
              children: [
                Text(buttonText), // Text in the center
                const SizedBox(width: 8), // Space between text and icon
                const CircleAvatar(
                  radius: 15.0, // Adjust the radius for the size of the circle
                  backgroundColor: Colors.white, // Background color
                  child: Icon(
                    Icons.arrow_forward, // Arrow icon
                    size: 16.0, // Adjust size of the arrow
                    color: AppColors.primaryColor, // Color of the arrow
                  ),
                ), // Right arrow icon
              ],
            )
          : Text(buttonText),
    );
  }
}
