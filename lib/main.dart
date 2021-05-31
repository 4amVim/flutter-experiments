import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'customs.dart';

void main() => runApp(ProviderScope(child: MyApp()));

final pageNumberProvider = StateProvider<int>((_) => 0);
final isForward = StateProvider<bool>((_) => true);

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
                      child: ProgressWidget(watch(pageNumberProvider).state,
                          divisions: pageList.length)),
                ),
                actions: [
                  BackButton(onPressed: () {}, color: Colors.transparent)
                ],
                leading: BackButton(
                    onPressed: () {
                      context.read(isForward).state = false;
                      watch(pageNumberProvider).state > 0
                          ? context.read(pageNumberProvider).state--
                          : null;

                    },
                    color: Colors.black),
                backgroundColor: Theme.of(context).canvasColor,
                elevation: 0,
              ),
              body: Column(
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
                    Text(watch(pageNumberProvider).state.toString(),
                        style: Theme.of(context).textTheme.headline4),
                    AnimatedSwitcher(
                        duration: Duration(seconds: 1),
                        transitionBuilder: (child, animation) {
                          int currentKey = int.tryParse(child.key
                                      ?.toString()
                                      .replaceAll(RegExp(r'[\]\[<>]*'), '') ??
                                  '') ??
                              500;

                          //?Convoluted way to ensure the page animates towards the right direction
                          double currentOffset;
                          if (watch(isForward).state) {
                            currentOffset =
                                watch(pageNumberProvider).state > currentKey
                                    ? -5.0
                                    : 5.0;
                          } else {
                            currentOffset =
                                watch(pageNumberProvider).state >= currentKey
                                    ? -5.0
                                    : 5.0;
                          }

                          return SlideTransition(
                            position: Tween<Offset>(
                                    begin: Offset(currentOffset, 0),
                                    end: Offset.zero)
                                .animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.fastLinearToSlowEaseIn)),
                            child: child,
                          );
                        },
                        child: pageList[watch(pageNumberProvider).state]),
                    Spacer(flex: 50),
                    NavigateButton(
                        onPressed: () {
                          context.read(isForward).state = true;
                          watch(pageNumberProvider).state + 1 < pageList.length
                              ? context.read(pageNumberProvider).state++
                              : null;
                        },
                        text: 'Continue'),
                    NavigateButton(
                        onPressed: () {
                          context.read(isForward).state = false;
                          watch(pageNumberProvider).state > 0
                              ? context.read(pageNumberProvider).state--
                              : null;
                        },
                        text: 'skip',
                        highlight: false),
                    Spacer(flex: 2)
                  ]),
            ));
  }

  // A list of the middle content for onboarding pages
  //! You need to provide a unique value key
  final List<Widget> pageList = [
    Container(
      key: ValueKey(0),
      // color: Theme.of(context).canvasColor,
      child: Column(
        children: const [
          Text('top button'),
          Image(image: AssetImage('assets/undraw/bitmap/hiking.png')),
        ],
      ),
    ),
    Container(
      key: ValueKey(1),
      // color: Theme.of(context).canvasColor,
      child: Column(
        children: [
          Text('bottom button'),
          Image(image: AssetImage('assets/undraw/bitmap/water_bottle.png')),
        ],
      ),
    ),
    Container(
      key: ValueKey(2),
      // color: Theme.of(context).canvasColor,
      child: Column(
        children: [
          Text('bottom button'),
          Image(image: AssetImage('assets/undraw/bitmap/tracker.png')),
        ],
      ),
    )
  ];
}
