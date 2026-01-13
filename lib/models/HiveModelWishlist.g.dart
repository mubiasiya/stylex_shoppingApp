// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HiveModelWishlist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishlistItemHiveAdapter extends TypeAdapter<WishlistItemHive> {
  @override
  final int typeId = 2;

  @override
  WishlistItemHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistItemHive(
      productId: fields[0] as String,
      title: fields[1] as String,
      image: fields[2] as String,
      originalPrice: fields[3] as int,
      offerPrice: fields[4] as int,
      addedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WishlistItemHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.originalPrice)
      ..writeByte(4)
      ..write(obj.offerPrice)
      ..writeByte(5)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistItemHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
