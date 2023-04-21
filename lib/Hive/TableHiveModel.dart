import 'package:hive/hive.dart';
import 'package:my_first_app/Models/table-model.dart';
part 'TableHiveModel.g.dart';

@HiveType(typeId: 1)
class TableHiveModel extends HiveObject {
  @HiveField(0)
  late String tableName;
  @HiveField(1)
  int initialRowsCount = 0;
  @HiveField(2)
  int initialColumnsCount = 0;
  @HiveField(3)
  String selected = '';
  @HiveField(4)
  List<String> additionalCellProps = [];
  @HiveField(5)
  Map<String, dynamic> tableStyles = tableStylesInitial;
  @HiveField(6)
  List<ColumnHiveModel> cols = [];
  @HiveField(7)
  List<List<CellHiveModel>> rows = [];
  @HiveField(8)
  late String tableId;
  @HiveField(9)
  String? lastModify;

  TableHiveModel({
    required this.tableName,
    required this.tableId,
    required this.lastModify,
  });
}

@HiveType(typeId: 2)
class CellHiveModel extends HiveObject {
  @HiveField(0)
  String value = '';
  @HiveField(1)
  String description = '';
  @HiveField(2)
  CellBehavior behavior = CellBehavior.still;
  @HiveField(3)
  Map<String, String> additionalCellProps = {};

  CellHiveModel();
}

@HiveType(typeId: 3)
class ColumnHiveModel extends HiveObject {
  @HiveField(0)
  String value = '';
  ColumnHiveModel();
}

@HiveType(typeId: 4)
class BoxIdsHiveModel extends HiveObject {
  @HiveField(0)
  List<String> tableIds = [];
  BoxIdsHiveModel();
}
