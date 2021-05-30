import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'customs.dart';

void main() => runApp(ProviderScope(child: MyApp()));

final myProvider = StateProvider((_) => 0);
final pageContentProvider = StateProvider((_) => Text(
      'asd',
      style: TextStyle(fontSize: 75),
    ));

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
              body: PageWidget(counter: watch(myProvider).state),
            ));
  }
}

class PageWidget extends StatefulWidget {
  PageWidget({required int counter});

  @override
  _PageWidgetState createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget>
    with SingleTickerProviderStateMixin {
  // late final AnimationController _controller = AnimationController(
  //     duration: const Duration(milliseconds: 1500), vsync: this);
  // ..repeat(reverse: false);

  // late final Animation<Offset> _offsetAnimation = Tween<Offset>(
  //   begin: Offset.zero,
  //   end: const Offset(-3, 0.0),
  // ).animate(CurvedAnimation(
  //   parent: _controller,
  //   curve: Curves.easeInBack,
  // ));

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
  }

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
            Text(watch(myProvider).state.toString(),
                style: Theme.of(context).textTheme.headline4),
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              transitionBuilder: (child, animation) {
                String omg =
                    child.key.toString().replaceAll(RegExp(r'[\]\[<>]*'), '');
                debugger(when: omg.isNotEmpty);
                var ok = 0;
                if (omg != "null") {
                  ok = int.parse(omg);
                }
                print(ok);
                print(ok.runtimeType);

                return SlideTransition(
                  position:
                      Tween<Offset>(begin: Offset(-4, 0), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.fastLinearToSlowEaseIn)),
                  child: child,
                );
              },
              child: watch(pageContentProvider).state,
            ),
            Spacer(flex: 50),
            NavigateButton(
                onPressed: () {
                  context.read(pageContentProvider).state = Text(
                    'top button',
                    key: ValueKey(5),
                  );
                  context.read(myProvider).state++;
                },
                text: 'Continue'),
            NavigateButton(
                onPressed: () {
                  context.read(pageContentProvider).state = Text(
                    'bottom button',
                    key: ValueKey(-5),
                  );

                  context.read(myProvider).state--;
                },
                text: 'skip',
                highlight: false),
            Spacer(flex: 2)
          ]),
    );
  }
}
