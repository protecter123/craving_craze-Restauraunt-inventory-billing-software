import 'package:cloud_firestore/cloud_firestore.dart';
Future<void> uploadDataToFirebase({
  required String collectionName,
  required String adminNumber,
  required String name,
  required String userNumber,
  required Map<String, dynamic> data,
}) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    await firestore
        .collection(collectionName)
        .doc(adminNumber)
        .collection(name)
        .doc(userNumber)
        .set(data
        // ,SetOptions(merge:true)
    );
    print('Data uploaded successfully');
  } catch (e) {
    print('Error uploading data: $e');
  }
}