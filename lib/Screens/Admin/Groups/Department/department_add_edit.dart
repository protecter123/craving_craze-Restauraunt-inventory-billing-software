// import 'package:flutter/material.dart';

// class DepartmentPage extends StatefulWidget {
//   const DepartmentPage({super.key});

//   @override
//   DepartmentPageState createState() => DepartmentPageState();
// }

// class DepartmentPageState extends State<DepartmentPage> {
//   bool show = true;
//   String name = 'biscuit';
//   String group = '1-bakery';
//   int kpSelected = 0;
//   int typeSelected = 0;
//   bool vatEnabled = false;
//   bool reverseCalculation = false;
//   bool enableDeptSale = false;
//   bool ticketPrint = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Department'),
//         // actions: [
//           // IconButton(onPressed: () {}, icon: const Icon(Icons.save)),
//           // IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
//         // ],
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Text(
//                       'Code',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(width: 10),
//                     const Text('D001', style: TextStyle(color: Colors.grey)),
//                     Checkbox(
//                       value: show,
//                       onChanged: (bool? value) {
//                         setState(() {
//                           show = value ?? false;
//                         });
//                       },
//                     ),
//                     const Text('Show'),
//                   ],
//                 ),
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Name'),
//                   controller: TextEditingController(text: name),
//                   onChanged: (value) {
//                     setState(() {
//                       name = value;
//                     });
//                   },
//                 ),
//                Gap.h(10),
//                 const Text(
//                   'KP',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Wrap(
//                   spacing: 10.0,
//                   children: List.generate(8, (index) {
//                     return Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Radio(
//                           value: index,
//                           groupValue: kpSelected,
//                           onChanged: (int? value) {
//                             setState(() {
//                               kpSelected = value!;
//                             });
//                           },
//                         ),
//                         Text('#${index + 1}'),
//                       ],
//                     );
//                   }),
//                 ),
//                Gap.h(10),
//                 TextField(
//                   decoration: const InputDecoration(labelText: 'Group'),
//                   controller: TextEditingController(text: group),
//                   onChanged: (value) {
//                     setState(() {
//                       group = value;
//                     });
//                   },
//                 ),
//                Gap.h(10),
//                 const Text(
//                   'Type',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Row(
//                   children: [
//                     Radio(
//                       value: 0,
//                       groupValue: typeSelected,
//                       onChanged: (int? value) {
//                         setState(() {
//                           typeSelected = value!;
//                         });
//                       },
//                     ),
//                     const Text('Can be sold (Production)'),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Radio(
//                       value: 1,
//                       groupValue: typeSelected,
//                       onChanged: (int? value) {
//                         setState(() {
//                           typeSelected = value!;
//                         });
//                       },
//                     ),
//                     const Text('Not sell (Raw materials for stock statistics)'),
//                   ],
//                 ),
//                Gap.h(10),
//                 const Text(
//                   'VAT',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const Text('NONE VAT', style: TextStyle(color: Colors.grey)),
//                 CheckboxListTile(
//                   title: const Text('%'),
//                   value: vatEnabled,
//                   onChanged: (bool? value) {
//                     setState(() {
//                       vatEnabled = value!;
//                     });
//                   },
//                 ),
//                 CheckboxListTile(
//                   title: const Text('Reverse calculation'),
//                   value: reverseCalculation,
//                   onChanged: (bool? value) {
//                     setState(() {
//                       reverseCalculation = value!;
//                     });
//                   },
//                 ),
//                 CheckboxListTile(
//                   title: const Text('Enable dept sale'),
//                   value: enableDeptSale,
//                   onChanged: (bool? value) {
//                     setState(() {
//                       enableDeptSale = value!;
//                     });
//                   },
//                 ),
//                 CheckboxListTile(
//                   title: const Text('Ticket print when ticket mode active'),
//                   value: ticketPrint,
//                   onChanged: (bool? value) {
//                     setState(() {
//                       ticketPrint = value!;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Utils/utils.dart';
import 'department_controller.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({super.key});

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DepartmentController()..init(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Department'),
          // actions: [
          //   IconButton(onPressed: () {}, icon: const Icon(Icons.save)),
          //   IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Consumer<DepartmentController>(
              builder: (context, controller, _) {
                return Form(
                  // key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Code', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 10),
                          const Text('D001',
                              style: TextStyle(color: Colors.grey)),
                          Checkbox(
                            value: controller.show,
                            onChanged: controller.toggleShow,
                          ),
                          const Text('Show'),
                        ],
                      ),
                      TextFieldWidget(
                        controller: controller.nameController,
                        label: 'Name',
                        // initialValue: controller.name,
                        // onChanged: controller.updateName,
                      ),
                      Gap.h(10),
                      RadioGroupWidget(
                        label: 'KP',
                        values: List.generate(8, (index) => '#${index + 1}'),
                        groupValue: controller.kpSelected,
                        onChanged: controller.selectKP,
                        includeNoneOption: true,
                      ),
                      Gap.h(10),
                      DropdownButtonFormField<String>(
                        value: controller.groups.contains(controller.group)
                            ? controller.group
                            : null,
                        decoration: const InputDecoration(labelText: 'Group'),
                        items: [
                          ...controller.groups.map((g) =>
                              DropdownMenuItem(value: g, child: Text(g))),
                          const DropdownMenuItem(
                              value: 'Add Group', child: Text('Add Group'))
                        ],
                        onChanged: (String? newValue) {
                          controller.updateGroup(newValue, context);
                        },
                      ),
                      Gap.h(10),
                      RadioGroupWidget(
                        label: 'Type',
                        values: const [
                          'Can be sold (Production)',
                          'Not sell (Raw materials)'
                        ],
                        groupValue: controller.typeSelected,
                        onChanged: controller.updateType,
                        // onChanged: (value) {
                        //   controller.typeSelected = value!;
                        //   // ValueNotifier(value);
                        // },
                        // includeNoneOption: true,
                      ),
                      Gap.h(10),
                      DropdownButtonFormField<String>(
                        value: controller.vatOptions.contains(controller.vat)
                            ? controller.vat
                            : null,
                        decoration: const InputDecoration(labelText: 'VAT'),
                        items: [
                          ...controller.vatOptions.map((v) =>
                              DropdownMenuItem(value: v, child: Text(v))),
                          const DropdownMenuItem(
                              value: 'Add VAT', child: Text('Add VAT'))
                        ],
                        onChanged: (String? newValue) {
                          controller.updateVat(newValue, context);
                        },
                      ),
                      CheckboxTile(
                        label: '%',
                        value: controller.vatEnabled,
                        onChanged: controller.togglePercentageEnabled,
                      ),
                      CheckboxTile(
                        label: 'Reverse calculation',
                        value: controller.reverseCalculation,
                        onChanged: controller.toggleReverseCalculation,
                      ),
                      CheckboxTile(
                        label: 'Enable dept sale',
                        value: controller.enableDeptSale,
                        onChanged: controller.toggleEnableDeptSale,
                      ),
                      CheckboxTile(
                        label: 'Ticket print when ticket mode active',
                        value: controller.ticketPrint,
                        onChanged: controller.toggleTicketPrint,
                      ),
                      Gap.h(10),
                      // buildBottomButton(
                      //     context, textTheme, 'Submit', controller.isLoading,
                      //     () {
                      //   // Navigate to DepartmentListScreen

                      //   controller.submitData();
                      //   Navigator.pop(context);
                      // }),

                      ElevatedButton(
                        onPressed: controller.isLoading
                            ? null
                            : () async {
                                // Use listen: false to avoid unexpected rebuilds
                                await Provider.of<DepartmentController>(context,
                                        listen: false)
                                    .submitData();
                                context.mounted ? Navigator.pop(context) : null;
                                context.mounted
                                    ? showSnackbar(context, 'Added department',
                                        color: Colors.green)
                                    : null;
                              },
                        child: controller.isLoading
                            ? CircularProgressIndicator()
                            : Text('Submit'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        // bottomNavigationBar:
      ),
    );
  }
}

