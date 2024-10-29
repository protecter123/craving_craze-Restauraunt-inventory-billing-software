import 'package:flutter/material.dart';
import 'package:craving_craze/Screens/Admin/Registration/Cart/cart.dart';
import 'package:craving_craze/Screens/Admin/Registration/NumPad/num_pad.dart';
import 'package:craving_craze/Screens/Admin/Registration/ProductSelection/product_selection.dart';
import '../../../Utils/utils.dart';

class PosInterface extends StatelessWidget {
  const PosInterface({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('POS Interface')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Expanded(
                child:
                    ProductSelection()), // Added const and Expanded for layout flexibility
            const SizedBox(
                height: 10), // Space between ProductSelection and NumPad
            const NumPad(),
          ],
        ),
      ),
    );
  }
}