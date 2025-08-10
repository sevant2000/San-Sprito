import 'package:flutter/material.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final IconData? icon;
  final double elevation;
  final bool? isLoading;

  const CommonButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 8.0,
    this.textStyle,
    this.isLoading = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    this.icon,
    this.elevation = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? CommonColor.logoBGColor,
          foregroundColor: foregroundColor ?? Colors.white,
          elevation: elevation,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle:
              textStyle ??
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onPressed: onPressed,
        child:
            icon == null
                ? Text(text)
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isLoading ?? false
                        ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Icon(icon, size: 18),
                    const SizedBox(width: 8),
                    Text(text),
                  ],
                ),
      ),
    );
  }
}
