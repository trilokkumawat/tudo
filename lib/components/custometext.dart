import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomeText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool uppercase;
  final bool lowercase;

  const CustomeText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w300,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.uppercase = false,
    this.lowercase = false,
  });

  @override
  Widget build(BuildContext context) {
    String displayText = text;
    if (uppercase) {
      displayText = displayText.toUpperCase();
    } else if (lowercase) {
      displayText = displayText.toLowerCase();
    }
    return Text(
      displayText,
      style: GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Colors.black,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
