// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TableHiveModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TableHiveModelAdapter extends TypeAdapter<TableHiveModel> {
  @override
  final int typeId = 1;

  @override
  TableHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TableHiveModel(
      tableName: fields[0] as String,
      tableId: fields[8] as String,
      lastModify: fields[9] as String?,
    )
      ..initialRowsCount = fields[1] as int
      ..initialColumnsCount = fields[2] as int
      ..selected = fields[3] as String
      ..additionalCellProps = (fields[4] as List).cast<String>()
      ..tableStyles = (fields[5] as Map).cast<String, dynamic>()
      ..cols = (fields[6] as List).cast<ColumnHiveModel>()
      ..rows = (fields[7] as List)
          .map((dynamic e) => (e as List).cast<CellHiveModel>())
          .toList();
  }

  @override
  void write(BinaryWriter writer, TableHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.tableName)
      ..writeByte(1)
      ..write(obj.initialRowsCount)
      ..writeByte(2)
      ..write(obj.initialColumnsCount)
      ..writeByte(3)
      ..write(obj.selected)
      ..writeByte(4)
      ..write(obj.additionalCellProps)
      ..writeByte(5)
      ..write(obj.tableStyles)
      ..writeByte(6)
      ..write(obj.cols)
      ..writeByte(7)
      ..write(obj.rows)
      ..writeByte(8)
      ..write(obj.tableId)
      ..writeByte(9)
      ..write(obj.lastModify);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CellHiveModelAdapter extends TypeAdapter<CellHiveModel> {
  @override
  final int typeId = 2;

  @override
  CellHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CellHiveModel()
      ..value = fields[0] as String
      ..description = fields[1] as String
      ..behavior = fields[2] as CellBehavior
      ..additionalCellProps = (fields[3] as Map).cast<String, String>();
  }

  @override
  void write(BinaryWriter writer, CellHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.behavior)
      ..writeByte(3)
      ..write(obj.additionalCellProps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CellHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ColumnHiveModelAdapter extends TypeAdapter<ColumnHiveModel> {
  @override
  final int typeId = 3;

  @override
  ColumnHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColumnHiveModel()..value = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, ColumnHiveModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BoxIdsHiveModelAdapter extends TypeAdapter<BoxIdsHiveModel> {
  @override
  final int typeId = 4;

  @override
  BoxIdsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoxIdsHiveModel()..tableIds = (fields[0] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, BoxIdsHiveModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.tableIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoxIdsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
