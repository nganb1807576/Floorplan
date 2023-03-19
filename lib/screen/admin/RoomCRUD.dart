import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomCRUD extends StatefulWidget {
  const RoomCRUD({Key? key}) : super(key: key);

  @override
  State<RoomCRUD> createState() => _RoomCRUDState();
}

class _RoomCRUDState extends State<RoomCRUD> {
  final data = FirebaseFirestore.instance;

  @override
  void initState(){
    getData();
    super.initState();
  }

  getData() async {
    // QUERY FROM FIREBASE
    QuerySnapshot query = await data.collection("Room").get();
    // CONVERT MAP TO LIST
    final allData = query.docs.map((e) => e.data()).toList();
    // print(allData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("CRUD ROOM"),
          backgroundColor: Colors.blueGrey,
          centerTitle: true
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: data.collection("Room").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }
          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data1 = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data1['name']),
              );
            }).toList().cast(),
          );
        },
      )
    );
  }
}
