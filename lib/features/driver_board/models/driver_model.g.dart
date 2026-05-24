// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DriverAdapter extends TypeAdapter<Driver> {
  @override
  final int typeId = 1;

  @override
  Driver read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Driver(
      id: fields[0] as String,
      name: fields[1] as String,
      status: fields[2] as DriverStatus,
      lastUpdated: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Driver obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DriverStatusAdapter extends TypeAdapter<DriverStatus> {
  @override
  final int typeId = 0;

  @override
  DriverStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DriverStatus.idle;
      case 1:
        return DriverStatus.waitingForLoad;
      case 2:
        return DriverStatus.onRoute;
      default:
        return DriverStatus.idle;
    }
  }

  @override
  void write(BinaryWriter writer, DriverStatus obj) {
    switch (obj) {
      case DriverStatus.idle:
        writer.writeByte(0);
        break;
      case DriverStatus.waitingForLoad:
        writer.writeByte(1);
        break;
      case DriverStatus.onRoute:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
