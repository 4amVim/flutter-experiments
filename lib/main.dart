import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'customs.dart';
import 'tape_measure.dart';

void main() => runApp(ProviderScope(child: MyApp()));

final _pageNum = StateProvider<int>((_) => 1);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: OnboardingPage());
}

class UserData {
  static final Map<String, String> map = {};
}

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 900));
  late final CurvedAnimation _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCirc,
      reverseCurve: Curves.easeOutCirc.flipped);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _prev = pageList.first;
  Widget _curr = pageList.first;
  Widget _next = pageList[1];
  @override
  Widget build(BuildContext context) => Consumer(
      builder: (BuildContext context,
              T Function<T>(ProviderBase<Object?, T>) watch, Widget? child) =>
          Scaffold(
            resizeToAvoidBottomInset: false,
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
                    } else {
                      print('should go back to intro page');
                      //TODO Add a bit here to pop back to the introduction screen
                    }
                    print(UserData.map);
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
                      flex: 180,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: SlideTransition(
                              position: Tween<Offset>(
                                      end: Offset(-1, 0),
                                      begin: _controller.status ==
                                              AnimationStatus.reverse
                                          ? Offset.zero
                                          : Offset(-1, 0))
                                  .animate(_animation),
                              child: _prev, //  child,
                            ),
                          ),
                          Positioned.fill(
                            child: SlideTransition(
                              position: Tween<Offset>(
                                      begin: Offset(
                                          _controller.status ==
                                                  AnimationStatus.forward
                                              ? 0
                                              : _controller.status ==
                                                      AnimationStatus.reverse
                                                  ? 1
                                                  : 0,
                                          0),
                                      end: Offset(
                                          _controller.status ==
                                                  AnimationStatus.forward
                                              ? -1
                                              : _controller.status ==
                                                      AnimationStatus.reverse
                                                  ? 0
                                                  : 0,
                                          0))
                                  .animate(_animation),
                              child: _curr, //  child,
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
                                  .animate(_animation),
                              child: _next,
                            ),
                          ),
                        ],
                      )),
                  Spacer(flex: 25),
                  NavigateButton(
                      onPressed: _controller.isAnimating
                          ? null
                          : () {
                              var index = context.read(_pageNum).state - 1;
                              if (index < pageList.length - 1) {
                                watch(_pageNum).state++;
                                index++;
                                _controller.forward().whenComplete(() {
                                  setState(() {
                                    _prev = pageList[index - 1];
                                    _curr = pageList[index];
                                    if (++index < pageList.length) {
                                      _next = pageList[index];
                                    }
                                    _controller.reset();
                                  });
                                });
                              }
                            },
                      text: 'Continue'),
                  NavigateButton(
                      onPressed: () {
                        var index = context.read(_pageNum).state - 1;
                        if (index > 0) {
                          watch(_pageNum).state--;
                          index--;
                          _controller.reverse(from: 1).whenComplete(() {
                            setState(() {
                              _next = pageList[index + 1];
                              _curr = pageList[index];
                              if (--index >= 0) {
                                _prev = pageList[index];
                              }
                              _controller.reset();
                            });
                          });
                        }
                      },
                      text: 'skip',
                      highlight: false),
                  Spacer(flex: 2)
                ]),
          ));

  static final firstFocus = FocusNode();
  static final secondFocus = FocusNode();
  static final List<Widget> pageList = [
    Container(
      //NamePage
      key: ValueKey(0),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Expanded(
                flex: 0,
                child: Text('Tell us about yourself',
                    style: TextStyle(fontSize: 34))),
            Expanded(
              flex: 1,
              child: Text('You can always change this later',
                  style: TextStyle(fontSize: 24, color: Colors.grey)),
            ),
            Spacer(flex: 1),
            OnboardingText(
              label: 'First Name',
              nextFocus: firstFocus,
            ),
            OnboardingText(
              label: 'Last Name',
              focusNode: firstFocus,
              nextFocus: secondFocus,
            ),
            OnboardingText(
                label: 'Username', focusNode: secondFocus, isLast: true),
            Spacer(flex: 1)

            // Image(image: AssetImage('assets/undraw/bitmap/hiking.png')),
          ],
        ),
      ),
    ),
    Container(
      //GenderPge
      color: Colors.white,
      key: ValueKey(1),
      child: Column(
        children: const [
          Text('bottom button'),
          Expanded(
              flex: 4,
              child: Image(
                  image: AssetImage('assets/undraw/bitmap/water_bottle.png'))),
        ],
      ),
    ),
    ConstrainedBox(
      //HeightPage
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
              child: RepaintBoundary(
                child: TryingWidget(),
              ),
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
  String _metricText = 'Go on do it!';
  // String _imperialText = 'Go on do it!';
  late Offset touchStart;
  TapeMeasurePaint? tape;

  bool _isRetardUnits = false; //widget.isRetardUnits;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
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
                  _metricText = _isRetardUnits
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
                child: Text(_metricText,
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
