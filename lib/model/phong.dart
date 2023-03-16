import 'package:flutter/material.dart';

import 'core/baseElement.dart';
import '../function/utils.dart';

class RectElement implements BaseElement {
  final String? roomName;
  final double x;
  final double y;
  final double width;
  final double height;


  RectElement({
    this.roomName,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });


  @override
  Rect getExtent() => Rect.fromLTWH(x, y, width, height);


  factory RectElement.fromJson(Map<String, dynamic> data) {
    return RectElement(
      x: parseNumber(data['x']),
      y: parseNumber(data['y']),
      width: parseNumber(data['w']),
      height: parseNumber(data['h']),
      roomName: data['roomName'],
    );
  }
}
