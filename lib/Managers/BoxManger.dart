import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/Hive/TableHiveModel.dart';
import 'package:my_first_app/Models/table-model.dart';
import '../Hive/HiveStateMapper.dart';

class BoxManager with ChangeNotifier {
  List<String> _boxNames = [];
  final Map<String, Box<TableHiveModel>> _boxes = {};
  late Box<BoxIdsHiveModel> idsBox;
  BoxManager() {
    _init();
  }

  List<String>? getBoxIds() {
    return idsBox.get('tableIds')?.tableIds;
  }

  Future<void> _init() async {
    idsBox = await Hive.openBox<BoxIdsHiveModel>('tableIds');
    if (!idsBox.containsKey('tableIds')) {
      idsBox.put('tableIds', BoxIdsHiveModel());
    }
    _boxNames = idsBox.get('tableIds')!.tableIds;

    for (final boxName in _boxNames) {
      final box = await Hive.openBox<TableHiveModel>(boxName);
      _boxes[boxName] = box;
    }

    notifyListeners();
  }

  List<String> get boxNames => _boxNames;

  Box<TableHiveModel>? getBox(String boxName) {
    return _boxes[boxName];
  }

  String now() {
    final now = DateTime.now();
    final formated_data = DateFormat.yMMMMd().format(now);
    return '$formated_data/${now.hour.toString().padLeft(2, '0')} : ${now.minute.toString().padLeft(2, '0')} : ${now.second.toString().padLeft(2, '0')}';
  }

  void addBox(TableModel tableModel) async {
    final tableName = tableModel.tableState.tableName;
    final tableId = '$generateRandomString(8)';
    tableModel.tableState.tableId = tableId;
    tableModel.tableState.tableName = tableName;
    final box = await Hive.openBox<TableHiveModel>(tableId);
    final boxIds = await Hive.openBox<BoxIdsHiveModel>('tableIds');
    boxIds.get('tableIds')?.tableIds.add(tableId);
    await boxIds.get('tableIds')?.save();
    await box.put(
        'tableState',
        TableHiveModel(
            tableName: tableName!, tableId: tableId, lastModify: now()));
    box.get('tableState')?.save();
    _boxes[tableId] = box;
    notifyListeners();
  }

  void deleteBox(String? boxId) async {
    if (boxId == null) {
      return;
    }
    final idx =
        idsBox.get('tableIds')?.tableIds.indexWhere((id) => id == boxId);
    idsBox.get('tableIds')?.tableIds.removeAt(idx!);
    await idsBox.get('tableIds')?.save();
    _boxes[boxId]?.close();
    Hive.deleteBoxFromDisk(boxId);
    Hive.boxExists(boxId);
    _boxes.removeWhere(
      (key, value) {
        return key == boxId;
      },
    );
  }

  onSave(TableModel tableModel) async {
    final id = tableModel.tableState.tableId;
    tableModel.tableState.lastModify = now();
    if (id != null) {
      final box = await Hive.openBox<TableHiveModel>(id);
      await box.put(
          'tableState', tableModel.toHiveObject(tableModel.tableState));
      _boxes[id] = box;
      await box.get('tableState')?.save();
    }
  }

  Future<Box<TableHiveModel>> openSafeBox(String? tableId) async {
    Box<TableHiveModel> box;
    if (tableId != null) {
      if (Hive.isBoxOpen(tableId)) {
        box = Hive.box(tableId);
      } else {
        box = await Hive.openBox<TableHiveModel>(tableId);
      }
      return box;
    }
    throw ('tableId is Null');
  }

  void removeBox(String boxName) {
    _boxNames.remove(boxName);
    _boxes[boxName]?.close();
    _boxes.remove(boxName);
    notifyListeners();
  }

  @override
  void dispose() {
    for (final box in _boxes.values) {
      box.close();
    }
    super.dispose();
  }
}
