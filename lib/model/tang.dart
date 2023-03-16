import 'baseElement.dart';
import 'elementwithchildren.dart';
import 'phong.dart';

class LayerElement extends ElementWithChildren<BaseElement> {
  LayerElement({List<BaseElement>? children}) : super(children: children);

  factory LayerElement.fromJson(Map<String, dynamic> data) {
    final children = ((data['DuLieu'] ?? []) as List).map((child) {
      switch (child['type']) {
        case 'room':
          return RectElement.fromJson(child);
        default:
          throw Exception('Invalid layer child: $child');
      }
    }).toList();

    return LayerElement(children: children);
  }
}
