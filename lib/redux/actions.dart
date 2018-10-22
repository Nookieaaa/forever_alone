import 'package:qwil_flutter_test/models.dart';
import 'package:qwil_flutter_test/redux/app_state.dart';

class AddEntryAction {
  final ListData entry;

  AddEntryAction(this.entry);
}

class SimulationStateChangedAction {
  final SimulationState simulationState;

  SimulationStateChangedAction(this.simulationState);

  factory SimulationStateChangedAction.toggleState(AppState oldState) =>
      SimulationStateChangedAction(
          oldState.simulationState == SimulationState.ENABLED
              ? SimulationState.DISABLED
              : SimulationState.ENABLED);

  bool isEnabled() => simulationState == SimulationState.ENABLED;
}
