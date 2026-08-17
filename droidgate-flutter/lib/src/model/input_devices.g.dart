// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_devices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputDevices _$InputDevicesFromJson(Map<String, dynamic> json) => InputDevices(
  devices: (json['devices'] as List<dynamic>)
      .map((e) => InputDevice.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$InputDevicesToJson(InputDevices instance) =>
    <String, dynamic>{'devices': instance.devices};

InputDevice _$InputDeviceFromJson(Map<String, dynamic> json) => InputDevice(
  deviceBus: (json['device_bus'] as num).toInt(),
  controllerNumber: (json['controllerNumber'] as num).toInt(),
  generation: (json['generation'] as num).toInt(),
  associatedDisplayId: (json['associatedDisplayId'] as num).toInt(),
  name: json['name'] as String,
  id: (json['id'] as num).toInt(),
  vendorId: (json['vendorId'] as num).toInt(),
  productId: (json['productId'] as num).toInt(),
  sources: (json['sources'] as num).toInt(),
  keyboardType: (json['keyboardType'] as num).toInt(),
  isVirtual: json['isVirtual'] as bool,
  descriptor: json['descriptor'] as String,
  detailedBus: json['detailed_bus'] as String?,
  detailedVendor: json['detailed_vendor'] as String?,
  detailedProduct: json['detailed_product'] as String?,
  detailedVersion: json['detailed_version'] as String?,
  detailedLocation: json['detailed_location'] as String?,
  detailedId: json['detailed_id'] as String?,
  detailedFwVersion: json['detailed_fw_version'] as String?,
  detailedPath: json['detailed_path'] as String?,
);

Map<String, dynamic> _$InputDeviceToJson(InputDevice instance) =>
    <String, dynamic>{
      'device_bus': instance.deviceBus,
      'detailed_bus': instance.detailedBus,
      'detailed_vendor': instance.detailedVendor,
      'detailed_product': instance.detailedProduct,
      'detailed_version': instance.detailedVersion,
      'detailed_location': instance.detailedLocation,
      'detailed_id': instance.detailedId,
      'detailed_fw_version': instance.detailedFwVersion,
      'detailed_path': instance.detailedPath,
      'controllerNumber': instance.controllerNumber,
      'generation': instance.generation,
      'associatedDisplayId': instance.associatedDisplayId,
      'name': instance.name,
      'id': instance.id,
      'vendorId': instance.vendorId,
      'productId': instance.productId,
      'sources': instance.sources,
      'keyboardType': instance.keyboardType,
      'isVirtual': instance.isVirtual,
      'descriptor': instance.descriptor,
    };
