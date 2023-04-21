import 'package:flutter/material.dart';
import 'package:my_first_app/Managers/BoxManger.dart';
import 'package:my_first_app/Models/table-model.dart';
import 'package:provider/provider.dart';
import '../PopUps/cell-description-alert.dart';
import '../PopUps/cell-edit-alert.dart';
import '../PopUps/setup-alert.dart';


class CustomDataTable extends StatefulWidget {
  bool tableIsInitialized = false;
  bool showSetup = false;
  bool? initialCreation;
  bool? justCreated;
  Function() onHome;

  CustomDataTable({required this.onHome, this.justCreated, super.key});

  @override
  State<CustomDataTable> createState() => _CustomDataTable();
}

class _CustomDataTable extends State<CustomDataTable> {
  final cellInputCO = TextEditingController();
  final cellPropEditPopUp = CellPropsEditPopUp();
  final descriptionEditPopUp = CellDescriptionEditPopUp();
  final showSetupDialog = false;
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TableModel>(context);
    final boxManager = Provider.of<BoxManager>(context);
    if (widget.tableIsInitialized == false && widget.justCreated == true) {
      model.initEmptyTable();
    }
    widget.tableIsInitialized = true;
    return Scaffold(
      body: buildDataTable(context),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
          label: 'Home',
          tooltip: 'Go back Home',
          icon: GestureDetector(
              onTap: () => {
                    boxManager.onSave(model),
                    widget.onHome(),
                  },
              child: const Icon(
                Icons.home,
                color: Colors.deepOrange,
              )),
        ),
        BottomNavigationBarItem(
          label: 'Save',
          tooltip: 'Save Data',
          icon: GestureDetector(
              child: const Icon(
                Icons.save,
                color: Colors.deepOrange,
              ),
              //and error occurs because model is saved twice
              onTap: () => {boxManager.onSave(model)}),
        ),
        BottomNavigationBarItem(
          label: 'Settings',
          tooltip: 'Modify Table',
          icon: GestureDetector(
              child: const Icon(
                Icons.settings_applications,
                color: Colors.deepOrange,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SetupDialog(
                        tableModel: model, updateState: () => setState(() {}));
                  },
                );
              }),
        ),
        BottomNavigationBarItem(
          label: 'Add Row',
          tooltip: 'Add Row',
          icon: GestureDetector(
              child: const Text('+1R',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w600)),
              onTap: () {
                model.addRow();
              }),
        ),
        BottomNavigationBarItem(
          label: 'Add Column',
          tooltip: 'Add Column',
          icon: GestureDetector(
              child: const Text('+1C',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w600)),
              onTap: () {
                model.addCol();
              }),
        ),
        BottomNavigationBarItem(
          label: 'Remove Row',
          tooltip: 'Remove Row',
          icon: GestureDetector(
              child: const Text('-1R',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w600)),
              onTap: () {
                model.removeRow();
              }),
        ),
        BottomNavigationBarItem(
          label: 'Remove Column',
          tooltip: 'Remove Column',
          icon: GestureDetector(
              child: const Text('-1C',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w600)),
              onTap: () {
                model.removeCol();
              }),
        ),
      ], fixedColor: Colors.deepOrange, iconSize: 30),
    );
  }

  DataTable _getTable() {
    final model = Provider.of<TableModel>(context);
    final tableState = model.tableState;
    return DataTable(
      dataRowColor:
          MaterialStateProperty.all(model.tableState.tableStyles['rowsColor']),
      dataTextStyle:
          TextStyle(color: model.tableState.tableStyles['rowsTextColor']),
      border: TableBorder.all(
          color: model.tableState.tableStyles['rowsBorderColor']),
      columns: _getColumns(tableState.cols, model),
      rows: _getRows(tableState.rows, model),
    );
  }
