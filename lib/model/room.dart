import 'package:flutter/material.dart';

import 'core/baseElement.dart';
import '../function/utils.dart';

class Room implements BaseElement {
  final String? roomName;
  final double x;
  final double y;
  final double width;
  final double height;


  Room({
    this.roomName,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });


  @override
  Rect getExtent() => Rect.fromLTWH(x, y, width, height);


  factory Room.fromJson(Map<String, dynamic> data) {
    return Room(
      x: parseNumber(data['x']),
      y: parseNumber(data['y']),
      width: parseNumber(data['w']),
      height: parseNumber(data['h']),
      roomName: data['roomName'],
    );
  }
}
