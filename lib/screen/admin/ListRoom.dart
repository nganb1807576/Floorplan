import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListRoom extends StatefulWidget {
  const ListRoom({Key? key}) : super(key: key);

  @override
  State<ListRoom> createState() => _ListRoomState();
}

class _ListRoomState extends State<ListRoom> {
  final data = FirebaseFirestore.instance;
  String? roomNameNew;

  updateLocation(roomName ,roomNameNew) async {
    final documentReference = await data.collection("Room")
        .where("name", isEqualTo: roomName).get()
        .then((value) {
      return data.collection("Room").doc(value.docs.first.id);
    });

    Map<String, dynamic> location = {
      "name": roomNameNew,
    };

    documentReference.set(location, SetOptions(merge: true));
  }


  void showUpdateDialog(String roomName) {
    roomNameNew = roomName;

    showDialog(
        context: context,
        builder: (BuildContext context) {

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text("Update Room"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: roomName.toString(),
                  decoration: const InputDecoration(hintText: "Name . . . "),
                  onChanged: (String value) {
                    if (value != "") roomNameNew = value;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    updateLocation(roomName,roomNameNew);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Update")
              )
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          title: const Text("Room Manager"),
          centerTitle: true,
          backgroundColor: Colors.blueGrey
      ),

      body: StreamBuilder<QuerySnapshot>(
          stream: data.collection("Room").orderBy('name').snapshots(),

          builder: (context, snapshots) {
            if (snapshots.hasData) {
              if (snapshots.data!.docs.isEmpty) {
                return const Center(child: Text('Null'));
              } else {

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot = snapshots.data!.docs[index];

                      return Dismissible(
                          key: Key(documentSnapshot["name"].toString()),
                          child: Card(
                            elevation: 4, margin: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: InkWell(
                                onTap: () {
                                  showUpdateDialog(documentSnapshot["name"]);
                                },
                                child: SizedBox(
                                    height: 50, width: MediaQuery.of(context).size.width,
                                    child: Row(
                                        children: [
                                          const SizedBox(width: 10),
                                          Text("${documentSnapshot["name"]}"),
                                        ]
                                    )
                                )
                            ),
                          )
                      );
                    });
              }
            } else {
              return const Align(
                alignment: FractionalOffset.bottomCenter,
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}