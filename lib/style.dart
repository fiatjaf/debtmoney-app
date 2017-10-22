import 'package:flutter/material.dart';

class TextStyles {
  const TextStyles();

  static const TextStyle appBarTitle = const TextStyle(
    color: Colours.appBarTitle,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 36.0
  );

  static const TextStyle peerTitle = const TextStyle(
    color: Colours.peerTitle,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 24.0
  );

  static const TextStyle peerLocation = const TextStyle(
    color: Colours.peerLocation,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
    fontSize: 14.0
  );

  static const TextStyle peerDistance = const TextStyle(
    color: Colours.peerDistance,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
    fontSize: 12.0
  );
}

class Colours {
  const Colours();

  static const Color appBarTitle = const Color(0xFFFFFFFF);
  static const Color appBarIconColor = const Color(0xFFFFFFFF);
  static const Color appBarDetailBackground = const Color(0x00FFFFFF);
  static const Color appBarGradientStart = const Color(0xFF3383FC);
  static const Color appBarGradientEnd = const Color(0xFF00C6FF);

  //static const Color peerCard = const Color(0xFF434273);
  static const Color peerCard = const Color(0xFF8685E5);
  //static const Color peerListBackground = const Color(0xFF3E3963);
  static const Color peerPageBackground = const Color(0xFF736AB7);
  static const Color peerTitle = const Color(0xFFFFFFFF);
  static const Color peerLocation = const Color(0x66FFFFFF);
  static const Color peerDistance = const Color(0x66FFFFFF);
}
