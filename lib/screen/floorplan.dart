import 'dart:convert';
import 'package:flutter/material.dart';

import '../model/core/baseElement.dart';
import '../model/building.dart';
import '../model/floor.dart';
import '../model/room.dart';

import 'package:floorplans/grid/gird_painter.dart';

import '../model/stair.dart';

class FloorPlan extends StatefulWidget {
  final String jsonFloorplan;
  const FloorPlan({required this.jsonFloorplan, Key? key}) : super(key: key);

  @override
  State<FloorPlan> createState() => _FloorPlanState();
}

class _FloorPlanState extends State<FloorPlan>
    with SingleTickerProviderStateMixin {
  late Building root;

  void load(String jsonString) {
    final data = json.decode(jsonString);
    root = Building.fromJson(data);
    print("building ...");
  }

  @override
  void initState() {
    load(widget.jsonFloorplan);
    super.initState();
  }

  String click = "";

  Widget buildRoom(BuildContext context, Room element) {
    return Positioned(
      top: element.y,
      left: element.x,
      child: GestureDetector(
        onTap: () {
          setState(() {
            click = element.roomName!;
          });
        },
        child: Container(
          height: element.height,
          width: element.width,
          decoration: BoxDecoration(
              color: click == element.roomName
                  ? Colors.orange.shade50
                  : Colors.grey.shade100,
              border: Border.all(color: Colors.black, width: 2)),
          child: Center(
              child: Text("${element.roomName}",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }


  Widget buildStair(BuildContext context, Stair element) {
    return Positioned(
      top: element.y,
      left: element.x,
      child: Container(
        height: element.height,
        width: element.width,
        child: SizedBox(
          // width: MediaQuery.of(context).size.width * 0.5,
          child: Image.asset('assets/images/stair.jpg'),
        ),
      ),
    );
  }


  Widget buildElement(BuildContext context, BaseElement element) {
    switch (element.runtimeType) {
      case Room:
        return buildRoom(context, element as Room);
      case Stair:
        return buildStair(context, element as Stair);
      default:
        throw Exception('Invalid element type: ${element.runtimeType}');
    }
  }


  Widget buildFloor(BuildContext context, Floor layer, Rect size) {
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
        .map<Widget>((layer) => buildFloor(context, layer, size))
        .toList();

    return InteractiveViewer(
        transformationController: TransformationController(),
        maxScale: 300,
        constrained: false,
        child: GestureDetector(
          child: CustomPaint(
            painter: GridPainter(),
            child: Stack(children: layers),
          ),
        ));
  }
}
