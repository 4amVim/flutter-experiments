import 'package:boxy/flex.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage());
}

class MyHomePage extends StatefulWidget {
  MyHomePage();
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    print('rebuild scaffold');
    return Scaffold(
      appBar: AppBar(title: Text('Hi')),
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
  const Page({
    Key? key,
    required int counter,
  })  : _counter = counter,
        super(key: key);

  final int _counter;

  @override
  Widget build(BuildContext context) {
    print('rebuild Page');
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          ProgressWidget(_counter),
          Text('You have pushed the button this many times:'),
          Text('$_counter', style: Theme.of(context).textTheme.headline4),
          BoxyRow(
            children: [],
          )
        ]));
  }
}

class ProgressWidget extends StatefulWidget {
  ProgressWidget(this.scale);
  final int scale;

  @override
  _ProgressWidgetState createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    print('redrew ?');
    var _counter = widget.scale;
    return Container(
        padding: EdgeInsets.zero,
        width: 300,
        height: 200,
        decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey, width: 5),
            borderRadius: BorderRadius.circular(5)),
        child: SizedBox(
          height: 200,
          child: Container(
            color: Colors.blue,
            height: 200,
            // child: AnimatedSize(
            //   vsync: this,
            //   duration: Duration(seconds: 1),
              child: SizedBox(
                width: 2.0 * _counter / 5,
                // height: 5,
                child: Container(
                  color: Colors.green,
                ),
              ),
            // ),
          ),
        ));
  }
}
