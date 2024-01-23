// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SOFUserDtoAdapter extends TypeAdapter<SOFUserDto> {
  @override
  final int typeId = 0;

  @override
  SOFUserDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SOFUserDto(
      id: fields[0] as int,
      name: fields[1] as String,
      avatar: fields[2] as Uri,
      location: fields[3] as String,
      reputation: fields[5] as int,
      age: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SOFUserDto obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.avatar)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.age)
      ..writeByte(5)
      ..write(obj.reputation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SOFUserDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
