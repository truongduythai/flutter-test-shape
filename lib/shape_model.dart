import 'package:fluttertest/home_screen.dart';
import 'package:fluttertest/utils.dart';

class ShapeModel {
  double dx;
  double dy;
  ShapeType shape;
  Map<String, dynamic>? data;
  double size;
  double scale;
  final baseColor = randomColor();

  ShapeModel({
    required this.dx,
    required this.dy,
    required this.shape,
    required this.data,
    required this.size,
    required this.scale,
  });
}
