import 'package:flutter/material.dart';

import 'customs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage());
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);
  void _decrementCounter() => setState(() => _counter--);

  @override
  Widget build(BuildContext context) {
    print('rebuild scaffold');
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi'),
        leading: BackButton(onPressed: () => _decrementCounter()),
      ),
      body: Page(counter: _counter),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Page extends StatelessWidget {
  const Page({required int counter}) : _counter = counter;

  final int _counter;

  @override
  Widget build(BuildContext context) {
    print('rebuild Page');
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Container(height: 15, child: ProgressWidget(_counter, divisions: 5)),
          Text('You have pushed the button this many times:'),
          Text('$_counter', style: Theme.of(context).textTheme.headline4),
        ]));
  }
}
