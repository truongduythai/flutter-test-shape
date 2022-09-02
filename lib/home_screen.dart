import 'package:flutter/material.dart';
import 'package:fluttertest/home_tab.dart';

enum ShapeType {
  square('http://www.colourlovers.com/api/patterns/random?format=json'),
  circle('http://www.colourlovers.com/api/colors/random?format=json'),
  triangle('http://www.colourlovers.com/api/colors/random?format=json');

  final String url;

  const ShapeType(this.url);
}

enum HomeScreenTab {
  square([ShapeType.square], 'Squares'),
  circle([ShapeType.circle], 'Circles'),
  triangle([ShapeType.triangle], 'Triangles'),
  all([ShapeType.square, ShapeType.circle, ShapeType.triangle], 'All');

  final List<ShapeType> shapes;
  final String label;

  const HomeScreenTab(this.shapes, this.label);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: HomeScreenTab.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
          bottom: TabBar(
            tabs: HomeScreenTab.values
                .map((tab) => Tab(text: tab.label))
                .toList(),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children:
              HomeScreenTab.values.map((tab) => HomeTab(tab: tab)).toList(),
        ),
      ), //
      // ailing comma makes auto-formatting nicer for build methods.
    );
  }
}
