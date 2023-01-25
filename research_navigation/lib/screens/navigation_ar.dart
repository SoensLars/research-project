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
  const NavigationArPage({Key? key}) : super(key: key);

  @override
  State<NavigationArPage> createState() => _NavigationArPageState();
}

class _NavigationArPageState extends State<NavigationArPage> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  ARNode? localObjectNode;
  ARNode? webObjectNode;

  String directions = "Turn right in 100m";

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
                padding: const EdgeInsets.all(14.0),
                // child: Container(
                //     alignment: Alignment.topCenter,
                //     child: SizedBox(
                //       height: 20,
                //       width: 250,
                //       child: Text(
                //         directions,
                //         // ignore: prefer_const_constructors
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 16,
                //           backgroundColor: Colors.red,
                //         ),
                //       ),
                //     )),
                child: Container(
                    width: 250,
                    height: 50,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: Center(
                      child: Text(
                      directions,
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        // backgroundColor: Colors.red,
                      ),
                    ),
                    )))
          ],
        ));
    // );
  }

  Future<void> onARViewCreated(
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
      var newNode = ARNode(
        type: NodeType.localGLTF2,
        uri: "assets/Arrow_01/scene.gltf",
        scale: vector.Vector3(0.01, 0.01, 0.01),
        position: vector.Vector3(0.0, 0.0, 0.0),
        rotation: vector.Vector4(2.0, 0.0, 0.0, 0.0),
      );
      bool? didAddLocalNode = await arObjectManager.addNode(newNode);
      localObjectNode = (didAddLocalNode!) ? newNode : null;
    }
    this.arObjectManager.onInitialize();
  }
}
