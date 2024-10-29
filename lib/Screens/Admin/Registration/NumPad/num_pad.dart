import 'package:flutter/material.dart';

class NumPad extends StatefulWidget {
  const NumPad({super.key});

  @override
  State<NumPad> createState() => _NumPadState();
}

class _NumPadState extends State<NumPad> {
  // Define button labels
  final List<String> labels = [
    'QTY+',
    'QTY-',
    '100.00',
    '7',
    '8',
    '9',
    'T/N',
    'K/M',
    'E.C.',
    'QTY',
    '50.00',
    '4',
    '5',
    '6',
    'C/N',
    'SUBTL',
    'AMOUNT',
    '20.00',
    '1',
    '2',
    '3',
    '#/DRAWER',
    'PLU',
    '10.00',
    '0',
    '00',
    '.',
    'MULTIMEDIA'
  ];

  // Map button labels to their respective onPressed functions
  late final Map<String, Function()> buttonActions;

  bool showNumPad = true; // Controls visibility of NumPad
  String textFieldValue = ''; // Tracks TextField input

  @override
  void initState() {
    super.initState();

    // Initialize buttonActions map with different functions for each button
    buttonActions = {
      'QTY+': () => print('QTY+'),
      'QTY-': () => print('QTY-'),
      '100.00': () => print('100.00'),
      '7': () => addToTextField('7'),
      '8': () => addToTextField('8'),
      '9': () => addToTextField('9'),
      'T/N': () => print('T/N'),
      'K/M': () => print('K/M'),
      'E.C.': () => print('E.C.'),
      'QTY': () => print('QTY'),
      '50.00': () => print('50.00'),
      '4': () => addToTextField('4'),
      '5': () => addToTextField('5'),
      '6': () => addToTextField('6'),
      'C/N': () => print('C/N'),
      'SUBTL': () => print('SUBTL'),
      'CLEAR': () => clearTextField(), // Custom action for CLEAR
      'AMOUNT': () => print('AMOUNT'),
      '20.00': () => print('20.00'),
      '1': () => addToTextField('1'),
      '2': () => addToTextField('2'),
      '3': () => addToTextField('3'),
      '#/DRAWER': () => print('#/DRAWER'),
      'CASH': () => print('CASH'),
      'PLU': () => print('PLU'),
      '10.00': () => print('10.00'),
      '0': () => addToTextField('0'),
      '00': () => addToTextField('00'),
      '.': () => addToTextField('.'),
      'MULTIMEDIA': () => print('MULTIMEDIA'),
    };
  }

  // Add input to the TextField
  void addToTextField(String value) {
    setState(() {
      textFieldValue += value;
    });
  }

  // Clear TextField
  void clearTextField() {
    setState(() {
      textFieldValue = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TextField to show input
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            textDirection: TextDirection.rtl,
            // onTap: ()=> setState(() => showNumPad = !showNumPad),
            readOnly: true, // Make TextField read-only
            controller: TextEditingController(text: textFieldValue),
            decoration: InputDecoration(
              // labelText: 'Input',
              border: OutlineInputBorder(),
            ),
          ),
        ),

        // Button to toggle NumPad visibility
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                showNumPad = !showNumPad;
              });
            },
            child: Text(showNumPad ? 'Hide NumPad' : 'Show NumPad'),
          ),
        ),

        // Show/hide the NumPad based on the state
        Visibility(
          // maintainState: true,
          // maintainAnimation: true,
          // maintainSize: true,
          // maintainSemantics: true,
          // maintainInteractivity:true,
          visible: showNumPad,
          child: Table(
            children: [
              TableRow(
                children: List.generate(8, (index) {
                  return buildButton(
                      context, labels[index], buttonActions[labels[index]]!);
                }),
              ),
              TableRow(
                children: List.generate(8, (index) {
                  return buildButton(context, labels[8 + index],
                      buttonActions[labels[8 + index]]!);
                }),
              ),
              TableRow(
                children: [
                  buildLargeButton(context, 'CLEAR', buttonActions['CLEAR']!),
                  Column(
                    children: [
                      buildButton(
                          context, labels[16], buttonActions[labels[16]]!),
                      buildButton(
                          context, labels[22], buttonActions[labels[22]]!),
                    ],
                  ),
                  Column(
                    children: [
                      buildButton(
                          context, labels[17], buttonActions[labels[17]]!),
                      buildButton(
                          context, labels[23], buttonActions[labels[23]]!),
                    ],
                  ),
                  Column(
                    children: [
                      buildButton(
                          context, labels[18], buttonActions[labels[18]]!),
                      buildButton(
                          context, labels[24], buttonActions[labels[24]]!),
                    ],
                  ),
                  Column(
                    children: [
                      buildButton(
                          context, labels[19], buttonActions[labels[19]]!),
                      buildButton(
                          context, labels[25], buttonActions[labels[23]]!),
                    ],
                  ),
                  Column(
                    children: [
                      buildButton(
                          context, labels[20], buttonActions[labels[20]]!),
                      buildButton(
                          context, labels[26], buttonActions[labels[26]]!),
                    ],
                  ),
                  Column(
                    children: [
                      buildButton(
                          context, labels[21], buttonActions[labels[21]]!),
                      buildButton(
                          context, labels[27], buttonActions[labels[27]]!),
                    ],
                  ),
                  buildLargeButton(context, 'CASH', buttonActions['CASH']!),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Regular button
  Widget buildButton(BuildContext context, String label, Function onPressed) {
    final Color color = getColorForButton(label); // Get color based on label
    return GestureDetector(
      onTap: () => onPressed(), // Call function on tap
      child: Container(
        alignment: Alignment.center,
        height: 50,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black26, width: 1)),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
        ),
      ),
    );
  }

  // Larger button for CLEAR and CASH
  Widget buildLargeButton(
      BuildContext context, String label, Function onPressed) {
    final Color color = getColorForButton(label); // Get color based on label

    return GestureDetector(
      onTap: () => onPressed(), // Call function on tap
      child: Container(
        alignment: Alignment.center,
        height: 104,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black26, width: 1)),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontSize: 10), // Larger text
        ),
      ),
    );
  }
}

// Function to determine button color based on label
Color getColorForButton(String label) {
  switch (label) {
    case 'T/N' || 'QTY' || 'C/N' || '#/DRAWER':
      return Colors.blueAccent;
    case 'CLEAR' || 'AMOUNT':
      return Colors.redAccent;
    case 'CASH' || 'PLU':
      return Colors.yellowAccent;
    case 'QTY+' ||
          'QTY-' ||
          '100.00' ||
          'K/M' ||
          'E.C.' ||
          '50.00' ||
          'SUBTL' ||
          '20.00' ||
          '10.00' ||
          'MULTIMEDIA':
      return Colors.grey.shade300;
    default:
      return Colors.grey;
  }
}
