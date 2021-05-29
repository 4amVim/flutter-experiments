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
    required int counter,
    Key? key,
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
          Container(height: 15, child: ProgressWidget(_counter, divisions: 5)),
          Text('You have pushed the button this many times:'),
          Text('$_counter', style: Theme.of(context).textTheme.headline4),
        ]));
  }
}

class ProgressWidget extends StatefulWidget {
  final double width;
  final int scale;
  final double height;
  final int divisions;

  ProgressWidget(this.scale,
      {required this.divisions,
      this.height = double.infinity,
      this.width = double.infinity});

  @override
  _ProgressWidgetState createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget>
    with SingleTickerProviderStateMixin {
  final double _rounding = 5;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (_, constraints) => Stack(
          children: [
            Container(
              height: widget.height,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey[400]!, width: 1),
                  borderRadius: BorderRadius.circular(100)),
              alignment: Alignment.centerLeft,
              child: AnimatedSize(
                  vsync: this,
                  duration: Duration(seconds: 2),
                  curve: Curves.easeInOutSine,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(_rounding)),
                    width:
                        widget.scale * constraints.maxWidth / widget.divisions,
                  )),
            ),
            ...List<Widget>.generate(
                widget.divisions - 1,
                (i) => Positioned(
                      top: 0,
                      bottom: 0,
                      left: (i + 1) * constraints.maxWidth / widget.divisions,
                      child:
                          Container(width: 2, color: Colors.grey.withAlpha(40)),
                    )),
          ],
        ),
      );
}
