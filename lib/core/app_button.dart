import 'package:flutter/material.dart';

class AppButon extends StatelessWidget {
  const AppButon({
    super.key,
    this.onPressed,
    required this.label,
    this.labelColor,
    this.fontSize,
    this.fontWeight,
    this.buttonColor,
    this.elevation,
    this.isLoading = false,
    this.borderRadius,
    this.padding,
    this.borderSide,
    this.width,
  });

  final VoidCallback? onPressed;
  final String label;
  final Color? labelColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? buttonColor;
  final double? elevation;
  final double? borderRadius;
  final bool isLoading;
  final double? padding;
  final BorderSide? borderSide;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        minimumSize:
            width != null ? WidgetStatePropertyAll(Size(width!, 36)) : null,
        backgroundColor: onPressed == null
            ? WidgetStatePropertyAll(Theme.of(context).disabledColor)
            : WidgetStatePropertyAll(buttonColor),
        elevation: WidgetStatePropertyAll(elevation),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: borderSide ?? BorderSide.none,
            borderRadius: BorderRadius.circular(
              borderRadius ?? 0,
            ),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding ?? 12),
        child: isLoading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator.adaptive(),
              )
            : FittedBox(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize ?? 16,
                    fontWeight: fontWeight ?? FontWeight.normal,
                    color: labelColor ?? Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
