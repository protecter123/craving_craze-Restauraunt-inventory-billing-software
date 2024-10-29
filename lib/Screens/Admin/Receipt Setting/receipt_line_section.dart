import 'package:craving_craze/Utils/Global/global.dart';
import 'package:flutter/material.dart';

import '../../../Utils/utils.dart';

class ReceiptLineSection extends StatelessWidget {
  final bool isEditable;

  const ReceiptLineSection({super.key, required this.isEditable});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Head line of the receipt ',
          style: textTheme.titleMedium,
        ),
        for (int i = 1; i <= 8; i++)
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ReceiptLine(isEditable: isEditable, lineNumber: i)),
        Gap.h(15),
        Text('Tail Lines of the Receipt'),
        Gap.h(10),
        for (int i = 1; i <= 5; i++)
          ReceiptLine(isEditable: isEditable, lineNumber: i),
        Gap.h(30),
        ElevatedButton(
            onPressed: isEditable ? () {} : null,
            child: Text('Auto Center Process')),
        ElevatedButton(
            onPressed: isEditable ? () {} : null, child: Text('Store Logo')),
        ElevatedButton(
            onPressed: isEditable ? () {} : null,
            child: Text('Invoice Template')),
      ],
    );
  }
}

class ReceiptLine extends StatelessWidget {
  final bool isEditable;
  final int lineNumber;

  const ReceiptLine(
      {super.key, required this.isEditable, required this.lineNumber});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          'Line$lineNumber: ',
          style: textTheme.titleMedium
              ?.copyWith(color: !isEditable ? Colors.grey : null),
        ),
        Checkbox(value: false, onChanged: isEditable ? (value) {} : null),
        Text(
          'Print',
          style: textTheme.bodyMedium
              ?.copyWith(color: !isEditable ? Colors.grey : null),
        ),
        Checkbox(value: false, onChanged: isEditable ? (value) {} : null),
        Text(
          'Double high',
          style: textTheme.bodyMedium
              ?.copyWith(color: !isEditable ? Colors.grey : null),
        ),
        Checkbox(value: false, onChanged: isEditable ? (value) {} : null),
        Text(
          'Double width',
          style: textTheme.bodyMedium
              ?.copyWith(color: !isEditable ? Colors.grey : null),
        ),
      ],
    );
  }
}
