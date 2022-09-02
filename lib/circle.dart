import 'package:flutter/material.dart';
import 'package:fluttertest/shape_model.dart';
import 'package:fluttertest/utils.dart';

class CircleWidget extends StatelessWidget {
  final ShapeModel model;

  const CircleWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: model.data?['hex'] == null
            ? model.data == null
                ? Colors.grey[300]
                : model.baseColor
            : hexToColor('#${model.data?['hex']}'),
      ),
    );
  }
}
