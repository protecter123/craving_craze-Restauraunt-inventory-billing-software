import 'package:flutter/material.dart';

import '../../../../Utils/utils.dart';



class ChangeProductsIdentities extends StatefulWidget {
  const ChangeProductsIdentities({super.key});

  @override
  ChangeProductsIdentitiesState createState() => ChangeProductsIdentitiesState();
}

class ChangeProductsIdentitiesState extends State<ChangeProductsIdentities> {
  List<String> leftList = ["(1) fhcrg", "(2) bhujiya", "(3) fhcrg"];
  List<String> rightList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Identities")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Left side list
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  const Text("Available Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: leftList.length,
                      itemBuilder: (context, index) {
                        return Draggable<String>(
                          data: leftList[index],
                          feedback: Material(
                            child: Container(
                              color: Colors.grey[200],
                              padding: const EdgeInsets.all(8),
                              child: Text(leftList[index]),
                            ),
                          ),
                          childWhenDragging: Container(),
                          child: ListTile(title: Text(leftList[index])),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
const Divider(
  color: Colors.blue,
),
            // Buttons in the center
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward),
                ),
                Gap.h(20),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back),
                ),
              ],
            ),

            // Right side list
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Selected Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: DragTarget<String>(
                      builder: (context, candidateData, rejectedData) {
                        return ListView.builder(
                          itemCount: rightList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(rightList[index]),
                            );
                          },
                        );
                      },
                      onAcceptWithDetails: (data) {
                        setState(() {
                          rightList.add(data as String);
                          leftList.remove(data);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
