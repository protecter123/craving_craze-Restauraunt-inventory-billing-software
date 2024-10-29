import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'department_controller.dart';
import 'department_model.dart';

class DepartmentViewPage extends StatelessWidget {
  const DepartmentViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final departmentController = Provider.of<DepartmentController>(context);
    final String adminNumber =
        'your-admin-number'; // You can fetch this dynamically as needed.

    return Scaffold(
      appBar: AppBar(title: Text('Departments')),
      body: StreamBuilder<List<DepartmentModel>>(
        stream: departmentController.getDepartmentsStream(adminNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Departments found.'));
          }

          final departments = snapshot.data!;

          return ListView.builder(
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final department = departments[index];
              return ListTile(
                title: Text(department.description.toString()),
                // subtitle: Text('ID: ${department.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
