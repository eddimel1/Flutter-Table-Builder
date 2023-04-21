import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../Models/table-model.dart';

typedef ColorChangedCallback<T> = void Function(T color);

enum Screens {
  editColumns,
  editStyle,
  editCells,
  selection,
  pickRowsColor,
  pickRowsTextColor,
  pickBorderColor
}

class SetupDialog extends StatefulWidget {
  SetupDialog({required this.tableModel, required this.updateState, super.key});
  TableModel? tableModel;
  void Function() updateState;

  @override
  _SetupDialogState createState() => _SetupDialogState();
}

class _SetupDialogState extends State<SetupDialog> {
  Screens _currentScreen = Screens.selection;
  List<String> additionalCellPropsNew = [];
  bool showColorPicker = false;
  Color pickerColor = const Color(0xff443a49);

  void setScreen(Screens screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  AlertDialog setupAlert() {
    Widget editColumns = ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _currentScreen = Screens.editColumns;
          });
        },
        icon: const Icon(Icons.edit_attributes_outlined),
        label: const Text('Edit Columns'));
    Widget editCells = ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _currentScreen = Screens.editCells;
          });
        },
        icon: const Icon(Icons.edit_document),
        label: const Text('Edit Cells'));
    Widget editStyle = ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _currentScreen = Screens.editStyle;
          });
        },
        icon: const Icon(Icons.style),
        label: const Text('Edit Styles'));
    return AlertDialog(
      title: const Text('Choose what you want to edit or setup'),
      actions: <Widget>[
        IntrinsicWidth(
          child: Column(
            children: [editColumns, editCells, editStyle],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
        )
      ],
    );
  }

  AlertDialog setupCells() {
    final tableState = widget.tableModel?.tableState;

    Widget backButton = ElevatedButton(
        onPressed: () {
          setState(() {
            _currentScreen = Screens.selection;
          });
        },
        child: const Icon(Icons.arrow_back));
    final propLength = tableState?.additionalCellProps.length ?? 0;
    List<String>? additionalCellProps = tableState?.additionalCellProps;
    Widget addCellButton = ElevatedButton(
        onPressed: () {
          setState(() {
            if (propLength > 0) {
              widget.tableModel?.tableState.additionalCellProps.add('');
              widget.tableModel?.tableState.additionalPropsAreAdded = true;
            } else {
              setState(() {
                additionalCellPropsNew
                    .add((additionalCellPropsNew.length + 1).toString());
              });
            }
          });
        },
        child: const Icon(Icons.add));

    Widget saveButton = ElevatedButton(
        onPressed: () {
          if (propLength > 0) {
            widget.updateState();
          } else {
            setState(() {
              tableState?.additionalCellProps = additionalCellPropsNew;
            });
          }
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.save));
    final List<Widget> textFields = propLength > 0
        ? additionalCellProps!.asMap().entries.map((e) {
            final key = e.key;
            final value = e.value;
            return TextField(
              decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                      child: Icon(Icons.close),
                      onTap: () {
                        setState(() {
                          widget.tableModel?.tableState.additionalCellProps
                              .removeWhere((element) => element == value);
                        });
                      }),
                  label: Text('Cell Property $key'),
                  border: const OutlineInputBorder()),
              maxLength: 20,
              maxLines: null,
              controller: TextEditingController(text: value),
              onChanged: (val) {
                tableState?.additionalCellProps[key] = val;
              },
            );
          }).toList()
        : additionalCellPropsNew.asMap().entries.map((e) {
            final key = e.key;
            final value = e.value;
            return TextField(
              decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                      child: Icon(Icons.close),
                      onTap: () {
                        setState(() {
                          additionalCellPropsNew
                              .removeWhere((element) => element == value);
                        });
                      }),
                  label: Text('Cell Property $key'),
                  border: const OutlineInputBorder()),
              maxLength: 20,
              maxLines: null,
              onChanged: (val) => additionalCellPropsNew[key] = val,
            );
          }).toList();

    return AlertDialog(
      title: const Text('Setup cell additional properties'),
      actions: [
        ...textFields,
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            children: [backButton, saveButton, addCellButton],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        )
      ],
    );
  }

  AlertDialog editColumns() {
    Widget editColumns = ElevatedButton.icon(
        onPressed: () {
          widget.updateState();
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.edit_attributes_outlined),
        label: const Text('Edit Columns'));
    List<Widget> actions = [editColumns];

    final state = widget.tableModel?.tableState;
    if (state != null) {
      for (var i = 0; i < state.cols.length; i++) {
        double padding = i == 0 ? 10.0 : 0;
        actions.add(Row(
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(top: padding),
              child: TextField(
                maxLength: 20,
                decoration: InputDecoration(
                    label: Text('column$i'),
                    border: const OutlineInputBorder()),
                onChanged: (val) {
                  state.cols[i].value = val;
                },
                controller: TextEditingController(text: state.cols[i].value),
                maxLines: null,
              ),
            )),
          ],
        ));
      }
    }

    Widget backButton = Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              _currentScreen = Screens.selection;
            });
          },
          child: const Icon(Icons.arrow_back)),
    );
    return AlertDialog(
      title: const Text('Edit Table Columns'),
      actions: [...actions, backButton],
    );
  }

  setupStyles() {
    Widget showRowsColorPicker = ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _currentScreen = Screens.pickRowsColor;
          });
        },
        icon: const Icon(Icons.colorize),
        label: const Text('Edit rows color'));
    Widget showTextColorPicker = ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _currentScreen = Screens.pickRowsTextColor;
          });
        },
        icon: const Icon(Icons.colorize),
        label: const Text('Edit rows text color'));

    Widget showBorderColorPicker = ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _currentScreen = Screens.pickBorderColor;
          });
        },
        icon: const Icon(Icons.colorize),
        label: const Text('Edit rows border color'));

    Widget backButton = ElevatedButton(
        onPressed: () {
          setState(() {
            _currentScreen = Screens.selection;
          });
        },
        child: const Icon(Icons.arrow_back));

    return AlertDialog(
      title: const Center(child: Text('Edit Table Styles')),
      actions: <Widget>[
        IntrinsicWidth(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                showTextColorPicker,
                showRowsColorPicker,
                showBorderColorPicker,
                backButton
              ],
            ),
          ),
        )
      ],
    );
  }

  showColorPickerPopUp(String title, String propToChange) {
    Widget rowsTextColorPicker = AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
            child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (Color color) {
                  widget.tableModel!.tableState.tableStyles[propToChange] =
                      color;

                  widget.updateState();
                })));
    return rowsTextColorPicker;
  }

  @override
  Widget build(BuildContext context) {
    //:))))))))))))))))))))
    return _currentScreen == Screens.selection
        ? setupAlert()
        : _currentScreen == Screens.editCells
            ? SingleChildScrollView(child: setupCells())
            : _currentScreen == Screens.editStyle
                ? setupStyles()
                : _currentScreen == Screens.pickRowsColor
                    ? showColorPickerPopUp('pick rows color', 'rowsColor')
                    : _currentScreen == Screens.pickRowsTextColor
                        ? showColorPickerPopUp(
                            'pick rows text color', 'rowsTextColor')
                        : _currentScreen == Screens.pickBorderColor
                            ? showColorPickerPopUp(
                                'pick rows border color', 'rowsBorderColor')
                            : SingleChildScrollView(child: editColumns());
  }
}
