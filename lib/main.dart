import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'customs.dart';

void main() => runApp(ProviderScope(child: MyApp()));

final myProvider = StateProvider((_) => 0);

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
  @override
  Widget build(BuildContext context) {
    print('rebuild scaffold');
    return Consumer(
        builder: (BuildContext context,
                T Function<T>(ProviderBase<Object?, T>) watch, Widget? child) =>
            Scaffold(
              appBar: AppBar(
                title: Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: 15,
                      alignment: Alignment.center,
                      child: ProgressWidget(watch(myProvider).state,
                          divisions: 5)),
                ),
                actions: [
                  BackButton(onPressed: () {}, color: Colors.transparent)
                ],
                leading: BackButton(
                    onPressed: () => context.read(myProvider).state--,
                    color: Colors.black),
                backgroundColor: Theme.of(context).canvasColor,
                elevation: 0,
              ),
              body: Page(counter: watch(myProvider).state),
              floatingActionButton: FloatingActionButton(
                onPressed: () => context.read(myProvider).state++,
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ), // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}

class Page extends StatefulWidget {
  Page({required int counter}) : _counter = counter;

  int _counter;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    print('rebuild Page');
    return Consumer(
      builder: (BuildContext context,
              T Function<T>(ProviderBase<Object?, T>) watch, Widget? child) =>
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('You have pushed the button this many times:'),
              ],
            ),
            Text('${widget._counter}',
                style: Theme.of(context).textTheme.headline4),
            Spacer(flex: 50),
            NavigateButton(
                onPressed: () {
                  context.read(myProvider).state++;
                },
                text: 'skip'),
            NavigateButton(onPressed: () {}, text: 'skip', highlight: false),
            Spacer(flex: 2)
          ]),
    );
  }
}

class NavigateButton extends StatelessWidget {
  final String text;
  final highlight;
  final void Function()? onPressed;
  NavigateButton(
      {required this.onPressed, required this.text, this.highlight = true});
  @override
  Widget build(BuildContext context) {
    const txtStyle = TextStyle(fontSize: 15);

    var textStyle =
        highlight ? txtStyle.copyWith(color: Colors.white) : txtStyle;

    final child = Padding(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Text(text, style: textStyle),
    );

    var style = highlight
        ? ElevatedButton.styleFrom(
            primary: Colors.deepPurpleAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
          )
        : TextButton.styleFrom(
            primary: Colors.deepPurpleAccent,
          );

    return highlight
        ? ElevatedButton(onPressed: onPressed, style: style, child: child)
        : TextButton(onPressed: onPressed, style: style, child: child);
  }
}
