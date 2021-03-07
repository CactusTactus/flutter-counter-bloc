import 'dart:async';

import '../events/counter_event.dart';

class CounterBloc {
  int _counter = 0;

  final _counterEventController = StreamController<CounterEvent>();
  final _counterStateController = StreamController<int>();

  Sink<CounterEvent> get counterEventSink => _counterEventController.sink;
  StreamSink<int> get _counterStateSink => _counterStateController.sink;
  Stream<int> get counterStateStream => _counterStateController.stream;

  CounterBloc() {
    _counterEventController.stream.listen(_eventToState);
  }

  void _eventToState(CounterEvent counterEvent) {
    if (counterEvent is IncrementEvent) {
      _counter++;
    } else if (counterEvent is DecrementEvent) {
      _counter--;
    } else {
      throw Exception("Wrong event type.");
    }
    _counterStateSink.add(_counter);
  }

  void dispose() {
    _counterEventController.close();
    _counterStateController.close();
  }
}