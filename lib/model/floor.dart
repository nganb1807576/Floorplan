import 'package:floorplans/model/stair.dart';

import 'core/baseElement.dart';
import 'core/elementwithchildren.dart';
import 'room.dart';

class Floor extends ElementWithChildren<BaseElement> {
  Floor({List<BaseElement>? children}) : super(children: children);

  factory Floor.fromJson(Map<String, dynamic> data) {
    final children = ((data['DuLieu'] ?? []) as List).map((child) {
      switch (child['type']) {
        case 'room':
          return Room.fromJson(child);
        case 'stair':
          return Stair.fromJson(child);
        default:
          throw Exception('Invalid layer child: $child');
      }
    }).toList();

    return Floor(children: children);
  }
}
