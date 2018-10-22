import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qwil_flutter_test/redux/app_state.dart';
import 'package:qwil_flutter_test/redux/epics.dart';
import 'package:qwil_flutter_test/redux/reducers.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

import 'messages_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final String title = "Forever alone";

  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("en");
    return StoreProvider<AppState>(
        store: new Store<AppState>(appStateReducer,
            initialState: AppState.initial(),
            middleware: [EpicMiddleware(epics)]),
        child: new MaterialApp(
          title: title,
          theme: new ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: new MyHomePage(title: title),
        ));
  }
}
