// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 1;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String,
      senderCurrency: fields[1] as String,
      receiverCurrency: fields[2] as String,
      senderAmount: fields[3] as double,
      receiverAmount: fields[4] as double,
      exchangeRate: fields[5] as double,
      fee: fields[6] as double,
      totalPayable: fields[7] as double,
      beneficiaryName: fields[8] as String,
      beneficiaryBank: fields[9] as String,
      createdAt: fields[10] as DateTime,
      status: fields[11] as TransactionStatus,
      maskedAccountNumber: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.senderCurrency)
      ..writeByte(2)
      ..write(obj.receiverCurrency)
      ..writeByte(3)
      ..write(obj.senderAmount)
      ..writeByte(4)
      ..write(obj.receiverAmount)
      ..writeByte(5)
      ..write(obj.exchangeRate)
      ..writeByte(6)
      ..write(obj.fee)
      ..writeByte(7)
      ..write(obj.totalPayable)
      ..writeByte(8)
      ..write(obj.beneficiaryName)
      ..writeByte(9)
      ..write(obj.beneficiaryBank)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.status)
      ..writeByte(12)
      ..write(obj.maskedAccountNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
