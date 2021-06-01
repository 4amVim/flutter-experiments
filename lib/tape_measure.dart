import 'dart:math';
import 'package:flutter/material.dart';

///Draws a vertical tape measure that gives a measurment [rawReading]
class TapeMeasurePaint extends CustomPainter {
  //*Color for the tape's background
  static const _color = Colors.blue;
  static const _ticksColor = Colors.black;
  static const _arrowNotTouchedColor = Color(0xFFFFFFFF);
  static const _arrowTouchedColor = Color(0xCFFFFFFF);
  static const _textColor = Colors.red;

  ///Instantaneous, scaled offset of the tape
  double _offset = 0;

  ///Instantaneous, unscaled persistent offset of the tape
  double _rawStart = 0;
  //? 2 for tens, 1 for each unit and 7 for each of the 10 spaces

  ///Height of the canvas
  final double width;

  ///This is the unit height, we paint everything based on this
  late final double _unit;

  ///size for the marking of one-tenth size
  late final double _tenthSize;

  ///size for the marking of one size
  late final double _oneSize;

  ///size for the gap between any two markings
  late final double _gapSize;

  ///Create a vertically scrollable TapeMeasure with the given [width],[height]
  ///and optionally, the relative thickness of the tenth's marking [tens],
  ///one's marking [one], gap size [gap] and [howMany] units to display at once
  TapeMeasurePaint(this.width, double height,
      {double tens = 1, double ones = 2, double gap = 7, int howMany = 5})
      : _unit = (height) / (((ones + 9 * tens + 10 * gap)) * howMany) {
    _tenthSize = tens * _unit;
    _oneSize = ones * _unit;
    _gapSize = gap * _unit;
  }

  ///Raw reading, basically for internal use only
  double get rawReading => (_offset + _start) / _unit;

  ///gets current reading of the tape measure
  String get reading => (((rawReading) / -81) + 1.7).toStringAsFixed(1);

  // double get _offset => _rawOffset / _unit;

  double get _start {
    if (_rawStart == 0) _rawStart = -7963 * _unit * _unit;
    return _rawStart / _unit;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas //? Color the background, centre x-axis and do x-translation
      ..drawRect(Offset.zero & size, Paint()..color = _color)
      ..save() //? We're saving basic state for later when we draw an arrow
      ..translate(size.width, .0) //? Vertically centre the x-axis
      ..translate(0, _start) //? Offset the start (to persist between touches)
      ..translate(0, _offset) //? immidiate offset for current fingering
      ..rotate(pi / 2); //* remember that hereon the axes are switched

    ///Add [howMany] number of segments to the tape
    Canvas _addSegmentsAbove(Canvas cvs, int howMany, bool showText) {
      //* Some functions to ease modigying drawing bit
      //Draw longer lines for tens

      //Label them
      double fontSize = 40; //size.width*0.2>
      void tensText(double xOffset, int no) => TextPainter(
          text: TextSpan(
              text: no.toString(),
              style: TextStyle(fontSize: fontSize, color: _textColor)),
          textDirection: TextDirection.ltr)
        ..layout(minWidth: size.width * 0.2, maxWidth: size.width * 0.8)
        ..paint(cvs, Offset(-0.65 * size.width, xOffset - 0.04 * size.width));

      //* Draw segments
      cvs.save();
      for (var no = 0; no < howMany; no++) {
        var ticksColor = Paint()..color = _ticksColor;
        //* Draw a segment
        cvs.drawRect(
            Offset.zero & Size(_oneSize, 0.35 * size.width), ticksColor);
        cvs.translate(_oneSize, 0);
        if (showText) {
          cvs.rotate(-pi / 2);
          tensText(0, no);
          cvs.rotate(pi / 2);
        }
        for (var i = 1; i <= 9; i++) {
          cvs.drawRect(
              Offset(i * _gapSize + (i - 1) * _tenthSize, 0) &
                  Size(_tenthSize, .15 * size.width),
              ticksColor);
        }
        cvs.translate(10 * _gapSize + 9 * _tenthSize, 0);
      }
      return cvs..restore();
    }

    _addSegmentsAbove(canvas, 250, true);

    Matrix4 poka = Matrix4.translationValues(0, size.width, 0)
      ..scale(1.0, -1.0, 1.0);
    canvas.transform(poka.storage);

    _addSegmentsAbove(canvas, 250, false);

    var arrowPath = Path()
      ..addRect(Offset(size.width / 2, size.height / 3) &
          Size(size.width, size.height / 80))
      ..lineTo(size.width / 2, -20 + size.height / 3) //?Line up
      ..lineTo(-30 + size.width / 2, (163 * size.height / 480))
      ..lineTo(size.width / 2, 20 + (83 * size.height / 240));
    canvas
      ..restore()
      ..save()
      //?If user is scrolling, have the arrow slightly more to the right
      ..translate(-10, 0)
      //?If user is scrolling, have the arrow slightly more opaque
      ..drawPath(
          arrowPath,
          Paint()
            ..color =
                _offset.abs() < 15 ? _arrowNotTouchedColor : _arrowTouchedColor)
      ..restore();
  }

  @override
  bool shouldRepaint(TapeMeasurePaint oldDelegate) => false;

  ///Move the tape up/down ephemerally
  void offsetBy(double displacement) => _offset = displacement / _unit;

  ///Move the tape up/down persistent-ly
  void shiftStart() {
    _rawStart = _offset * _unit + _rawStart;
    _offset = 0;
  }
}
