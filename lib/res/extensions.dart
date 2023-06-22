import 'package:flutter/material.dart';

// extension ScreenSize on BuildContext {
//   double get screenHeight => MediaQuery.of(this).size.height;
//   double get screenWidth => MediaQuery.of(this).size.width;
// }

extension ResponsiveExtension on BuildContext {
  bool get isPortrait {
    return MediaQuery.of(this).orientation == Orientation.portrait;
  }

  bool get isLandscape {
    return MediaQuery.of(this).orientation == Orientation.landscape;
  }

  double get screenWidth {
    final screenSize = MediaQuery.of(this).size;
    return isPortrait ? screenSize.width : screenSize.height;
  }

  double get screenHeight {
    final screenSize = MediaQuery.of(this).size;
    return isPortrait ? screenSize.height : screenSize.width;
  }

  double get blockSizeHorizontal => screenWidth / 100;

  double get blockSizeVertical => screenHeight / 100;

  double get fontScaleFactor => MediaQuery.of(this).textScaleFactor;

  double get textScaleFactorResponsive {
    final double scaleFactor = fontScaleFactor;
    if (screenWidth >= 1024) {
      return scaleFactor * 1.5;
    } else if (screenWidth >= 768) {
      return scaleFactor * 1.25;
    } else if (screenWidth >= 375) {
      return scaleFactor;
    } else if (screenWidth >= 360) {
      return scaleFactor * 0.95;
    } else {
      return scaleFactor * 0.9;
    }
  }

  bool get isLargeScreen => screenWidth > 960;
}
