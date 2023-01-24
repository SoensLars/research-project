import 'package:flutter/material.dart';
// import 'package:research_navigation/components/create_ride_btn.dart';
import 'package:research_navigation/screens/route_overview.dart';
// import 'package:research_navigation/components/location_list_item.dart';
// import '../components/card_input.dart';

class CreateRoute extends StatefulWidget {
  const CreateRoute({Key? key}) : super(key: key);

  @override
  State<CreateRoute> createState() => _CreateRouteState();
}

class _CreateRouteState extends State<CreateRoute> {
  // TextEditingController sourceController = TextEditingController();
  // TextEditingController destinationController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                // inputField(sourceController, destinationController),
                Card(
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.all(0),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            const Text("A"),
                            Container(
                              margin: const EdgeInsets.only(top: 3),
                              color: Colors.black,
                              width: 1,
                              height: 40,
                            ),
                            const Text("B"),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              // LocationField(
                              //     isDestination: false,
                              //     textEditingController: sourceController),
                              // LocationField(
                              //     isDestination: true,
                              //     textEditingController: destinationController),
                              SizedBox(
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextField(
                                    controller: latController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'latitude',
                                    ),
                                  ),
                                ),
                              ),
                              // ignore: prefer_const_constructors
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TextField(
                                    controller: lngController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'longtitude',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(children: [
                  const Divider(
                    color: Colors.transparent,
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        setValuesHome();
                      },
                      leading: const SizedBox(
                        height: 400,
                        child: CircleAvatar(
                          child: Icon(Icons.home),
                        ),
                      ),
                      title: const Text('Home',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      // ignore: prefer_const_constructors
                      subtitle: Text('50.865361, 3.299528',
                          overflow: TextOverflow.ellipsis),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      tileColor: Colors.grey[200],
                    ),
                  ),
                  const Divider(
                    color: Colors.transparent,
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        setValuesWork();
                      },
                      leading: const SizedBox(
                        height: 400,
                        child: CircleAvatar(
                          child: Icon(Icons.work),
                        ),
                      ),
                      title: const Text('Work',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      // ignore: prefer_const_constructors
                      subtitle: Text('50.824892, 3.300710',
                          overflow: TextOverflow.ellipsis),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      tileColor: Colors.grey[200],
                    ),
                  ),
                  const Divider(
                    color: Colors.transparent,
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        setValuesSchool();
                      },
                      leading: const SizedBox(
                        height: 400,
                        child: CircleAvatar(
                          child: Icon(Icons.school),
                        ),
                      ),
                      title: const Text('School',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      // ignore: prefer_const_constructors
                      subtitle: Text('50.824499, 3.251003',
                          overflow: TextOverflow.ellipsis),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      tileColor: Colors.grey[200],
                    ),
                  ),
                  const Divider(
                    color: Colors.transparent,
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        setValuesBrewery();
                      },
                      leading: const SizedBox(
                        height: 400,
                        child: CircleAvatar(
                          child: Icon(Icons.sports_bar),
                        ),
                      ),
                      title: const Text('Brewery De Brabandere',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      // ignore: prefer_const_constructors
                      subtitle: Text('50.862760, 3.299245',
                          overflow: TextOverflow.ellipsis),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      tileColor: Colors.grey[200],
                    ),
                  ),
                  const Divider(
                    color: Colors.transparent,
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        setValuesColruyt();
                      },
                      leading: const SizedBox(
                        height: 400,
                        child: CircleAvatar(
                          child: Icon(Icons.shopping_cart),
                        ),
                      ),
                      title: const Text('Colruyt Kuurne',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      // ignore: prefer_const_constructors
                      subtitle: Text('50.844670, 3.270857',
                          overflow: TextOverflow.ellipsis),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      tileColor: Colors.grey[200],
                    ),
                  ),
                  const Divider(
                    color: Colors.transparent,
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () {
                        setValuesCarhartt();
                      },
                      leading: const SizedBox(
                        height: 400,
                        child: CircleAvatar(
                          child: Icon(Icons.checkroom),
                        ),
                      ),
                      title: const Text('Carhartt WIP Store Ghent',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      // ignore: prefer_const_constructors
                      subtitle: Text('51.048323, 3.727019',
                          overflow: TextOverflow.ellipsis),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      tileColor: Colors.grey[200],
                    ),
                  ),
                ])
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.directions_bike),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OverviewPage(
                      double.parse(latController.text),
                      double.parse(lngController.text))));
            },
            label: const Text('Create route')));
  }

  setValuesHome() =>
      {latController.text = '50.865361', lngController.text = '3.299528'};

  setValuesWork() =>
      {latController.text = '50.824892', lngController.text = '3.300710'};

  setValuesSchool() =>
      {latController.text = '50.824499', lngController.text = '3.251003'};

  setValuesBrewery() =>
      {latController.text = '50.862760', lngController.text = '3.299245'};

  setValuesColruyt() =>
      {latController.text = '50.844670', lngController.text = '3.270857'};

  setValuesCarhartt() =>
      {latController.text = '51.048323', lngController.text = '3.727019'};
}
