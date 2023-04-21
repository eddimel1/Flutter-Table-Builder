import 'package:flutter/material.dart';
import 'package:my_first_app/Models/table-model.dart';

class CellPropsEditPopUp {
  late TableModel model;
  List<Widget> _buildTextInputs(TableModel? tableModel, CellState currentCell,
      int rowIndex, int cellIndex) {
    final currentCell = tableModel!.tableState.rows[rowIndex][cellIndex];
    final cellAdditionalProps = currentCell.additionalCellProps;
    return cellAdditionalProps.entries.map((e) {
      final key = e.key;
      final value = e.value;
      return TextField(
        onChanged: (currentVal) {
          tableModel.tableState.rows[rowIndex][cellIndex]
              .additionalCellProps[key] = currentVal;
        },
        controller: TextEditingController(text: value),
        decoration: InputDecoration(labelText: key),
        maxLength: 20,
      );
    }).toList();
  }

  showCellProprtiesEditDialog(TableModel tableModel, BuildContext context,
      void Function()? onPressed, int rowIndex, int cellIndex) {
    model = tableModel;
    final currentCell = model.tableState.rows[rowIndex][cellIndex];
    List<Widget> textFields =
        _buildTextInputs(model, currentCell, rowIndex, cellIndex);
    Widget saveButton = Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.save),
        label: const Text('Save'),
        onPressed: () => {onPressed, Navigator.of(context).pop()},
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Edit Cell Additional Properties"),
      actions: [
        ...textFields,
        saveButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(child: alert);
      },
    );
  }
}
