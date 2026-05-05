import 'package:flutter/material.dart';

Widget buildField(
    double Function(double) r, {
      required String hint,
      required IconData prefixIcon, required TextEditingController controller, TextInputType keyboardType = TextInputType.text,
    }) {
  return TextField(

    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      fillColor: const Color(0xffF0F1F6),
      filled: true,
      prefixIcon: Icon(prefixIcon, size: r(20)),
      hintText: hint,
      hintStyle: TextStyle(fontSize: r(13)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(r(12)),
        borderSide: BorderSide.none,
      ),
    ),
  );
}