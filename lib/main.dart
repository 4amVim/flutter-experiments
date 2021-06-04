import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'customs.dart';
import 'tape_measure.dart';

void main() => runApp(ProviderScope(child: MyApp()));

final _pageNum = StateProvider<int>((_) => 0);

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

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 700));
  // ..repeat(reverse: true);
  late final CurvedAnimation _animation = CurvedAnimation(
      parent: _controller, curve: Curves.fastLinearToSlowEaseIn);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _prev = pageList.first;
  Widget _curr = pageList.first;
  Widget _next = pageList[1];
  @override
  Widget build(BuildContext context) {
    print('initialized');

    int pagenum = context.read(_pageNum).state;
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
                      child: ProgressWidget(watch(_pageNum).state,
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
                      if (watch(_pageNum).state > 1) {
                        context.read(_pageNum).state--;
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
                          (watch(_pageNum).state).toString() +
                          '/${pageList.length}',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                    Spacer(flex: 5),
                    Expanded(
                        flex: 150,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (_, __) => Stack(
                            children: [
                              Positioned.fill(
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                          begin: Offset(-1, 0),
                                          end: _controller.status ==
                                                  AnimationStatus.reverse
                                              ? Offset.zero
                                              : Offset(-1, 0))
                                      .animate(CurvedAnimation(
                                          parent: _controller,
                                          curve: Curves.easeInCirc,
                                          reverseCurve: Curves.easeOutCirc)),
                                  child: RepaintBoundary(
                                    child: Container(
                                        color: Colors.blue,
                                        child: Opacity(
                                          opacity: 0.3,
                                          child: _prev,
                                        )),
                                  ), //  child,
                                ),
                              ),
                              Positioned.fill(
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                          begin: Offset.zero,
                                          end: Offset(
                                              _controller.status ==
                                                      AnimationStatus.forward
                                                  ? -1
                                                  : _controller.status ==
                                                          AnimationStatus
                                                              .reverse
                                                      ? 1
                                                      : 0,
                                              0))
                                      .animate(CurvedAnimation(
                                          parent: _controller,
                                          curve: Curves.easeInCirc,
                                          reverseCurve: Curves.easeOutCirc)),
                                  child: RepaintBoundary(
                                    child: Container(
                                        color: Colors.green,
                                        child: Opacity(
                                          opacity: 0.3,
                                          child: _curr,
                                        )),
                                  ), //  child,
                                ),
                              ),
                              Positioned.fill(
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                          begin: Offset(1, 0),
                                          end: _controller.status ==
                                                  AnimationStatus.forward
                                              ? Offset.zero
                                              : Offset(1, 0))
                                      .animate(CurvedAnimation(
                                          parent: _controller,
                                          curve: Curves.easeOutSine,
                                          reverseCurve: Curves.easeOutCirc)),
                                  child: Container(
                                      color: Colors.red,
                                      child: Opacity(
                                        opacity: 0.3,
                                        child: _next,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Spacer(flex: 50),
                    NavigateButton(
                        onPressed: () {
                          print('im here');
                          var pageNum = context.read(_pageNum).state;
                          print('current page $pageNum');
                          if (pageNum < pageList.length-1) {
                            watch(_pageNum).state++;
                            pageNum++;
                            print('increased $pageNum');
                            _controller.forward(from: 0).then((value) {
                              setState(() {
                                // debugger();
                                _prev = pageList[pageNum - 1];
                                // debugger();
                                _curr = pageList[pageNum];
                                // debugger();
                                print('chenged ');
                                if (++pageNum < pageList.length) {
                                  _next = pageList[pageNum];
                                  print('set next to $pageNum');
                                  // debugger();
                                }
                                _controller.reset();
                              });
                            });
                          }
                          print('-----------------------------');
                        },
                        text: 'Continue'),
                    NavigateButton(
                        onPressed: () {
                          print('im here');
                          var pageNum = context.read(_pageNum).state;
                          print('current page $pageNum');
                          if (pageNum > 0) {
                            watch(_pageNum).state--;
                            pageNum--;
                            print('decreased $pageNum');
                            _controller.reverse(from: 0).then((value) {
                              // debugger();
                              setState(() {
                                _next = pageList[pageNum + 1];
                                // debugger();
                                _curr = pageList[pageNum];
                                // debugger();
                                print('chenged ');
                                if (--pageNum > 0) {
                                  _prev = pageList[pageNum - 1];
                                  print('set prev to $pageNum');
                                  // debugger();
                                }
                                _controller.reset();
                              });
                            });
                          }
                          print('-----------------------------');
                        },
                        text: 'skip',
                        highlight: false),
                    Spacer(flex: 2)
                  ]),
            ));
  }

  static final List<Widget> pageList = [
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
        children: const [
          Text('bottom button'),
          Image(image: AssetImage('assets/undraw/bitmap/water_bottle.png')),
        ],
      ),
    ),
    ConstrainedBox(
      key: ValueKey(2),
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('bottom button'),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(),
              clipBehavior: Clip.hardEdge,
              child: TryingWidget(),
            ),
          )
        ],
      ),
    ),
  ];
}

class TryingWidget extends StatefulWidget {
  @override
  _TryingWidgetState createState() => _TryingWidgetState();
}

class _TryingWidgetState extends State<TryingWidget> {
  String _debugText = 'Go on do it!';
  late Offset touchStart;
  TapeMeasurePaint? tape;

  bool _isRetardUnits = false; //widget.isRetardUnits;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        print(
            'Max Width: ${constraints.maxWidth} and Max Height: ${constraints.maxHeight}');
        var width = constraints.maxWidth / 3;
        var height = constraints.maxHeight;
        tape ??= TapeMeasurePaint(width, height);

        return Stack(
          fit: StackFit.expand,
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
                  child: SizedBox(width: width, height: height),
                ),
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
      }); //));
}
