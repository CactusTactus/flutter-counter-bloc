import 'package:flutter/material.dart';

import '../bloc/counter_bloc.dart';
import '../events/counter_event.dart';

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  CounterBloc _counterBloc;
  double _fontSize;

  @override
  void initState() {
    super.initState();
    _counterBloc = CounterBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fontSize = MediaQuery.of(context).size.shortestSide * 0.2;
  }

  @override
  void dispose() {
    super.dispose();
    _counterBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: [
        CounterText(
          counterBloc: _counterBloc,
          fontSize: _fontSize,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              child: const Icon(Icons.remove),
              backgroundColor: Colors.blue,
              onPressed: () =>
                  _counterBloc.counterEventSink.add(DecrementEvent()),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              child: const Icon(Icons.add),
              backgroundColor: Colors.red,
              onPressed: () =>
                  _counterBloc.counterEventSink.add(IncrementEvent()),
            ),
          ],
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
