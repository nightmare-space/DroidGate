import 'package:json_annotation/json_annotation.dart';

part 'display.g.dart';

Display deserializeDisplay(Map<String, dynamic> json) => Display.fromJson(json);
Map<String, dynamic> serializeDisplay(Display object) => object.toJson();

@JsonSerializable()
class Display {
  Display({
    required this.name,
    required this.width,
    required this.height,
    required this.rotation,
    required this.id,
    required this.refreshRate,
    required this.densityDpi,
    required this.density,
    required this.uniqueId,
  });

  int id;
  String uniqueId;
  String name;
  int width;
  int height;
  int rotation;
  double? refreshRate;
  double densityDpi;
  double density;

  factory Display.fromJson(Map<String, dynamic> json) => _$DisplayFromJson(json);
  Map<String, dynamic> toJson() => _$DisplayToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

Displays deserializeDisplays(Map<String, dynamic> json) => Displays.fromJson(json);

@JsonSerializable()
class Displays {
  Displays({required this.datas});

  List<Display> datas;

  factory Displays.fromJson(Map<String, dynamic> json) => _$DisplaysFromJson(json);
  Map<String, dynamic> toJson() => _$DisplaysToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
