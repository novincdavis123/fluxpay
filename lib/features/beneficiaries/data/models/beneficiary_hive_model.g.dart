// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beneficiary_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BeneficiaryHiveModelAdapter extends TypeAdapter<BeneficiaryHiveModel> {
  @override
  final int typeId = 4;

  @override
  BeneficiaryHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BeneficiaryHiveModel(
      id: fields[0] as String,
      nickname: fields[1] as String,
      bankName: fields[2] as String,
      country: fields[3] as String,
      currencyCode: fields[4] as String,
      accountNumber: fields[5] as String,
      createdAt: fields[6] as DateTime,
      isRecent: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BeneficiaryHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nickname)
      ..writeByte(2)
      ..write(obj.bankName)
      ..writeByte(3)
      ..write(obj.country)
      ..writeByte(4)
      ..write(obj.currencyCode)
      ..writeByte(5)
      ..write(obj.accountNumber)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.isRecent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeneficiaryHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
