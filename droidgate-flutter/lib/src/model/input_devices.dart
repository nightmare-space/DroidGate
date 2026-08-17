import 'package:json_annotation/json_annotation.dart';
part 'input_devices.g.dart';

@JsonSerializable()
class InputDevices {
  InputDevices({required this.devices});
  List<InputDevice> devices;
  factory InputDevices.fromJson(Map<String, dynamic> json) => _$InputDevicesFromJson(json);
  Map<String, dynamic> toJson() => _$InputDevicesToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class InputDevice {
  InputDevice({
    required this.deviceBus,
    required this.controllerNumber,
    required this.generation,
    required this.associatedDisplayId,
    required this.name,
    required this.id,
    required this.vendorId,
    required this.productId,
    required this.sources,
    required this.keyboardType,
    required this.isVirtual,
    required this.descriptor,
    this.detailedBus,
    this.detailedVendor,
    this.detailedProduct,
    this.detailedVersion,
    this.detailedLocation,
    this.detailedId,
    this.detailedFwVersion,
    this.detailedPath,
  });
  @JsonKey(name: 'device_bus')
  int deviceBus;

  @JsonKey(name: 'detailed_bus')
  String? detailedBus;
  @JsonKey(name: 'detailed_vendor')
  String? detailedVendor;
  @JsonKey(name: 'detailed_product')
  String? detailedProduct;
  @JsonKey(name: 'detailed_version')
  String? detailedVersion;
  @JsonKey(name: 'detailed_location')
  String? detailedLocation;
  @JsonKey(name: 'detailed_id')
  String? detailedId;
  @JsonKey(name: 'detailed_fw_version')
  String? detailedFwVersion;
  // detailed_path
  @JsonKey(name: 'detailed_path')
  String? detailedPath;

  int controllerNumber;
  int generation;
  int associatedDisplayId;
  String name;
  int id;
  int vendorId;
  int productId;
  int sources;
  int keyboardType;
  bool isVirtual;
  String descriptor;
  factory InputDevice.fromJson(Map<String, dynamic> json) => _$InputDeviceFromJson(json);
  Map<String, dynamic> toJson() => _$InputDeviceToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}
