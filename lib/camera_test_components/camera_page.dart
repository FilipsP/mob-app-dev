import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class Figure {
  String type;
  ArCoreNode node;
  Figure(this.type, this.node);
}

class Cube extends Figure {
  Cube(ArCoreNode node, ArCoreCube cube) : super('Cube', node);
}

class Sphere extends Figure {
  Sphere(ArCoreNode node, ArCoreSphere sphere) : super('Sphere', node);
}

class Cylinder extends Figure {
  Cylinder(ArCoreNode node, ArCoreCylinder cylinder) : super('Cylinder', node);
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with TickerProviderStateMixin {
  double _buttonSize = 100.0;
  bool _isCameraOn = false;
  late List<Cube> _cubes;
  late ArCoreController arCoreController;

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  void _shrinkButton() {
    setState(() {
      _buttonSize = 50.0;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _buttonSize = 100.0;
        _isCameraOn = !_isCameraOn;
      });
    });
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    for (double y = -8.0; y < 8.0; y++) {
      for (double x = -8.0; x < 8.0; x++) {
        if ((x > -2.0 && x < 2.0) && (y > -2.0 && y < 2.0)) {
          continue;
        }
        for (double z = -8.0; z < 8.0; z++) {
          if ((x == 7.0 && (y > -6.0 && y < 2.0) && (z > -2.0 && z < 2.0))) {
            continue;
          }
          if ((z > -7.0 && z < 7.0) &&
              (y > -7.0 && y < 7.0) &&
              (x > -7.0 && x < 7.0)) {
            continue;
          }
          if (y < -6.0) {
            _addCube(arCoreController, x, y, z, Colors.green);
          } else {
            _addCube(arCoreController, x, y, z, Colors.brown);
          }
        }
      }
    }
  }

  Sphere _addSphere(ArCoreController controller) {
    final material = ArCoreMaterial(color: Colors.blue);
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(0.0, 0.0, -1.5),
    );
    controller.addArCoreNode(node);
    return Sphere(node, sphere);
  }

  void _addCube(
      ArCoreController controller, double x, double y, double z, Color color) {
    final material = ArCoreMaterial(color: color, reflectance: 1);
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(1.0, 1.0, 1.0),
    );
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(x, y, z),
    );
    controller.addArCoreNode(node);
  }

  Cylinder _addCylinder(ArCoreController controller) {
    final material = ArCoreMaterial(color: Colors.green, reflectance: 1);
    final cylinder = ArCoreCylinder(
      materials: [material],
      radius: 0.5,
      height: 0.3,
    );
    final node = ArCoreNode(
      shape: cylinder,
      position: vector.Vector3(0.0, -0.5, -2.0),
    );
    controller.addArCoreNode(node);
    return Cylinder(node, cylinder);
  }

  Widget _buildCameraPage() {
    return Stack(
      children: [
        _buildArCoreView(),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: _buildCameraButton(),
        ),
      ],
    );
  }

  Widget _buildArCoreView() {
    return ArCoreView(onArCoreViewCreated: _onArCoreViewCreated);
  }

  Widget _buildCameraButton() {
    return InkWell(
      onTap: () => _shrinkButton(),
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(
          AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 300),
          )..forward(),
        ),
        child: AnimatedContainer(
          width: _buttonSize,
          height: _buttonSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: Icon(Icons.camera, size: _buttonSize, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isCameraOn ? _buildCameraPage() : _buildCameraButton(),
      ),
    );
  }
}
