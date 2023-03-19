import 'package:floorplans/main.dart';
import 'package:floorplans/screen/admin/RoomCRUD.dart';
import 'package:flutter/material.dart';

final List<String> listname = [
  "Floorplan",
  "RoomCURD",
];


final List<IconData> listicon = [
  Icons.map,
  Icons.meeting_room,
];


final List<Widget> listclass = [
  MyApp(),
  RoomCRUD(),
];


class ListNav extends StatelessWidget {
  final String namenav;
  final IconData iconnav;
  final Widget widgetnav;
  const ListNav({required this.namenav, required this.iconnav, required this.widgetnav});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: ListTile(
        leading: Icon(iconnav, size: 20, color: Colors.black),
        title: Text(namenav, style: const TextStyle(color: Colors.black, fontSize: 12)),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => widgetnav));
        },
      ),
    );
  }
}


class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
        backgroundColor: Colors.blueGrey.shade50,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height / 3,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.grey, width: 1,))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Image.asset('assets/images/logo.jpg'),
                    ),
                  ],
                ),
              ),
            ),
            for (int i = 0; i < listname.length; i++)
              ListNav(namenav: listname[i], iconnav: listicon[i], widgetnav: listclass[i]),
          ],
        ),
      ),
    );
  }
}
