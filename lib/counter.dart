import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
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
