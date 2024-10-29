import 'package:craving_craze/Utils/Global/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'media_model.dart';
import 'media_provider.dart';

class MediaPage extends StatelessWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MediaProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Media Total'),
        ),
        body: Consumer<MediaProvider>(
          builder: (context, provider, child) {
            return ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Description',style: textTheme.titleMedium,),
                    // Spacer(),
                    Text('Name',style: textTheme.titleMedium),
                    // Spacer(),
                    Text('OpenDrawer',style: textTheme.titleMedium)
                  ],
                ),
                ...provider.mediaItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  MediaItem item = entry.value;
                  return MediaItemTile(
                    mediaItem: item,
                    index: index,
                  );
                }),
                _buildCurrencySection(context),
                _buildPresetCashSection(),
                _buildRoundSection(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrencySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Currency symbol',style: textTheme.titleMedium,),
          Row(
            children: [
              Text('\$'),
              SizedBox(width: 8),
              Icon(Icons.edit),
              SizedBox(width: 8),
              Checkbox(
                value: false, // Replace with actual state
                onChanged: (value) {},
              ),
              Text('Currency symbol print on the receipt'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetCashSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preset cash',style: textTheme.titleMedium,),
          SizedBox(height: 10),
          _buildPresetCashTile('Preset cash1', 10.00),
          _buildPresetCashTile('Preset cash2', 20.00),
          _buildPresetCashTile('Preset cash3', 50.00),
          _buildPresetCashTile('Preset cash4', 100.00),
        ],
      ),
    );
  }

  Widget _buildPresetCashTile(String label, double value) {
    return ListTile(
      title: Text(label),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value.toStringAsFixed(2)),
          SizedBox(width: 8),
          Icon(Icons.edit),
        ],
      ),
    );
  }

  Widget _buildRoundSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Round',style: textTheme.titleMedium,),
          ListTile(
            title: Text('Position:'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile(
                  title: Text('the 2nd decimal'),
                  value: 0,
                  groupValue: 0,
                  onChanged: (value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                RadioListTile(
                  title: Text('the 1st decimal'),
                  value: 1,
                  groupValue: 0,
                  onChanged: (value) {},
                  controlAffinity: ListTileControlAffinity.leading,

                ),
                RadioListTile(
                  title: Text('the unit'),
                  value: 2,
                  groupValue: 0,
                  onChanged: (value) {},
                  controlAffinity: ListTileControlAffinity.leading,

                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Method:'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile(
                  title: Text('N/A'),
                  value: 0,
                  groupValue: 0,
                  onChanged: (value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                ),  RadioListTile(
                  title: Text('Discard'),
                  value: 0,
                  groupValue: 0,
                  onChanged: (value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                RadioListTile(
                  title: Text('1_4->0/5_9->10'),
                  value: 1,
                  groupValue: 0,
                  onChanged: (value) {},
                  controlAffinity: ListTileControlAffinity.leading,

                ),
                RadioListTile(
                  title: Text('1_3->0/4_6->/7_9->10'),
                  value: 2,
                  groupValue: 0,
                  onChanged: (value) {},
                  controlAffinity: ListTileControlAffinity.leading,

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class MediaItemTile extends StatelessWidget {
  final MediaItem mediaItem;
  final int index;

  const MediaItemTile({super.key, required this.mediaItem, required this.index});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MediaProvider>(context);

    return ListTile(
      leading: Checkbox(
        value: mediaItem.isSelected,
        onChanged: (bool? value) {
          provider.toggleSelection(index);
        },
      ),
      title: Text(mediaItem.description),
      subtitle: mediaItem.isEditable
          ? TextField(
        keyboardType: TextInputType.number,
        onChanged: (value) {
          provider.updateCharge(index, value as double);
        },
        decoration: InputDecoration(
          labelText: 'Charge %',
          suffixText: mediaItem.charge.toStringAsFixed(3),
        ),
      )
          : Text('Charge %: ${mediaItem.charge.toStringAsFixed(3)}'),
      trailing: Checkbox(
        value: mediaItem.openDrawer,
        onChanged: (bool? value) {
          provider.toggleOpenDrawer(index);
        },
      ),
    );
  }
}
