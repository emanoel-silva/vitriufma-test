import 'package:flutter/material.dart';

class AppColors {
  AppColors._privateConstructor();

  static final AppColors _instance = AppColors._privateConstructor();

  factory AppColors() {
    return _instance;
  }

  static const cutGrey = Color(0xFF8C8C8C);
  static const blue = Color(0xff03A9F4);
  static const blueLink = Color.fromARGB(255, 29, 93, 255);
  static const yellow = Color(0xffFDD400);
  static const green = Color(0xff1EC602);
  static const backgroundGrey = Color(0xFFF3F4F9);
  static const mediumGrey = Color(0xFF6B6D72);
  static const lightGrey = Color(0xFFBABFC7);
  static const white = Color(0xFFfefefe);
  static const black = Color(0xFF2e2e2e);
  static const normalRed = Color(0xFFFE2D2D);
  static const lightRed = Color(0xFFFE2D2D);
  static const neonGreen = Color(0xFF00E89D);
  static const orange = Color(0xFFF58220);
  static const wine = Color.fromARGB(255, 118, 28, 28);
}
