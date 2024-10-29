import 'package:flutter/material.dart';

class UnitsManage extends StatefulWidget {
  const UnitsManage({super.key});

  @override
  UnitsManageState createState() => UnitsManageState();
}

class UnitsManageState extends State<UnitsManage> {
  final List<String> _userUnits = [];
  Units? _selectedUnit;

  void _addUnit(String unit) {
    setState(() {
      _userUnits.add(unit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Units'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Add new unit',
              ),
              onSubmitted: (unit) {
                _addUnit(unit);
              },
            ),
            const SizedBox(height: 20),
            DropdownButton(
              value: _selectedUnit,
              onChanged: (unit) {
                setState(() {
                  _selectedUnit = unit;
                });
              },
              items: Units.values
                  .map((unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit.toString().split('.').last),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

enum Units {
  ltr,
  pics,
  dozn,
  all,
  kg,
  gm,
  ml,
}
