import 'package:floorplans/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final List<String> listname = [
  "Map",
];
final List<IconData> listicon = [
  Icons.map,
];

final List<Widget> listclass = [
  MyApp(),
];

class Listnav extends StatelessWidget {
  final String namenav;
  final IconData iconnav;
  final Widget widgetnav;
  Listnav(
      {required this.namenav, required this.iconnav, required this.widgetnav});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconnav, size: 20, color: Colors.black),
      title: Text(namenav, style: TextStyle(color: Colors.black, fontSize: 12)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widgetnav),
        );
      },
    );
  }
}

class drawermenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Luận Văn',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              )),
            ),
          ),
          for (int i = 0; i < listname.length; i++)
            Listnav(
                namenav: listname[i],
                iconnav: listicon[i],
                widgetnav: listclass[i]),
        ],
      ),
    );
  }
}
