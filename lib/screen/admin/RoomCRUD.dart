import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomCRUD extends StatefulWidget {
  const RoomCRUD({Key? key}) : super(key: key);

  @override
  State<RoomCRUD> createState() => _RoomCRUDState();
}

class _RoomCRUDState extends State<RoomCRUD> {
  final data = FirebaseFirestore.instance;
  String? roomNameNew;
  int x = 0;
  int y = 0;
  int w = 0;
  int h = 0;

  createRoom() async {
    final data = FirebaseFirestore.instance.collection("Room").doc();

    Map<String, dynamic> location = {
      "roomName":roomNameNew,
      "type": "room",
      "x": x,
      "y": y,
      "w": w,
      "h": h,
    };

    data.set(location);
  }

  updateRoom(roomName ,roomNameNew) async {
    final documentReference = await data.collection("Room")
        .where("roomName", isEqualTo: roomName).get()
        .then((value) {
      return data.collection("Room").doc(value.docs.first.id);
    });

    Map<String, dynamic> location = {
      "roomName": roomNameNew,
    };

    documentReference.set(location, SetOptions(merge: true));
  }

  deleteLocation(location_id) async {
    final documentReference = await data
        .collection("Room")
        .where('roomName', isEqualTo: location_id)
        .get()
        .then((value) {
      return data.collection("Room").doc(value.docs.first.id);
    });

    documentReference.delete();
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
                    updateRoom(roomName,roomNameNew);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Update")
              )
            ],
          );
        });
  }

  void showDeleteDialog(String location_id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text("Xóa Phòng"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Text("Xác nhận xóa Phòng $location_id"),
            ]),
            actions: <Widget>[
              ElevatedButton(
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: Colors.redAccent,
                // ),
                  onPressed: () {
                    deleteLocation(location_id);
                    Navigator.of(context).pop();
                  },
                  child: Text("Xóa"))
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

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("Thêm phòng"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(

                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(hintText: "Nhập tên phòng: "),
                        onChanged: (String value) {
                          if (value != "") roomNameNew = value;
                        },
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                        InputDecoration(hintText: "Nhập tọa độ X: "),
                        onChanged: (String value) {
                          if (value != "") x = int.parse(value);
                        },
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                        InputDecoration(hintText: "Nhập tọa độ Y: "),
                        onChanged: (String value) {
                          if (value != "") y = int.parse(value);
                        },
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                        InputDecoration(hintText: "Nhập chiều rộng phòng w: "),
                        onChanged: (String value) {
                          if (value != "") w = int.parse(value);
                        },
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                        InputDecoration(hintText: "Nhập chiều dài phòng h: "),
                        onChanged: (String value) {
                          if (value != "") h = int.parse(value);
                        },
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          createRoom();
                          // Navigator.of(context).pop();
                        },
                        child: Text("Thêm"))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
          stream: data.collection("Room").orderBy('roomName').snapshots(),

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
                          onDismissed: (direction) {
                            showDeleteDialog(documentSnapshot["roomName"]);
                          },
                          key: Key(documentSnapshot["roomName"].toString()),
                          child: Card(
                            elevation: 4, margin: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: InkWell(
                              onTap: () {
                                showUpdateDialog(documentSnapshot["roomName"]);
                              },
                              child: ListTile(
                                title: Text(documentSnapshot["roomName"].toString()),
                                trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDeleteDialog(
                                          documentSnapshot["roomName"]);
                                    }),
                              ),
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