import 'package:flutter/material.dart';
import 'package:prodigenius_application/widgets/constant.dart';

Widget customText(String text, double size) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: size, color: kdark),
  );
}
