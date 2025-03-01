
import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }

  // Get the proportionate height as per screen size
  static double getProportionateScreenHeight(double inputHeight) {
    // 812 is the layout height that designer use
    return (inputHeight / 812.0) * screenHeight;
  }

  // Get the proportionate width as per screen size
  static double getProportionateScreenWidth(double inputWidth) {
    // 375 is the layout width that designer use
    return (inputWidth / 375.0) * screenWidth;
  }

  // For padding and margin
  static double get smallPadding => getProportionateScreenWidth(8);
  static double get defaultPadding => getProportionateScreenWidth(16);
  static double get mediumPadding => getProportionateScreenWidth(24);
  static double get largePadding => getProportionateScreenWidth(32);
  
  // For font sizes
  static double get bodySmall => getProportionateScreenWidth(12);
  static double get bodyMedium => getProportionateScreenWidth(14);
  static double get bodyLarge => getProportionateScreenWidth(16);
  static double get titleSmall => getProportionateScreenWidth(18);
  static double get titleMedium => getProportionateScreenWidth(20);
  static double get titleLarge => getProportionateScreenWidth(24);
  static double get headlineSmall => getProportionateScreenWidth(28);
  static double get headlineMedium => getProportionateScreenWidth(32);
  static double get headlineLarge => getProportionateScreenWidth(36);
}
import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
    
    // Calculate defaultSize based on screen width for responsive design
    defaultSize = screenWidth! * 0.024;
  }
}
