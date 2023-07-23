

import 'package:dotted_border/dash_painter.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class AnimationDottedBorder extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets borderPadding;
  final double strokeWidth;
  final Color color;
  final List<double> dashPattern;
  final BorderType borderType;
  final Radius radius;
  final StrokeCap strokeCap;
  final PathBuilder? customPath;

  const AnimationDottedBorder({
    Key? key,
    required this.child,
    this.color = Colors.black,
    this.strokeWidth = 1,
    this.borderType = BorderType.Rect,
    this.dashPattern = const <double>[3, 1],
    this.padding = const EdgeInsets.all(2),
    this.borderPadding = EdgeInsets.zero,
    this.radius = const Radius.circular(0),
    this.strokeCap = StrokeCap.butt,
    this.customPath,
  }) : super(key: key);

  @override
  State<AnimationDottedBorder> createState() => _AnimationDottedBorderState();
}

class _AnimationDottedBorderState extends State<AnimationDottedBorder> with SingleTickerProviderStateMixin{
  late final AnimationController _controller;
  /// Compute if [dashPattern] is valid. The following conditions need to be met
  /// * Cannot be null or empty
  /// * If [dashPattern] has only 1 element, it cannot be 0
  bool _isValidDashPattern(List<double>? dashPattern) {
    Set<double>? _dashSet = dashPattern?.toSet();
    if (_dashSet == null) return false;
    if (_dashSet.length == 1 && _dashSet.elementAt(0) == 0.0) return false;
    if (_dashSet.length == 0) return false;
    return true;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(); 
  }

  @override
  Widget build(BuildContext context) {
    assert(_isValidDashPattern(widget.dashPattern), 'Invalid dash pattern');

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.141592,
                child: CustomPaint(
                  painter: DashPainter(
                    padding: widget.borderPadding,
                    strokeWidth: widget.strokeWidth,
                    radius: widget.radius,
                    color: widget.color,
                    borderType: widget.borderType,
                    dashPattern: widget.dashPattern,
                    customPath: widget.customPath,
                    strokeCap: widget.strokeCap,
                  ),
                )
              );
            },
          ),
        ),
        Padding(
          padding: widget.padding,
          child: widget.child,
        ),
      ],
    );
  }
}