bool isColorDark(Color color) {
  final brightness = color.computeLuminance();
  return brightness < 0.5;
}
  Widget buildDataTable(BuildContext context) {
    return _getDataTableWrapper(_getTable());
  }

  Widget _getDataTableWrapper(DataTable dataTable) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: dataTable,
          ),
        );
      },
    );
  }

  List<DataColumn> _getColumns(
      List<ColumnState> columns, TableModel tableModel) {
    final cols = columns.asMap().entries;
    final newCols = cols.map((col) {
      final colState = col.value;
      return DataColumn(
        label: Container(
          child: Text(colState.value,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        ),
      );
    }).toList();
    return newCols;
  }

  List<DataRow> _getRows(List<List<CellState>> rows, TableModel tableModel) {
    final rowEntries = rows.asMap().entries;

    final newRows = rowEntries.map((row) {
      int idx = row.key;
      final rowValue = row.value;
      return DataRow(cells: _getCells(rowValue, idx, tableModel));
    }).toList();
    return newRows;
  }

  List<DataCell> _getCells(
      List<CellState> row, int rowIndex, TableModel tableModel) {
    final cells = row.asMap().entries.map((cell) {
      int idx = cell.key;
      final colsCount = tableModel.tableState.cols.length;
      final scrWidth = MediaQuery.of(context).size.width;
      // i had to do this garbage :)))))))
      final minWidth = colsCount == 1
          ? scrWidth
          : colsCount == 2
              ? scrWidth / 3
              : colsCount == 3
                  ? scrWidth / 8
                  : colsCount == 4
                      ? scrWidth / 12
                      : colsCount == 5
                          ? scrWidth / 16
                          : colsCount == 6
                              ? scrWidth / 20
                              : 0;
      final Map<String, String> additionalProps = {};
      final currentCell = tableModel.tableState.rows[rowIndex][idx];
      var additionalCellProperties = currentCell.additionalCellProps;
      final cellKeys = Set.from(additionalCellProperties.keys.toList());
      for (var i = 0;
          i < tableModel.tableState.additionalCellProps.length;
          i++) {
        additionalCellProperties = additionalProps;
        tableModel.tableState.additionalPropsAreAdded = true;
      }
      Map<String, String> cellProps =
          Map.from(tableModel.tableState.rows[rowIndex][idx].additionalCellProps);
      for (String value in tableModel.tableState.additionalCellProps) {
        if (!cellKeys.contains(value)) {
          cellProps.addAll({value: ''});
        }
      }
      for (String value in tableModel
          .tableState.rows[rowIndex][idx].additionalCellProps.keys) {
        if (!tableModel.tableState.additionalCellProps.contains(value)) {
          cellProps.removeWhere((key, value) => value == value);
        }
      }

      tableModel.tableState.rows[rowIndex][idx].additionalCellProps =
          cellProps;
      final cellValue = cell.value.value;
      final behavior = tableModel.tableState.rows[rowIndex][idx].behavior;
      final is_selected = tableModel.tableState.selected == '$rowIndex$idx';
      final iconColor = isColorDark(tableModel.tableState.tableStyles['rowsColor'] as Color) ? Color.fromRGBO(255, 255, 255, 1) : Color.fromRGBO(0, 0, 0, 1);
      getAppropriateWidget() {
        if (behavior == CellBehavior.choosingOptions && is_selected) {
          return Row(children: [
            GestureDetector(
              child:  Icon(Icons.edit , color: iconColor),
              onTap: () {
                setState(() {
                  tableModel.tableState.rows[rowIndex][idx].behavior =
                      CellBehavior.editing;
                });
              },
            ),
            GestureDetector(
              child:  Icon(Icons.description , color: iconColor,),
              onTap: () {
                setState(() {
                  descriptionEditPopUp.showCellDescriptionEditDialog(
                      context, tableModel, rowIndex, idx);
                });
              },
            ),
            GestureDetector(
              child: Icon(Icons.edit_note , color: iconColor,),
              onTap: () {
                setState(() {
                  cellPropEditPopUp
                      .showCellProprtiesEditDialog(tableModel, context, () {
                    setState(() {});
                  }, rowIndex, idx);
                });
              },
            )
          ]);
        } else if (behavior == CellBehavior.editing && is_selected) {
          final focusNode = FocusNode();
          cellInputCO.text = cellValue;
          focusNode.addListener(() {
            if (cellInputCO.text.length < 20) {
              tableModel.tableState.rows[rowIndex][idx].value =
                  cellInputCO.text;
            }
            if (!focusNode.hasFocus) cellInputCO.clear();
          });

          return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: cellInputCO,
                  autofocus: true,
                  buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          maxLength}) =>
                      null,
                  maxLength: 20,
                  focusNode: focusNode,
                  maxLines: null,
                  decoration: InputDecoration(
                    prefixIcon: GestureDetector(
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        onTap: () {
                          setState(() {
                            if (cellInputCO.text.length < 20) {
                              tableModel.tableState.rows[rowIndex][idx].value =
                                  cellInputCO.text;
                              tableModel.tableState.rows[rowIndex][idx]
                                  .behavior = CellBehavior.still;
                            }
                            cellInputCO.clear();
                          });
                        }),
                    hintText: 'Edit Cell Value',
                    filled: true,
                    fillColor: const Color(0xFFF2F2F2),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Text(
            cellValue,
          );
        }
      }

      return DataCell(
          ConstrainedBox(
              constraints: BoxConstraints(minWidth: minWidth.toDouble()),
              child: getAppropriateWidget()),
          onTap: () => {
                setState(() {
                  tableModel.tableState.selected = '$rowIndex$idx';
                  tableModel.tableState.rows[rowIndex][idx].behavior =
                      CellBehavior.choosingOptions;
                })
              });
    }).toList();
    return cells;
  }
}
