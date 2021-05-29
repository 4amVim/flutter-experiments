import 'package:flutter/material.dart';

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
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOutSine,
                    color: Colors.green,
                    width:
                        widget.scale * constraints.maxWidth / widget.divisions,
                  )),
              ...List<Widget>.generate(
                  widget.divisions - 1,
                  (i) => Positioned(
                        top: 0,
                        bottom: 0,
                        left: (i + 1) * constraints.maxWidth / widget.divisions,
                        child: ClipRRect(
                          child: Container(
                            color: Colors.grey.withAlpha(400),
                            width: 2,
                          ),
                        ),
                      )),
            ],
          ));
}
