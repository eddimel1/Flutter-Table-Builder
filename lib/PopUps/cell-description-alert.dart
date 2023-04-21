import 'package:flutter/material.dart';
import 'package:my_first_app/Models/table-model.dart';

class CellDescriptionEditPopUp {
  late TableModel model;

   showCellDescriptionEditDialog(BuildContext context,TableModel tableModel ,int rowIndex, int cellIndex) {
    TableModel model =  tableModel;
    final currentCell = model.tableState.rows[rowIndex][cellIndex];
    Widget textArea = Card(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 10, //or null 
                decoration: const InputDecoration.collapsed(hintText: "Enter your text here"),
                controller: TextEditingController(text: currentCell.description),
                onChanged: (val){
                   currentCell.description = val;
                },
             ),
            )
          );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Edit Cell Description"),
      actions: [
       textArea,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}