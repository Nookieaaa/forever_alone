import 'package:qwil_flutter_test/models.dart';
import 'package:qwil_flutter_test/redux/actions.dart';

class AppState {
  SimulationState simulationState;
  List<ListData> listData;

  AppState(this.simulationState, this.listData);

  factory AppState.initial() {
    return AppState(SimulationState.DISABLED, List.unmodifiable([]));
  }

  factory AppState.startSimulation(AppState oldState) =>
      AppState(SimulationState.ENABLED, List.unmodifiable([]));

  factory AppState.stopSimulation(AppState oldState) =>
      AppState(SimulationState.DISABLED, oldState.listData);

  factory AppState.toggleSimulation(AppState oldState) => AppState(
      oldState.simulationState == SimulationState.ENABLED
          ? SimulationState.DISABLED
          : SimulationState.ENABLED,
      oldState.simulationState == SimulationState.ENABLED
          ? oldState.listData
          : List.unmodifiable([]));

  factory AppState.addEntry(AppState oldState, AddEntryAction action) =>
      AppState(
        oldState.simulationState,
        List.unmodifiable([action.entry]),
      );
}

enum SimulationState { ENABLED, DISABLED }
