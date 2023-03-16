import 'floor.dart';
import 'core/elementwithchildren.dart';

class Building extends ElementWithChildren<Floor> {
  final String locationId;
  get layers => children;

  Building({
    List<Floor>? children,
    required this.locationId,
  }) : super(children: children);


  factory Building.fromJson(Map<String, dynamic> data) {
    final children = ((data['DuLieu'] ?? []) as List).map((child) {
      switch (child['type']) {
        case 'layer':
          return Floor.fromJson(child);
        default:
          throw Exception('Invalid root element child: $child');
      }
    }).toList();

    return Building(
      children: children,
      locationId: data['ToaNha'],
    );
  }
}
