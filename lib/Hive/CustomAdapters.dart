import 'dart:ui';
import 'package:hive/hive.dart';
import '../Models/table-model.dart';

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final typeId = 221;

  @override
  Color read(BinaryReader reader) => Color(reader.readUint32());

  @override
  void write(BinaryWriter writer, Color obj) => writer.writeUint32(obj.value);
}

class CellBehaviorAdapter extends TypeAdapter<CellBehavior> {
  @override
  CellBehavior read(BinaryReader reader) {
    int index = reader.readByte();
    return CellBehavior.values[index];
  }

  @override
  void write(BinaryWriter writer, CellBehavior obj) {
    writer.writeByte(obj.index);
  }

  @override
  int get typeId => 222;
}
