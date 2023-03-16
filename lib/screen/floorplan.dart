import 'dart:convert';
import 'package:flutter/material.dart';

import '../model/core/baseElement.dart';
import '../model/toanha.dart';
import '../model/tang.dart';
import '../model/phong.dart';

import 'package:floorplans/gird/gird_painter.dart';

class FloorPlan extends StatefulWidget {
  final String jsonFloorplan;
  const FloorPlan({required this.jsonFloorplan, Key? key}) : super(key: key);

  @override
  State<FloorPlan> createState() => _FloorPlanState();
}

class _FloorPlanState extends State<FloorPlan> with SingleTickerProviderStateMixin {
  late RootElement root;

  void load(String jsonString) {
    final data = json.decode(jsonString);
    root = RootElement.fromJson(data);
  }

  @override
  void initState() {
    load(widget.jsonFloorplan);
    super.initState();
  }


  Widget buildRectElement(BuildContext context, RectElement element) {
    return Positioned(
      top: element.y, left: element.x,
      child: Container(
        height: element.height, width: element.width,
        decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
        child: Center(child: Text("${element.roomName}")),
        // color: element.fill,
      ),
    );
  }


  Widget buildElement(BuildContext context, BaseElement element) {
    switch (element.runtimeType) {
      case RectElement:
        return buildRectElement(context, element as RectElement);
      default:
        throw Exception('Invalid element type: ${element.runtimeType}');
    }
  }


  Widget buildLayer(BuildContext context, LayerElement layer, Rect size) {
    final elements = layer.children
        .map<Widget>((child) => buildElement(context, child))
        .toList();

    return SizedBox(
      height: size.bottom,
      width: size.right,
      child: Stack(children: elements),
    );
  }


  @override
  Widget build(BuildContext context) {
    final size = root.getExtent();
    final layers = root.layers
        .map<Widget>((layer) => buildLayer(context, layer, size))
        .toList();

    return InteractiveViewer(
        transformationController: TransformationController(), maxScale: 300, constrained: false,
        child: GestureDetector(
          child: CustomPaint(
            // painter: GridPainter(),
            child: Stack(children: layers),
          ),
        ));
  }
}
