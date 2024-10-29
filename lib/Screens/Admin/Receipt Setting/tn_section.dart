import 'package:craving_craze/Utils/Global/global.dart';
import 'package:flutter/material.dart';

import '../../../Utils/utils.dart';

class TNSection extends StatelessWidget {
  final bool isEditable;
  const TNSection({super.key, required this.isEditable});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'T/N',
          style: textTheme.titleMedium,
        ),
        RadioWidget(
          isEditable: isEditable,
          title: 'Any',
          value: 1,
        ),
        RadioWidget(
          isEditable: isEditable,
          title: 'Auto table no. (001 - 009)',
          value: 2,
        ),
        RadioWidget(
          isEditable: isEditable,
          title: 'Enter table no ',
          value: 3,
        ),
        CheckBoxWidget(
          isEditable: isEditable,
          title: 'Consolidate PLUs when TN recall',
        ),
        CheckBoxWidget(
          isEditable: isEditable,
          title: 'Select eating compulsory',
        ),
        CheckBoxWidget(
          isEditable: isEditable,
          title: 'Required to input persons',
        ),
        CheckBoxWidget(
          isEditable: isEditable,
          title: 'PLU no link to persons 0',
        ),
        Gap.h(15),
        Text('TN overtime(in minutes) 0'),
        ElevatedButton(
            onPressed: isEditable ? () {} : null, child: Text('Table Layout'))
      ],
    );
  }
}

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({
    super.key,
    required this.isEditable,
    required this.title,
  });

  final bool isEditable;
  final String title;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile.adaptive(
      value: false,
      onChanged: isEditable ? (value) {} : null,
      title: Text(title),
    );
  }
}

class RadioWidget extends StatelessWidget {
  const RadioWidget({
    super.key,
    required this.isEditable,
    required this.title,
    required this.value,
  });

  final bool isEditable;
  final String title;
  final int value;

  @override
  Widget build(BuildContext context) {
    return RadioListTile.adaptive(
      value: value,
      groupValue: 1,
      onChanged: isEditable ? (value) {} : null,
      title: Text(title),
    );
  }
}
