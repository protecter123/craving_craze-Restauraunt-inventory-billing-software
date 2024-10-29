import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'receipt_setting_form.dart';
import 'receipt_settings_provider.dart';

class ReceiptSetting extends StatelessWidget {
  const ReceiptSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReceiptSettingProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Receipt Setting'),
          actions: [
            Consumer<ReceiptSettingProvider>(
              builder: (context, provider, child) {
                return IconButton(
                    onPressed: () => provider.toggleEditable(),
                    icon: Icon(provider.isEditable ? Icons.save : Icons.edit));
              },
            )
          ],
        ),
        body: ReceiptSettingForm(),
      ),
    );
  }
}
