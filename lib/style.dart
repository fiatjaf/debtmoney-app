import 'package:flutter/material.dart';
import 'package:color/color.dart' as ColorLib;

Color hashcolor (String input) {
  var sum = 0;
  for (var i = 0; i < input.codeUnits.length; i++) {
    sum += input.codeUnitAt(i);
  }
  sum = sum * sum;

  var rgb = new ColorLib.HslColor(sum % 360, 30, 59).toRgbColor();
  return new Color.fromRGBO(
    rgb.r,
    rgb.g,
    rgb.b,
    1.0,
  );
}
