// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SOFPageDtoAdapter extends TypeAdapter<SOFPageDto> {
  @override
  final int typeId = 1;

  @override
  SOFPageDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SOFPageDto(
      page: fields[0] as int,
      users: (fields[1] as List).cast<SOFUserDto>(),
      lastUpdateTimeMs: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SOFPageDto obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.users)
      ..writeByte(2)
      ..write(obj.lastUpdateTimeMs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SOFPageDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
