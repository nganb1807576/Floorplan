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

class ListNav extends StatelessWidget {
  final String namenav;
  final IconData iconnav;
  final Widget widgetnav;

  const ListNav({required this.namenav, required this.iconnav, required this.widgetnav});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconnav, size: 20, color: Colors.black),
      title: Text(namenav, style: const TextStyle(color: Colors.black, fontSize: 12)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => widgetnav));
      },
    );
  }
}

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 6),

          for (int i = 0; i < listname.length; i++)
            ListNav(namenav: listname[i], iconnav: listicon[i], widgetnav: listclass[i]),
        ],
      ),
    );
  }
}
