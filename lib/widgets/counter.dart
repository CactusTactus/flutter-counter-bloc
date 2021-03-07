import 'package:flutter/material.dart';

import '../bloc/counter_bloc.dart';
import '../events/counter_event.dart';

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  CounterBloc _counterBloc;
  double _iconSize;
  double _fontSize;

  @override
  void initState() {
    super.initState();
    _counterBloc = CounterBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    _iconSize = mediaQuery.size.shortestSide * 0.1;
    _fontSize = mediaQuery.size.shortestSide * 0.2;
  }

  @override
  void dispose() {
    super.dispose();
    _counterBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.add,
            size: _iconSize,
          ),
          onPressed: () => _counterBloc.counterEventSink.add(IncrementEvent()),
          padding: const EdgeInsets.all(0),
        ),
        CounterText(
          counterBloc: _counterBloc,
          fontSize: _fontSize,
        ),
        IconButton(
          icon: Icon(
            Icons.remove,
            size: _iconSize,
          ),
          onPressed: () => _counterBloc.counterEventSink.add(DecrementEvent()),
          padding: const EdgeInsets.all(0),
        ),
      ],
    );
  }
}

class CounterText extends StatelessWidget {
  final CounterBloc counterBloc;
  final double fontSize;

  CounterText({this.counterBloc, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: 0,
      stream: counterBloc.counterStateStream,
      builder: (context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          return Text(
            '${snapshot.data}',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          );
        }
        if (snapshot.hasError) {
          throw Exception(snapshot.error);
        }
        return Text(
          "?",
          style: TextStyle(
            fontSize: fontSize,
          ),
        );
      },
    );
  }
}
