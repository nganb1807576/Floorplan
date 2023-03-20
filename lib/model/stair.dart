import 'package:flutter/material.dart';

import 'core/baseElement.dart';
import '../function/utils.dart';

class Stair implements BaseElement {
  final double x;
  final double y;
  final double width;
  final double height;


  Stair({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });


  @override
  Rect getExtent() => Rect.fromLTWH(x, y, width, height);


  factory Stair.fromJson(Map<String, dynamic> data) {
    return Stair(
      x: parseNumber(data['x']),
      y: parseNumber(data['y']),
      width: parseNumber(data['w']),
      height: parseNumber(data['h']),
    );
  }
}
