import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'group_provider.dart';

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<GroupProvider>(
              builder: (context, provider, child) {
                // if (groupProvider.isLoading) {
                //   return Center(child: CircularProgressIndicator());
                // }
                return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Serial No.')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Flag')),
                      ],
                      rows: provider.groups.map((group) {
                        return DataRow(
                          cells: [
                            DataCell(
                                Text('${provider.groups.indexOf(group) + 1}')),
                            DataCell(Text(group.description)),
                            DataCell(
                                Text(group.flag ? 'Positive' : 'Negative')),
                          ],
                        );
                      }).toList(),
                    ));
              },
            ),
          ),
          // Padding(padding: const EdgeInsets.all(8),
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     TextButton(onPressed: (){
          //       push(context, AddEditGroup());
          //     }, child: Text('Add')),
          //     TextButton(onPressed: (){
          //       Navigator.pop(context);
          //       // push(context, AddEditGroup());
          //     }, child: Text('Back'))
          //   ],
          // ),
          // )
        ],
      ),
    );
  }
}
