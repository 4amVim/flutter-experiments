import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:starter/tapeMeasure.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: OnboardingPage());
}

class OnboardingPage extends StatefulWidget {
  OnboardingPage();
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  String _debugText = 'Go on do it!';
  late Offset touchStart;
  TapeMeasurePaint? tape;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('Swipe vertically')),
      body: Center(
          child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) =>
                      ColoredBox(
                          color: Colors.blue,
                          child: Stack(children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Tape(
                                  width: constraints.maxWidth / 3,
                                  height: constraints.maxHeight),
                            ),
                            Positioned(
                                left: constraints.maxWidth / 3,
                                top: constraints.maxHeight / 2,
                                right: 0,
                                child: Text(_debugText,
                                    softWrap: true,
                                    style: TextStyle(fontSize: 45))),
                          ]))))));

  //Returns a vertical tape of specified size
  Widget Tape({required double width, required double height}) {
    tape ??= TapeMeasurePaint(width, height);
    return Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (details) => touchStart = details.localPosition,
        onPointerMove: (details) => setState(() {
              tape!.offsetBy((details.localPosition.dy - touchStart.dy));
              _debugText = tape!.reading;
            }),
        onPointerUp: (_) => tape!.shiftStart(),
        child: CustomPaint(
            painter: tape, child: SizedBox(width: width, height: height)));
  }
}
