import 'package:flutter/material.dart';

double scale(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return (width / 375).clamp(0.85, 1.3);
}

double r(double size, BuildContext context) {
  return size * scale(context);
}
