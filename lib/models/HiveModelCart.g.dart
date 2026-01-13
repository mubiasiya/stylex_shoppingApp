// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HiveModelCart.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemHiveAdapter extends TypeAdapter<CartItemHive> {
  @override
  final int typeId = 1;

  @override
  CartItemHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemHive(
      productId: fields[0] as String,
      title: fields[1] as String,
      image: fields[2] as String,
      price: fields[3] as int,
      qty: fields[4] as int,
      selected: fields[5] as bool,
      synced: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.qty)
      ..writeByte(5)
      ..write(obj.selected)
      ..writeByte(6)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
