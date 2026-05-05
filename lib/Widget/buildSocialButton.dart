import 'package:flutter/material.dart';

Widget buildSocialButton(String url, double Function(double) r) {
  return Expanded(
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade300,
        minimumSize: Size(0, r(50)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r(12)),
        ),
      ),
      child: Image.asset(url, height: r(24)),
    ),
  );
}