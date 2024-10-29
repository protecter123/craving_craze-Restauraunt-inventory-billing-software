import 'package:craving_craze/Utils/Global/global.dart';
import 'package:flutter/material.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Selected Product',
            style: textTheme.titleLarge,
          ),
          Text('Item: Oreo'),
          Text('Price: 10')
        ],
      ),
    );
  }
}
