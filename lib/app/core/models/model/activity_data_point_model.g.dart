// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_data_point_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityDataPointAdapter extends TypeAdapter<ActivityDataPoint> {
  @override
  final int typeId = 1;

  @override
  ActivityDataPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityDataPoint(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      step: fields[2] as int,
      distance: fields[3] as double,
      pace: fields[4] as double,
      time: fields[5] as int,
      timestamp: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityDataPoint obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.step)
      ..writeByte(3)
      ..write(obj.distance)
      ..writeByte(4)
      ..write(obj.pace)
      ..writeByte(5)
      ..write(obj.time)
      ..writeByte(6)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityDataPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
