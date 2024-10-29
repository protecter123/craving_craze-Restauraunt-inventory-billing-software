import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Utils/Global/global.dart';



class GroupProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Group> _groups = [];

  List<Group> get groups => _groups;

  Future<void> createGroup(String groupId, String description, bool flag) async {
    final groupRef = _firestore.collection('Admins').doc(adminNumber).collection('Groups').doc(groupId);
    await groupRef.set({'description': description, 'flag': flag});
    _groups.add(Group(groupId: groupId, description: description, flag: flag));
    notifyListeners();
  }

  Future<void> readGroups() async {
    final groupsRef = _firestore.collection('Admins').doc(adminNumber).collection('Groups');
    final groupsSnapshot = await groupsRef.get();
    _groups = groupsSnapshot.docs.map((doc) => Group(groupId: doc.id, description: doc.get('description'), flag: doc.get('flag'))).toList();
    notifyListeners();
  }

  Future<void> updateGroup(String groupId, String description, bool flag) async {
    final groupRef = _firestore.collection('Admins').doc(adminNumber).collection('Groups').doc(groupId);
    await groupRef.update({'description': description, 'flag': flag});
    final index = _groups.indexWhere((group) => group.groupId == groupId);
    if (index != -1) {
      _groups[index] = Group(groupId: groupId, description: description, flag: flag);
    }
    notifyListeners();
  }

  Future<void> deleteGroup(String groupId) async {
    final groupRef = _firestore.collection('Admins').doc(adminNumber).collection('Groups').doc(groupId);
    await groupRef.delete();
    _groups.removeWhere((group) => group.groupId == groupId);
    notifyListeners();
  }
}

class Group {
  final String groupId;
  final String description;
  final bool flag;

  Group({required this.groupId, required this.description, required this.flag});
}
 

  // Update group in Firestore
//   Future<void> updateGroup(String docId, Group group) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('Admins')
//           .doc(adminNumber)
//           .collection('Groups')
//           .doc(docId)
//           .update(group.toFireStore());

//       int index = _groups.indexWhere((g) => g.id == group.id);

//       if (index != -1) {
//         _groups[index] = group;
//         notifyListeners();
//       }

//     } catch (e) {
//       print('Error in update group data of catch: $e');
//     }
//   }

//   // Delete group form Firestore
//   Future<void> deleteGroup(String docId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('Admins')
//           .doc(adminNumber)
//           .collection('Groups')
//           .doc(docId)
//           .delete();

//       _groups.removeWhere((g) => g.id == int.parse(docId));
//       notifyListeners();

//     } catch (e) {
//       print('Error in delete group data: $e');
//     }
//   }
// }