import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/widgets/ar_view.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/material.dart';
class NavigationArPage extends StatefulWidget {
  String direction;
  double meter;
  NavigationArPage(this.direction, this.meter, {super.key});

  @override
  State<NavigationArPage> createState() => _NavigationArPageState();
}

class _NavigationArPageState extends State<NavigationArPage> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  ARNode? localObjectNode;
  ARNode? webObjectNode;

  String directions = "Go 100m straight";
  double rotationValue = 3.14 / 2;

  @override
  initState() {
    super.initState();
    calculateDirection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("AR Navigation"),
        ),
        body: Stack(
          children: [
            ARView(
              onARViewCreated: onARViewCreated,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(110, 20, 110, 0),
                child: Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100),
                        // ignore: prefer_const_literals_to_create_immutables
                        boxShadow: [
                          const BoxShadow(
                              color: Colors.black12,
                              offset: Offset(5, 5),
                              blurRadius: 10,
                              spreadRadius: 3)
                        ]),
                    child: Text(
                      directions,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ))
          ],
        ));
  }

  calculateDirection() {
    if (widget.direction == "straight") {
      rotationValue = 3.14 / 2;
      directions = "Go ${widget.meter.round()}m straight";
    }

    if (widget.direction == "left") {
      rotationValue = 3.14;
      directions = "Turn left in ${widget.meter.round()}m";
    }

    if (widget.direction == "right") {
      rotationValue = 0;
      directions = "Turn right in ${widget.meter.round()}m";
    }
  }

  onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) async {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    if (localObjectNode != null) {
      arObjectManager.removeNode(localObjectNode!);
      localObjectNode = null;
    } else {
      vector.Matrix3 matrix = vector.Matrix3.rotationZ(rotationValue);
      var newNode = ARNode(
        type: NodeType.localGLTF2,
        uri: "assets/Arrow_01/scene.gltf",
        scale: vector.Vector3(0.01, 0.01, 0.01),
        position: vector.Vector3(0.0, 0.0, 0.0),
        rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
      );
      newNode.rotation = matrix;
      bool? didAddLocalNode = await arObjectManager.addNode(newNode);
      localObjectNode = (didAddLocalNode!) ? newNode : null;
    }
    this.arObjectManager.onInitialize();
  }
}
