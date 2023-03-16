import 'dart:convert';
import 'package:floorplans/widget/drawer.dart';
import 'package:floorplans/screen/floorplan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String?> _future;

  @override
  void initState() {
    _future = rootBundle.loadString('assets/floorplan.json');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
      Scaffold(
        appBar: AppBar(
          title: Text("So Do"),
          backgroundColor: Colors.green,
        ),
        body: FutureBuilder<String?>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MyHomePage(json: snapshot.data!);
            }
            return const SizedBox.shrink();
          },
        ),

        drawer: drawermenu(),
      ),

    );
  }
}

class MyHomePage extends StatefulWidget {
  final String json;

  const MyHomePage({required this.json, Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Expanded(
              child: Floorplan(jsonFloorplan: widget.json),
            ),
          ],
        );
  }
}
