import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertest/home_screen.dart';
import 'package:fluttertest/shape_model.dart';
import 'package:fluttertest/shape_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shake/shake.dart';

class HomeTab extends StatefulWidget {
  final HomeScreenTab tab;

  const HomeTab({super.key, required this.tab});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  final shapeList = <ShapeModel>[];

  @override
  void initState() {
    super.initState();
    ShakeDetector.autoStart(onPhoneShake: () {
      setState(() {
        shapeList.clear();
      });
    });
  }

  void _onTapScreen(Offset offset) async {
    final shape = _getRandomShape();
    final size = _getRandomSize();
    Map<String, dynamic>? data;
    final model = ShapeModel(
        dx: offset.dx,
        dy: offset.dy,
        data: data,
        shape: shape,
        size: size,
        scale: 1);
    _getShapeData(shape).then((value) {
      setState(() {
        model.data = value;
      });
    });
    shapeList.add(model);
    setState(() {});
  }

  Future<Map<String, dynamic>> _getShapeData(ShapeType shape) async {
    Map<String, dynamic> data = {};
    var client = http.Client();
    try {
      final response = await client.get(Uri.parse(shape.url));
      final body = json.decode(response.body);
      if (body is List) {
        data = body.first;
      }
    } catch (e) {
    } finally {
      client.close();
    }
    return data;
  }

  List<Widget> _buildShapes() {
    final widgets = <Widget>[];
    shapeList.forEach((shape) {
      widgets.add(Positioned(
        left: shape.dx - ((shape.size * shape.scale) / 2),
        top: shape.dy - ((shape.size * shape.scale) / 2),
        child: _getShape(shape),
      ));
    });
    return widgets;
  }

  ShapeType _getRandomShape() {
    var shapes = widget.tab.shapes;
    final randomIndex =
        shapes.length == 1 ? 0 : Random().nextInt(shapes.length);
    return shapes[randomIndex];
  }

  double _getRandomSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    final minWidth = (screenWidth * 0.1).toInt();
    final maxWidth = (screenWidth * 0.45).toInt();
    return (minWidth + Random().nextInt(maxWidth - minWidth)).toDouble();
  }

  Widget _getShape(ShapeModel model) {
    return ShapeWidget(
      model: model,
      onDoubleTap: () => _reloadShapeData(model),
      onUpdateOffset: (offset) => _updateOffset(model, offset),
      onScaleUpdate: (scale) => _updateScale(model, scale),
    );
  }

  void _updateOffset(ShapeModel model, Offset offset) {
    final appBarHeight = Scaffold.of(context).appBarMaxHeight?.toDouble() ?? 0;
    setState(() {
      // model.dx = (model.size / 2) + offset.dx;
      // model.dy = (model.size / 2) + offset.dy - appBarHeight;
      model.dx = offset.dx;
      model.dy = offset.dy - appBarHeight;
    });
  }

  void _updateScale(ShapeModel model, double scale) {
    setState(() {
      model.scale = scale;
    });
  }

  void _reloadShapeData(ShapeModel model) async {
    model.data = {};
    setState(() {});
    final newData = await _getShapeData(model.shape);
    model.data = newData;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Stack(children: _buildShapes()),
        GestureDetector(
          onTapUp: (details) {
            _onTapScreen(details.localPosition);
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