class RadioGroupWidget extends StatelessWidget {
  final String label;
  final List<String> values;
  final int groupValue;
  final Function(int?) onChanged;
  final bool includeNoneOption;

  const RadioGroupWidget({
    super.key,
    required this.label,
    required this.values,
    required this.groupValue,
    required this.onChanged,
    this.includeNoneOption = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Wrap(
          spacing: 10.0,
          children: [
            if (includeNoneOption)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                      value: -1, groupValue: groupValue, onChanged: onChanged),
                  const Text('None'),
                ],
              ),
            ...List.generate(values.length, (index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: index,
                    groupValue: groupValue,
                    onChanged: onChanged,
                  ),
                  Text(values[index]),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }
}

class CheckboxTile extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool?) onChanged;

  const CheckboxTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final String label;
  // final String initialValue;
  // final Function(String) onChanged;
  final TextEditingController controller;

  const TextFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    // required this.initialValue,
    // required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      controller: controller,
      // onChanged: onChanged,
    );
  }
}

class AddGroupPage extends StatelessWidget {
  const AddGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Group')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Group Name'),
              onChanged: (value) {
                // Update the group name in the controller
                Provider.of<DepartmentController>(context, listen: false)
                    .group = value;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Prepare group data to save
                final Map<String, dynamic> groupData = {
                  'name':
                      Provider.of<DepartmentController>(context, listen: false)
                          .group,
                  'type':
                      'Can be sold', // Example field; add other fields if needed
                };

                // Call the addNewGroup method to save data to Firebase
                Provider.of<DepartmentController>(context, listen: false)
                    .addNewGroup(groupData);
              },
              child: const Text('Save Group'),
            ),
            Consumer<DepartmentController>(
              builder: (context, controller, _) {
                return Text('Generated Code: ${controller.autoGeneratedCode}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
