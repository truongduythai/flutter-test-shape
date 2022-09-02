import 'package:flutter/material.dart';
import 'package:fluttertest/circle.dart';
import 'package:fluttertest/home_screen.dart';
import 'package:fluttertest/shape_model.dart';
import 'package:fluttertest/square.dart';
import 'package:fluttertest/triangle.dart';

class ShapeWidget extends StatefulWidget {
  final ShapeModel model;
  final Function() onDoubleTap;
  final Function(Offset) onUpdateOffset;
  final Function(double) onScaleUpdate;

  const ShapeWidget({
    Key? key,
    required this.model,
    required this.onDoubleTap,
    required this.onUpdateOffset,
    required this.onScaleUpdate,
  }) : super(key: key);

  @override
  State<ShapeWidget> createState() => _ShapeWidgetState();
}

class _ShapeWidgetState extends State<ShapeWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: widget.onDoubleTap,
      onScaleEnd: (details) {
        widget.model.size = widget.model.size * widget.model.scale;
        widget.model.scale = 1;
      },
      onScaleUpdate: (details) {
        widget.onScaleUpdate.call(details.scale);
      },
      onLongPressMoveUpdate: (details) {
        widget.onUpdateOffset.call(details.globalPosition);
      },
      child: _getShape(),
    );
  }

  Widget _getShape() {
    Widget widget;
    switch (this.widget.model.shape) {
      case ShapeType.square:
        widget = SquareWidget(model: this.widget.model);
        break;
      case ShapeType.circle:
        widget = CircleWidget(model: this.widget.model);
        break;
      case ShapeType.triangle:
        widget = TriangleWidget(model: this.widget.model);
        break;
    }
    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.elasticOut)),
      child: SizedBox(
        width: this.widget.model.size * this.widget.model.scale,
        height: this.widget.model.size * this.widget.model.scale,
        child: widget,
      ),
    );
  }
}
