import 'package:flutter/material.dart';
import 'package:my_first_app/Managers/BoxManger.dart';
import 'package:my_first_app/Models/table-model.dart';
import '../Utility/validator.dart';

final _formKey = GlobalKey<FormState>();

class CreateAlertDialog extends StatefulWidget {
  TableModel tableModel;
  Function onCreate;
  BoxManager boxManager;

  CreateAlertDialog(
      {Key? key,
      required this.tableModel,
      required this.onCreate,
      required this.boxManager})
      : super(key: key);

  @override
  _CreateAlertDialogState createState() => _CreateAlertDialogState();
}

class _CreateAlertDialogState extends State<CreateAlertDialog> {
  showInitialDialog() {
    Widget setRowsField = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value != null) {
            return Validator.validateMaxNumber(
                100, Validator.trimNonNumberCharacters(value));
          } else {
            return null;
          }
        },
        onChanged: (val) {
          final trimmed = val.replaceAll(RegExp(r'[^0-9]'), '').trim();
          widget.tableModel.tableState.initialRowsCount = int.parse(trimmed);
        },
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            label: Text('rows'), border: OutlineInputBorder()),
      ),
    );
    Widget setColsField = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          if (value != null) {
            return Validator.validateMaxNumber(
                10, Validator.trimNonNumberCharacters(value));
          } else {
            return null;
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (val) {
          final trimmed = val.replaceAll(RegExp(r'[^0-9]'), '').trim();
          widget.tableModel.tableState.initialColumnsCount = int.parse(trimmed);
        },
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            label: Text('columns'), border: OutlineInputBorder()),
      ),
    );
    Widget launchButton = TextButton(
      child: const Text("Create"),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          widget.onCreate(() => {
                widget.boxManager.addBox(widget.tableModel),
                if (widget.tableModel.tableState.rows.isNotEmpty)
                  {widget.tableModel.tableState.rows = []},
                if (widget.tableModel.tableState.cols.isNotEmpty)
                  {widget.tableModel.tableState.cols = []},
              });
          Future.delayed(const Duration(milliseconds: 500));
          Navigator.of(context).pop();
        }
      },
    );

    Widget tableName = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: 20,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return Validator.validateMaxStringLength(20, value);
        },
        onChanged: (val) =>
            widget.tableModel.tableState.tableName = val.toString(),
        decoration: const InputDecoration(
            label: Text('Table name'), border: OutlineInputBorder()),
      ),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Create columns and rows"),
      content: const Text("How many columns and rows do you want?"),
      actions: [
        Form(
          key: _formKey,
          child: Column(children: [
            setRowsField,
            setColsField,
            tableName,
          ]),
        ),
        launchButton,
      ],
    );
    return alert;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showInitialDialog(),
    );
  }
}
