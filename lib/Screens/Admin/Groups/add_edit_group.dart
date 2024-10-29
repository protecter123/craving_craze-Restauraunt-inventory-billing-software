// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../Utils/utils.dart';
// import 'group_model.dart';
// import 'group_provider.dart';

// class AddEditGroup extends StatefulWidget {
//   final Group? group;

//   const AddEditGroup({super.key, this.group});

//   @override
//   State<AddEditGroup> createState() => _AddEditGroupState();
// }

// class _AddEditGroupState extends State<AddEditGroup> {
//   final _formKey = GlobalKey<FormState>();
//   late int _id;
//   late String _description;
//   late bool _flag;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.group != null) {
//       _id = widget.group!.id;
//       _description = widget.group!.description;
//       _flag = widget.group!.flag;
//     } else {
//       _id = 0;
//       _description = '';
//       _flag = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text(widget.group != null ? 'Edit Group' : 'Add Group')),
//         body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   Gap.h(20),
//                   TextFormField(
//                     initialValue: _id.toString(),
//                     decoration: InputDecoration(labelText: 'Group ID'),
//                     validator: (value) => value!.isEmpty ? 'Enter Group ID' : null,
//                     onSaved: (value) => _id = int.parse(value!),
//                   ),
//                   Gap.h(20),
//                   TextFormField(
//                     initialValue: _description,
//                     decoration: InputDecoration(labelText: 'Description'),
//                     validator: (value) => value!.isEmpty ? 'Enter Description' : null,
//                     onSaved: (value) => _description = value!,
//                   ),
//                   Gap.h(20),
//                   DropdownButtonFormField<String>(
//                     value: _flag?'Positive':'Negative',
//                     items: ['Positive', 'Negative']
//                         .map((flag) => DropdownMenuItem(value: flag, child: Text(flag)))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _flag = value == 'Positive';
//                       });
//                       // _flag?'Postive': = value!;
//                     },
//                     decoration: InputDecoration(labelText: 'Flag'),
//                   ),
//                 Gap.h(30),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         _formKey.currentState!.save();
//                         Group group = Group(id: _id, description: _description, flag: _flag);

//                         if (widget.group != null) {
//                           Provider.of<GroupProvider>(context, listen: false).updateGroup(widget.group!.id.toString(), group);
//                         } else {
//                           Provider.of<GroupProvider>(context, listen: false).addGroup(group);
//                         }

//                         Navigator.pop(context);
//                       }
//                     },
//                     child: Text(widget.group != null ? 'Update' : 'Add'),
//                   )
//                 ],
//               ),
//             ),
//             ),
//         );

//   }
// }
