import 'package:craving_craze/Screens/Admin/Receipt%20Setting/receipt_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Utils/Global/global.dart';
import '../../../Utils/utils.dart';
import 'receipt_line_section.dart';
import 'tn_section.dart';

class ReceiptSettingForm extends StatelessWidget {
  const ReceiptSettingForm({super.key});

  @override
  Widget build(BuildContext context) {
    final isEditable = context.watch<ReceiptSettingProvider>().isEditable;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TNSection(isEditable: isEditable),
          Gap.h(16),
          ReceiptLineSection(isEditable: isEditable),
          Gap.h(10),
          Text(
            'Receipt Item Format',
            style: textTheme.titleMedium
                ?.copyWith(color: !isEditable ? Colors.grey : null),
          ),
          RadioWidget(isEditable: isEditable, title: 'DQPA(DEFAULT)', value: 1),
          RadioWidget(
              isEditable: isEditable, title: 'QWP2DA(TWO LINES)', value: 2),
          RadioWidget(
              isEditable: isEditable, title: 'QWP2DA(ONLY FOR 80MM)', value: 3),
          RadioWidget(
              isEditable: isEditable, title: 'QWP2D(80MM ONLY)', value: 4),
          Text(
            'Manual receipt copy times',
            style: textTheme.titleMedium
                ?.copyWith(color: !isEditable ? Colors.grey : null),
          ),
          RadioWidget(isEditable: isEditable, title: 'None', value: 1),
          RadioWidget(isEditable: isEditable, title: '1', value: 2),
          RadioWidget(isEditable: isEditable, title: '2', value: 3),
          RadioWidget(isEditable: isEditable, title: '3', value: 4),
          Text(
            'Auto receipt copy',
            style: textTheme.titleMedium
                ?.copyWith(color: !isEditable ? Colors.grey : null),
          ),
          RadioWidget(isEditable: isEditable, title: 'None', value: 1),
          RadioWidget(isEditable: isEditable, title: '1Pcs', value: 2),
          RadioWidget(isEditable: isEditable, title: '2Pcs', value: 3),
          RadioWidget(isEditable: isEditable, title: '3Pcs', value: 4),
          Text(
            'Ticket mode',
            style: textTheme.titleMedium
                ?.copyWith(color: !isEditable ? Colors.grey : null),
          ),
          RadioWidget(isEditable: isEditable, title: 'No', value: 1),
          RadioWidget(isEditable: isEditable, title: 'Yes', value: 2),
          CheckBoxWidget(
              isEditable: isEditable, title: 'Print same group together'),
          CheckBoxWidget(isEditable: isEditable, title: 'Double high'),
          CheckBoxWidget(
              isEditable: isEditable, title: 'With amount(80mm printer only'),
        ],
      ),
    );
  }
}
