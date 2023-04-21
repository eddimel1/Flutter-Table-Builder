import 'package:flutter/material.dart';
import 'package:my_first_app/Hive/TableHiveModel.dart';





class TableState {
  String? tableId;
  String? tableName;
  String? lastModify;
  var initialRowsCount = 0;
  var initialColumnsCount = 0;
  late String selected = '';
  List<String> additionalCellProps = [];
  bool additionalPropsAreAdded = false;
  var tableStyles = tableStylesInitial;
  List<ColumnState> cols = [];
  List<List<CellState>> rows = [];
}

enum CellBehavior { editing, choosingOptions, still }

class CellState {
  var value = '';
  var description = '';
  var behavior = CellBehavior.still;
  Map<String, String> additionalCellProps = {};
}

Map<String, dynamic> tableStylesInitial = {
  'rowsColor': Color.fromARGB(255, 235, 71, 21),
  'rowsTextColor': Color.fromARGB(255, 0, 0, 0),
  'rowsBorderColor': Color.fromARGB(255, 0, 0, 0)
};

class ColumnState {
  var value = '';
}

class TableModel extends ChangeNotifier {
  TableState tableState = TableState();

  void addRow() {
    final List<CellState> row = [];
    for (var i = 0; i < tableState.cols.length; i++) {
      final cell = CellState();
      row.add(cell);
    }
    tableState.rows.add(row);
    notifyListeners();
  }

  void addCol() {
    if (tableState.cols.length < 10) {
      final column = ColumnState();
      tableState.cols.add(column);
      for (var j = 0; j < tableState.rows.length; j++) {
        List<CellState> row = tableState.rows[j];
        for (var z = 0; z < tableState.cols.length; z++) {
          if (z == 0) {
            final cell = CellState();
            row.add(cell);
            tableState.rows.add(row);
            row = [];
          }
        }
        removeRow();
      }
      notifyListeners();
    }
  }

  void removeCol() {
    if (tableState.cols.length > 1) {
      tableState.cols.removeLast();
      for (var j = 0; j < tableState.rows.length; j++) {
        for (var z = 0; z < tableState.cols.length; z++) {
          if (z == 0) {
            tableState.rows[j].removeLast();
          }
        }
      }

      notifyListeners();
    }
  }

  void removeRow() {
    tableState.rows.removeLast();
    notifyListeners();
  }

  void reset() {
    tableState = TableState();
  }

  void initEmptyTable() {
    for (var i = 0; i < tableState.initialColumnsCount; i++) {
      final column = ColumnState();
      tableState.cols.add(column);
    }
    for (var j = 0; j < tableState.initialRowsCount; j++) {
      List<CellState> row = [];
      for (var z = 0; z < tableState.initialColumnsCount; z++) {
        final cell = CellState();
        row.add(cell);
      }
      tableState.rows.add(row);
      row = [];
    }
  }

  List<ColumnHiveModel> toHiveColumnModels(List<ColumnState> columns) {
    List<ColumnHiveModel> new_columns = [];
    for (var column in columns) {
      final new_column = ColumnHiveModel()..value = column.value;
      new_columns.add(new_column);
    }
    return new_columns;
  }

  List<List<CellHiveModel>> toHiveRowModels(List<List<CellState>> rows) {
    List<List<CellHiveModel>> new_rows = [];

    for (var row in rows) {
      List<CellHiveModel> _row = [];
      for (var cell in row) {
        final new_cell = CellHiveModel()
          ..value = cell.value
          ..additionalCellProps = cell.additionalCellProps
          ..behavior = cell.behavior
          ..description = cell.description;
        _row.add(new_cell);
      }
      new_rows.add(_row);

      row = [];
    }
    return new_rows;
  }

  TableHiveModel toHiveObject(TableState tableState) {
    TableHiveModel tableHiveModel = TableHiveModel(
        tableId: tableState.tableId!,
        tableName: tableState.tableName!,
        lastModify: tableState.lastModify)
      ..tableName = tableState.tableName!
      ..tableId = tableState.tableId!
      ..initialRowsCount = tableState.initialRowsCount
      ..initialColumnsCount = tableState.initialColumnsCount
      ..selected = tableState.selected
      ..additionalCellProps = List.from(tableState.additionalCellProps)
      ..tableStyles = Map.from(tableState.tableStyles)
      ..cols.addAll(toHiveColumnModels(tableState.cols))
      ..rows.addAll(toHiveRowModels(tableState.rows));
    return tableHiveModel;
  }

  
}
