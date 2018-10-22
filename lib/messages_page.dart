import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:qwil_flutter_test/models.dart';
import 'package:qwil_flutter_test/redux/actions.dart';
import 'package:qwil_flutter_test/redux/app_state.dart';
import 'package:redux/redux.dart';

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _MessagesPageViewModel>(
      distinct: true,
      converter: (store) => _MessagesPageViewModel.create(store),
      builder: (context, viewModel) => new Scaffold(
            appBar: new AppBar(
              title: new Text(title),
            ),
            floatingActionButton: new FloatingActionButton(
              onPressed: viewModel.onToggleState,
              child: new Icon(
                  viewModel.simulationState == SimulationState.DISABLED
                      ? Icons.play_arrow
                      : Icons.pause),
            ),
            body: new Center(
              child: new Container(child: new MessagesWidget(viewModel.data)),
            ),
          ),
    );
  }
}

class MessagesWidget extends StatelessWidget {
  final List<_ItemViewModel> data;

  MessagesWidget(this.data);

  @override
  Widget build(BuildContext context) => ListView(
        scrollDirection: Axis.vertical,
        children: data.map((item) => createItemWidget(item)).toList(),
      );
}

Widget createItemWidget(_ItemViewModel item) {
  switch (item.runtimeType) {
    case _MessageViewModel:
      return _createMessageWidget(item);
    case _SummaryViewModel:
      return _createSummaryWidget(item);
  }
  throw new ArgumentError("Item view model not supported $item");
}

Widget _createMessageWidget(_MessageViewModel item) => new ListTile(
      title: new Text(
        item.message.user.name,
      ),
      subtitle: new Text(
        item.message.text,
      ),
      trailing:
          new Text(DateFormat("HH:mm:ss", "en").format(item.message.time)),
    );

Widget _createSummaryWidget(_SummaryViewModel item) => new Container(
      color: Colors.lightBlue,
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: item.messages
              .map((f) => createItemWidget(new _MessageViewModel(f)))
              .toList()),
    );

class _MessagesPageViewModel {
  final List<_ItemViewModel> data;
  final SimulationState simulationState;
  final Function() onToggleState;

  _MessagesPageViewModel(this.data, this.simulationState, this.onToggleState);

  factory _MessagesPageViewModel.create(Store<AppState> store) {
    List<_ItemViewModel> listData = store.state.listData.map((f) {
      switch (f.runtimeType) {
        case Message:
          return new _MessageViewModel(f);
        case SummaryMessage:
          return new _SummaryViewModel((f as SummaryMessage).messages);
      }
    }).toList();

    return new _MessagesPageViewModel(listData, store.state.simulationState,
        () {
      store.dispatch(SimulationStateChangedAction(store.state.simulationState));
    });
  }
}

abstract class _ItemViewModel {}

@immutable
class _MessageViewModel extends _ItemViewModel {
  final Message message;

  _MessageViewModel(this.message);
}

@immutable
class _SummaryViewModel extends _ItemViewModel {
  final List<Message> messages;

  _SummaryViewModel(this.messages);
}
