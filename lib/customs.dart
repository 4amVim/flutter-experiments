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
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey[300]!, width: 1),
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
                            color: Colors.grey.withAlpha(60),
                            width: 2,
                          ),
                        ),
                      )),
            ],
          ));
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

    // Color color = Theme.of(context).primaryColor;

    return highlight
        ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                // primary: color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0),
            child: child)
        : TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              // primary: color,
            ),

            child: child);
  }
}
