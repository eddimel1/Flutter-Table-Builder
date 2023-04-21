import 'dart:math';
import 'package:my_first_app/Hive/TableHiveModel.dart';
import '../Models/table-model.dart';

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

class HiveStateMapper {
  TableModel model;
  HiveStateMapper({required this.model});
  List<ColumnState> toColumnModels(List<ColumnHiveModel> columns) {
    List<ColumnState> new_columns = [];
    for (var column in columns) {
      final new_column = ColumnState()..value = column.value;
      new_columns.add(new_column);
    }
    return new_columns;
  }

  List<List<CellState>> toRowModels(List<List<CellHiveModel>> rows) {
    List<List<CellState>> new_rows = [];
    for (var row in rows) {
      List<CellState> _row = [];
      for (var cell in row) {
        final new_cell = CellState()
          ..value = cell.value
          ..additionalCellProps = cell.additionalCellProps
          ..behavior = cell.behavior
          ..description = cell.description;
        _row.add(new_cell);
        row = [];
      }
      new_rows.add(_row);
    }

    return new_rows;
  }

  TableState toModel(TableHiveModel tableHiveModel) {
    TableState tableState = TableState()
      ..lastModify = tableHiveModel.lastModify
      ..tableId = tableHiveModel.tableId
      ..tableName = tableHiveModel.tableName
      ..initialRowsCount = tableHiveModel.initialColumnsCount
      ..initialColumnsCount = tableHiveModel.initialColumnsCount
      ..selected = tableHiveModel.selected
      ..additionalCellProps = List.from(tableHiveModel.additionalCellProps)
      ..tableStyles = Map.from(tableHiveModel.tableStyles)
      ..cols.addAll(toColumnModels(tableHiveModel.cols))
      ..rows.addAll(toRowModels(tableHiveModel.rows));
    return tableState;
  }

  
}
