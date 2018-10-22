import 'dart:async';
import 'dart:math';

import 'package:qwil_flutter_test/models.dart';
import 'package:qwil_flutter_test/redux/actions.dart';
import 'package:qwil_flutter_test/redux/app_state.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

final epics = combineEpics([_simulationStartEpic, _reschedulingMessagesEpic]);

// ignore: slash_for_doc_comments
/**i`m not sure how bad is this solution, since rxDart doesn`t have repeat() without count
 * so i just intercept addItem which i`m getting from _simulationStartEpic
 * and apply it again and again till we`ve got Stop event
 **/
Observable<dynamic> _reschedulingMessagesEpic(
    Stream<dynamic> actions, EpicStore<AppState> epicStore) {
  return Observable(actions)
      .ofType(TypeToken<AddEntryAction>())
      .switchMap((AddEntryAction action) {
    return _messageSendingObservable(actions).takeUntil(actions.where((action) {
      if (action is SimulationStateChangedAction) {
        return action.isEnabled();
      } else {
        return false;
      }
    }));
  });
}

Observable<dynamic> _simulationStartEpic(
    Stream<dynamic> actions, EpicStore<AppState> epicStore) {
  return Observable(actions)
      .ofType(TypeToken<SimulationStateChangedAction>())
      .switchMap((SimulationStateChangedAction action) {
    if (!action.isEnabled()) {
      return _messageSendingObservable(actions)
          .takeUntil(actions.where((action) {
        if (action is SimulationStateChangedAction) {
          return !action.isEnabled();
        }
        return false;
      }));
    } else {
      return Observable.never();
    }
  });
}

//mapping summary object to AddEntryAction
Observable<AddEntryAction> _messageSendingObservable(Stream<dynamic> actions) =>
    _debouncedSummary().map((summary) => AddEntryAction(summary));

Observable<Message> _firstUserMessages() =>
    _emitMessageOrTimeout(User.Woopsen());

Observable<Message> _secondUserMessages() =>
    _emitMessageOrTimeout(User.Poopsen());

Observable<Message> _thirdUserMessages() =>
    _emitMessageOrTimeout(User.Luntik());

const int _summaryDebounceMs = 1000;

//Since every new summary shouldn`t be emitted at least for 1 sec
Observable<SummaryMessage> _debouncedSummary() => Observable.zip2(
        _combineSummary(),
        Observable.periodic(
            Duration(milliseconds: _summaryDebounceMs), (i) => i),
        (summary, timer) {
      return summary;
    });

//combining 3 messages into summary
Observable<SummaryMessage> _combineSummary() => Observable.combineLatest3(
    _firstUserMessages(),
    _secondUserMessages(),
    _thirdUserMessages(),
    (message1, message2, message3) =>
        SummaryMessage([message1, message2, message3]));

//Race will take first result N/A or message
Observable<Message> _emitMessageOrTimeout(User user) => Observable.race(
    [_tryEmitMessageObservable(user), _timeoutMessageObservable(user)]);

const int _timeoutMs = 10000;

//ensuring N/A state
Observable<Message> _timeoutMessageObservable(User user) => Observable.timer(
    Message.notAvailable(user), Duration(milliseconds: _timeoutMs));

//since we have 1-2 sec intervals
const int MIN_POST_MESSAGE_DELAY_MS = 1000;
const int MAX_POST_MESSAGE_DELAY_MS = 2000;
final Random _timerRandom = new Random(MIN_POST_MESSAGE_DELAY_MS);

int randomTimer() => _timerRandom.nextInt(MAX_POST_MESSAGE_DELAY_MS);

//random delay with random message
Observable<Message> _tryEmitMessageObservable(User user) =>
    Observable.defer(() => Observable.timer(
        Message.randomFrom(user), Duration(milliseconds: randomTimer())));
