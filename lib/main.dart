import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_first_app/Hive/TableHiveModel.dart';
import 'package:my_first_app/Managers/BoxManger.dart';
import 'package:my_first_app/Screens/tableList.dart';
import 'package:my_first_app/Screens/table.dart';
import 'package:my_first_app/Models/table-model.dart';
import 'package:provider/provider.dart';
import 'Hive/CustomAdapters.dart';

enum MainScreens { tableList, table }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TableHiveModelAdapter());
  Hive.registerAdapter(CellHiveModelAdapter());
  Hive.registerAdapter(ColumnHiveModelAdapter());
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(CellBehaviorAdapter());
  Hive.registerAdapter(BoxIdsHiveModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tables',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TableModel()),
          ChangeNotifierProvider(create: (context) => BoxManager())
          // TableProvider(model: TableModel()
        ],
        child: const SafeArea(child: Screens()),
      ),
    );
  }
}

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  MainScreens currentScreen = MainScreens.tableList;
  bool justCreated = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentScreen == MainScreens.table
          ? CustomDataTable(
              onHome: () => setState(() {
                    currentScreen = MainScreens.tableList;
                  }),
              justCreated: justCreated)
          : TableList(
              onCreate: (cb) => setState(() {
                cb();
                justCreated = true;
                currentScreen = MainScreens.table;
              }),
              onTableSelect: (Function cb) {
                setState(() {
                  justCreated = false;
                  currentScreen = MainScreens.table;
                  cb();
                });
              },
            ),
    );
  }
}
