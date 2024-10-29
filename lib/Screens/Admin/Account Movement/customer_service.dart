import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, String>>> fetchAllCustomers(String adminId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> customerSnapshot = await _firestore
          .collection('Admins')
          .doc(adminId)
          .collection('Customers')
          .get();

      if (customerSnapshot.docs.isEmpty) {
        print('No customers found');
        return [];
      }
      return customerSnapshot.docs.map((doc) {
        final data = doc.data();
        print('data: ${data['code']}');
        return {
          'code': data['code'].toString(),
          'date': (data['created_at'] as Timestamp).toDate().toString(),
          'type': 'Open account',
          'changed': '0.00',
          'balance': data['balance'].toString(),
          'clerk': data['created_by'].toString(),
        };
      }).toList();
    } catch (e) {
      print('Error fetching customer data: $e');
      return [];
    }
  }
}
