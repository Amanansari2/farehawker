import 'package:flutter/material.dart';


class SocialIcon extends StatelessWidget {
  const SocialIcon({
    Key? key,
    required this.bgColor,
     this.iconColor,
      this.icon,
    this.child,
    this.onTap,
    required this.borderColor,
  }) : super(key: key);
  final IconData? icon;
  final Widget? child;
  final Color bgColor;
  final Color? iconColor;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: borderColor),
          color: bgColor,
        ),
        child:
        child ?? (icon != null ? Icon(icon, color: iconColor) : null),
        // Icon(
        //   icon,
        //   color: iconColor,
        // ),
      ),
    );
  }
}