import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key, required this.title});
  final String title;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  final List<Color> _squares = List.generate(10, (index) => Colors.redAccent);
  int _counter = 0;

  void _resetCounter() {
    setState(() {
      _counter = 0;
      for (int i = 0; i < 10; i++) {
        _squares[i] = Colors.redAccent;
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter < 1) {
        _resetCounter();
      } else {
        _squares[_counter - 1] = Colors.redAccent;
        _counter--;
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      if (_counter > 9) {
        _resetCounter();
      }
      _squares[_counter] = Colors.green;
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 5,
                      offset: Offset(1.3, 2),
                    ),
                  ],
                )),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
              textScaleFactor: _counter.toDouble(),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 10,
              children: List.generate(
                10,
                (index) => GestureDetector(
                  onTap: () => setState(() {
                    _counter = index + 1;
                    for (int i = 0; i < 10; i++) {
                      i < _counter
                          ? _squares[i] = Colors.green
                          : _squares[i] = Colors.redAccent;
                    }
                  }),
                  child: Container(
                    color: _squares[index],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(
            width: 40,
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 40,
          ),
          FloatingActionButton(
            onPressed: _resetCounter,
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
