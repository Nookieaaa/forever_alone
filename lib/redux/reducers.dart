import 'package:qwil_flutter_test/redux/actions.dart';
import 'package:qwil_flutter_test/redux/app_state.dart';
import 'package:redux/redux.dart';

final appStateReducer = combineReducers<AppState>([
  TypedReducer<AppState, SimulationStateChangedAction>(_toggleSimulationState),
  TypedReducer<AppState, AddEntryAction>(_addEntry)
]);

AppState _toggleSimulationState(
        AppState state, SimulationStateChangedAction action) =>
    action.isEnabled()
        ? AppState.stopSimulation(state)
        : AppState.startSimulation(state);

AppState _addEntry(AppState state, AddEntryAction action) {
  return AppState.addEntry(state, action);
}
