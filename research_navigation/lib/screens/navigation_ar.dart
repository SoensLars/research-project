import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/widgets/ar_view.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class NavigationArPage extends StatefulWidget {
  const NavigationArPage({Key? key}) : super(key: key);

  @override
  State<NavigationArPage> createState() => _NavigationArPageState();
}

class _NavigationArPageState extends State<NavigationArPage> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  //String localObjectReference;
  ARNode? localObjectNode;

  //String webObjectReference;
  ARNode? webObjectNode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AR Navigation"),
      ),
      // body: Padding(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8829,
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(22),
                // child: Container(
                //   color: Colors.black,
                // ),
                // child: ARView(
                //   onARViewCreated: onARViewCreated,
                // ),
              ),
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: ElevatedButton(
            //           onPressed: onLocalObjectButtonPressed,
            //           child: const Text("Add / Remove Local Object")),
            //     ),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     Expanded(
            //       child: ElevatedButton(
            //           onPressed: onWebObjectAtButtonPressed,
            //           child: const Text("Add / Remove Web Object")),
            //     )
            //   ],
            // ),
          ],
        ),
      );
    // );
  }

  Future<void> onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager,
    ) async {
    // 1
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    // onLocalObjectButtonPressed();
    // 2
    // this.arSessionManager.onInitialize(
    //       showFeaturePoints: false,
    //       showPlanes: true,
    //       customPlaneTexturePath: "triangle.png",
    //       showWorldOrigin: true,
    //       handleTaps: false,
    //     );
    if (localObjectNode != null) {
      arObjectManager.removeNode(localObjectNode!);
      localObjectNode = null;
    } else {
      // 2
      var newNode = ARNode(
          type: NodeType.localGLTF2,
          uri: "assets/Arrow_01/scene.gltf",
          scale: Vector3(0.01, 0.01, 0.01),
          position: Vector3(0.0, 0.0, 0.0),
          rotation: Vector4(2.0, 0.0, 0.0, 0.0),
        );
      // 3
      bool? didAddLocalNode = await arObjectManager.addNode(newNode);
      localObjectNode = (didAddLocalNode!) ? newNode : null;
    }
    // 3
    this.arObjectManager.onInitialize();
  }

  // Future<void> onLocalObjectButtonPressed() async {
  //   // 1
  //   if (localObjectNode != null) {
  //     arObjectManager.removeNode(localObjectNode!);
  //     localObjectNode = null;
  //   } else {
  //     // 2
  //     var newNode = ARNode(
  //         type: NodeType.localGLTF2,
  //         uri: "assets/Arrow_01/scene.gltf",
  //         scale: Vector3(0.01, 0.01, 0.01),
  //         position: Vector3(0.0, 0.0, 0.0),
  //         rotation: Vector4(1.0, 0.0, 0.0, 0.0)
  //       );
  //     // 3
  //     bool? didAddLocalNode = await arObjectManager.addNode(newNode);
  //     localObjectNode = (didAddLocalNode!) ? newNode : null;
  //   }
  // }

  // Future<void> onWebObjectAtButtonPressed() async {
  //   if (webObjectNode != null) {
  //     arObjectManager.removeNode(webObjectNode!);
  //     webObjectNode = null;
  //   } else {
  //     var newNode = ARNode(
  //         type: NodeType.webGLB,
  //         uri:
  //             "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
  //         scale: Vector3(0.05, 0.05, 0.05)
  //         );
  //     bool? didAddWebNode = await arObjectManager.addNode(newNode);
  //     webObjectNode = (didAddWebNode!) ? newNode : null;
  //   }
  // }
}
