import 'package:flutter/material.dart';
import 'package:color/color.dart' as ColorLib;

const TextStyle appBarTitle = const TextStyle(
  color: Colors.white,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w600,
  fontSize: 36.0
);

const TextStyle peerTitle = const TextStyle(
  color: Colors.white,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w600,
  fontSize: 24.0
);

const TextStyle peerLocation = const TextStyle(
  color: const Color(0x66FFFFFF),
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w300,
  fontSize: 14.0
);

const TextStyle peerDetail = const TextStyle(
  color: const Color(0x66FFFFFF),
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w300,
  fontSize: 12.0
);

const TextStyle peerPage = const TextStyle(
  color: const Color(0xFF736AB7),
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w300,
  fontSize: 12.0,
);

Color appBarIconColorColor = Colors.white;
Color appBarDetailBackgroundColor = Colors.white;

Color peerCardColor = const Color(0xFF8685E5);
Color peerDetailColor = Colors.white;
Color peerListBackgroundColor = const Color(0xFF3E3963);
Color peerPageBackgroundColor = const Color(0xFF736AB7);


Hashcolor (String input) {
  var sum = 0;
  for (var i = 0; i < input.codeUnits.length; i++) {
    sum += input.codeUnitAt(i);
  }
  sum = sum * sum;

  var rgb = new ColorLib.HslColor(sum % 360, 30, 50).toRgbColor();
  return new Color.fromRGBO(
    rgb.r,
    rgb.g,
    rgb.b,
    1.0,
  );
}
