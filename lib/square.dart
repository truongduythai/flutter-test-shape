import 'package:flutter/material.dart';
import 'package:fluttertest/shape_model.dart';

class SquareWidget extends StatelessWidget {
  final ShapeModel model;

  const SquareWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: model.data?['imageUrl'] == null
          ? Container(
              color: model.data == null ? Colors.grey[300] : model.baseColor,
            )
          : Image.network(
              model.data?['imageUrl'] ?? '',
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: model.baseColor);
              },
            ),
    );
  }
}
