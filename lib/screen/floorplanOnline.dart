import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/core/baseElement.dart';
import 'package:floorplans/model/building.dart';
import 'package:floorplans/model/floor.dart';
import 'package:floorplans/model/room.dart';
import 'package:flutter/material.dart';

import '../grid/gird_painter.dart';
import '../widget/drawer.dart';

class FloorplanOnline extends StatefulWidget {
  const FloorplanOnline({Key? key}) : super(key: key);

  @override
  State<FloorplanOnline> createState() => _FloorplanOnlineState();
}

class _FloorplanOnlineState extends State<FloorplanOnline> with SingleTickerProviderStateMixin {
  bool isNotComplete = true;
  late Building root;
  late TransformationController controllerTF;
  late AnimationController controller;
  List<int> mangTrung = [];
  List<num> radiusList = [];
  List<dynamic> roomsAndObj = [];

  late final dataRoomAndObj = [];
  final data = FirebaseFirestore.instance;

  Future<List<dynamic>> getRoomsAndObj() async {
    var snapshot = (await FirebaseFirestore.instance.collection('Room').get());
    var documents = [];

    snapshot.docs.forEach((element) {
      var document = element.data();
      documents.add(document);
    });

    return documents;
  }


  @override
  void initState() {
    controllerTF = TransformationController();
    super.initState();
  }


  Widget buildRoom(BuildContext context, Room element) {
    return  Positioned(
      top: element.y, left: element.x,
      child: InkWell(
        child: Ink(
          height: element.height, width: element.width,
          decoration: BoxDecoration(border: Border.all(color:Colors.black, width: 2,), color: Colors.white,),
          child: Center(child: Text("${element.roomName}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }


  Widget buildElement(BuildContext context, BaseElement element) {
    switch (element.runtimeType) {
      case Room:
        return buildRoom(context, element as Room);

      default:
        throw Exception('Invalid element type: ${element.runtimeType}');
    }
  }

  Widget buildLayer(BuildContext context, Floor layer, Rect size) {
    final elements = layer.children.map<Widget>((child) => buildElement(context, child)).toList();

    return SizedBox(
      height: size.bottom, width: size.right,
      child: Stack(children: elements,),
    );
  }


  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
        transformationController: controllerTF,
        maxScale: 300,
        constrained: false,
        child: Stack(children: [
          GestureDetector(
            onTapDown: (details) {
              print("x: " + details.localPosition.dx.ceil().toString());
              print("y: " + details.localPosition.dy.ceil().toString());
            },
            child: Stack(children: [
              RepaintBoundary(
                child: CustomPaint(
                  painter: GridPainter(),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: data.collection("Room").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading');
                      }

                      roomsAndObj =[];
                      snapshot.data?.docs.forEach((element) {
                        roomsAndObj.add(element.data());
                      });

                      final dynamic data = {
                        "ToaNha":"Công nghệ thông tin",
                        "DuLieu":[
                          {
                            "type":"layer",
                            "Tang":1,
                            "DuLieu": roomsAndObj
                          }
                        ]
                      };

                      root = Building.fromJson(data);
                      final size = Rect.fromLTRB(0.0, 0.0, 540.0, 720.0);
                      final layers = root.layers.map<Widget>((layer) => buildLayer(context, layer, size)).toList();

                      return Stack(children: layers,);
                    },
                  ),
                ),
              ),
            ]),
          ),

        ]));
  }


  void getDataFromFirebase() async {
    await getRoomsAndObj().then((value) => dataRoomAndObj.add(value));
  }
}


class CallFloorplan extends StatelessWidget {
  const CallFloorplan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text("Map Online"), centerTitle: true, backgroundColor: Colors.blueGrey),
          drawer: DrawerMenu(),
          body: const FloorplanOnline(),
        )
    );
  }
}