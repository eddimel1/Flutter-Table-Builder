import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_first_app/Hive/HiveStateMapper.dart';
import 'package:my_first_app/Hive/TableHiveModel.dart';
import 'package:my_first_app/Managers/BoxManger.dart';
import 'package:my_first_app/Models/table-model.dart';
import 'package:provider/provider.dart';

import '../PopUps/create-alert.dart';

enum TableListModes { delete, open }

class TableList extends StatefulWidget {
  Function(dynamic cb) onCreate;
  Function onTableSelect;

  TableList({Key? key, required this.onCreate, required this.onTableSelect})
      : super(key: key);
  @override
  _TableListState createState() => _TableListState();
}

class _TableListState extends State<TableList> {
  List<Container> tableBoxes = [];
  TableListModes mode = TableListModes.open;
  List<Container> createCards(BoxManager boxManager) {
    final model = Provider.of<TableModel>(context);
    final hiveManger = HiveStateMapper(model: model);
    final ids = boxManager.boxNames;
    final List<Box<TableHiveModel>> boxes = [];

    for (var boxId in ids) {
      final box = boxManager.getBox(boxId);
      if (box != null) boxes.add(box);
    }
    tableBoxes = boxes.map((box) {
      final boxState = box.get('tableState');
      final tableState = hiveManger.toModel(boxState!);
      final dateAndTime = boxState.lastModify?.split('/');
      final fnToExecute = mode == TableListModes.delete
          ? () {
              setState(() {
                boxManager.deleteBox(boxState.tableId);
              });
            }
          : () {
              widget.onTableSelect(() => model.tableState = tableState);
            };
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 78, 252, 234),
            boxShadow: const [
              BoxShadow(
                offset: Offset(3, 3),
                spreadRadius: 0,
                blurRadius: 11,
                color: Color.fromRGBO(0, 0, 0, 1),
              )
            ],
            border: Border.all(
                color:
                    mode == TableListModes.delete ? Colors.red : Colors.white,
                width: 6)),
        child: GestureDetector(
          onTap: fnToExecute,
          child: FittedBox(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(boxState.tableName, style: const TextStyle(fontSize: 30)),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const Text('last modify : ', style: TextStyle(fontSize: 30)),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date : ${dateAndTime![0]}',
                            style: const TextStyle(fontSize: 20)),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text('Time : ${dateAndTime[1]}',
                              style: const TextStyle(fontSize: 20)),
                        )
                      ]),
                ],
              ),
            ],
          )),
        ),
      );
    }).toList();
    return tableBoxes;
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TableModel>(context);
    final BoxManager boxManager = Provider.of<BoxManager>(context);
    final ids = boxManager.boxNames;
    final boxes = [];
    final width = MediaQuery.of(context).size.width;
    final colsToShow = width < 700
        ? 2
        : width < 900
            ? 3
            : width > 1100
                ? 4
                : 2;
    for (var boxId in ids) {
      final box = boxManager.getBox(boxId);
      if (box != null) boxes.add(box);
    }
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: GestureDetector(
                  child: const Icon(Icons.add),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return CreateAlertDialog(
                              boxManager: boxManager,
                              onCreate: widget.onCreate,
                              tableModel: model);
                        });
                  }),
              label: 'Add Table',
              tooltip: 'Add Table'),
          BottomNavigationBarItem(
              icon: GestureDetector(
                  child: const Icon(Icons.delete),
                  onTap: () {
                    setState(() {
                      mode = mode == TableListModes.open
                          ? TableListModes.delete
                          : TableListModes.open;
                    });
                  }),
              label: 'Remove Tables',
              tooltip: 'Remove Tables')
        ],
      ),
      body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: colsToShow,
          children: createCards(boxManager)),
    );
  }
}
