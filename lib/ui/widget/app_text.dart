import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    this.color,
    this.size,
    this.weight,
    this.align,
    this.maxLines,
    this.decoration,
    Key? key,
  }) : super(key: key);

  final String data;
  final Color? color;
  final double? size;
  final FontWeight? weight;
  final TextAlign? align;
  final int? maxLines;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: align,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
        decoration: decoration,
        decorationThickness: 1.5,
      ),
    );
  }
}
