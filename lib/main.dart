import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'customs.dart';
import 'tape_measure.dart';

void main() => runApp(ProviderScope(child: MyApp()));

final pageNumberProvider = StateProvider<int>((_) => 1);
final isForward = StateProvider<bool>((_) => true);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: OnboardingPage());
}

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
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
                  BackButton(
                      onPressed: null,
                      color: Colors
                          .transparent) //This is here just to make sure the progress bar is perfectly centered
                ],
                leading: BackButton(
                    onPressed: () {
                      context.read(isForward).state = false;
                      if (watch(pageNumberProvider).state > 1) {
                        context.read(pageNumberProvider).state--;
                      } else {
                        print('should go back to intro page');
                        //TODO Add a bit here to pop back to the introduction screen
                      }
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
                    Text(
                      'Step ' +
                          (watch(pageNumberProvider).state).toString() +
                          '/${pageList.length}',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                    Spacer(flex: 5),
                    AnimatedSwitcher(
                        duration: Duration(seconds: 1),
                        // layoutBuilder: (Widget? chil, List<Widget> koko) {
                        //   print('ads');
                        //   return RepaintBoundary(
                        //     // color: Colors.red,
                        //     // width: 500,
                        //     // height: 50,
                        //     child: chil,
                        //   );
                        // },
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
                                watch(pageNumberProvider).state - 1 > currentKey
                                    ? -5.0
                                    : 5.0;
                          } else {
                            currentOffset =
                                watch(pageNumberProvider).state - 1 >=
                                        currentKey
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
                        child: pageList[watch(pageNumberProvider).state - 1]),
                    Spacer(flex: 50),
                    NavigateButton(
                        onPressed: () {
                          context.read(isForward).state = true;
                          watch(pageNumberProvider).state < pageList.length
                              ? context.read(pageNumberProvider).state++
                              : null;
                        },
                        text: 'Continue'),
                    NavigateButton(
                        onPressed: () {
                          context.read(isForward).state = false;
                          watch(pageNumberProvider).state > 1
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
  //! You need to keep incrementing the value key
  final List<Widget> pageList = [
    Container(
      key: ValueKey(0),
      color: Colors.grey[350],
      child: Column(
        children: const [
          Text('top button'),
          Image(image: AssetImage('assets/undraw/bitmap/hiking.png')),
        ],
      ),
    ),
    Container(
      color: Colors.white,
      key: ValueKey(1),
      child: Column(
        children: [
          Text('bottom button'),
          Image(image: AssetImage('assets/undraw/bitmap/water_bottle.png')),
        ],
      ),
    ),
    Container(
      key: ValueKey(2),
      color: Colors.white,
      child: Column(
        children: [
          Text('bottom button'),
          Container(
            decoration: BoxDecoration(),
            clipBehavior: Clip.hardEdge,
            child: TryingWidget(
              isRetardUnits: true,
            ),
          )
        ],
      ),
    )
  ];
}

class TryingWidget extends StatefulWidget {
  final bool isRetardUnits;

  const TryingWidget({Key? key, this.isRetardUnits = false}) : super(key: key);

  @override
  _TryingWidgetState createState() => _TryingWidgetState();
}

class _TryingWidgetState extends State<TryingWidget> {
  String _debugText = 'Go on do it!';
  late Offset touchStart;
  TapeMeasurePaint? tape;

  bool _isRetardUnits = false; //widget.isRetardUnits;
  @override
  Widget build(BuildContext context) => SizedBox(
      width: 500, // double.infinity,
      height: 500, //double.infinity,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var width = constraints.maxWidth / 3;
        var height = constraints.maxHeight;
        tape ??= TapeMeasurePaint(width, height);

        return Stack(
          children: [
            //? This paints the tape-measure
            Positioned(
              left: constraints.maxWidth / 8,
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (details) => touchStart = details.localPosition,
                onPointerMove: (details) => setState(() {
                  tape!.offsetBy(details.localPosition.dy - touchStart.dy);
                  double inches = (double.parse(tape!.reading) / 2.54);
                  _debugText = _isRetardUnits
                      ? '${inches ~/ 12}feet ${(inches % 12).toStringAsFixed(1)}in'
                      : '${tape!.reading} cm';
                }),
                onPointerUp: (_) => tape!.shiftStart(),
                child: CustomPaint(
                    willChange: true,
                    painter: tape,
                    child: SizedBox(width: width, height: height)),
              ),
            ),
            //? This writes the text
            Positioned(
                left: 8 * constraints.maxWidth / 15,
                top: constraints.maxHeight / 2,
                child: Text(_debugText,
                    softWrap: true,
                    style: Theme.of(context).textTheme.headline5)),
            Positioned(
              left: 8 * constraints.maxWidth / 15,
              child: NavigateButton(
                text: 'flip unit',
                onPressed: () {
                  setState(() {
                    _isRetardUnits = !_isRetardUnits;
                  });
                },
              ),
            )
          ],
        );
      })); //));
}
