import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Screens/Admin/Profile/profile_modal.dart';
import '../../Utils/Global/global.dart';
import '../Fetch all data/models.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _cachedData;

  /// Fetches data from Firestore based on the provided [userId].
  /// If the data is already cached, it returns the cached data.
  /// Otherwise, it fetches the data from Firestore, caches it, and returns it.
  ///
  /// [userId] The unique identifier of the user.
  ///
  /// Returns a [Future] that resolves to a [Map<String, dynamic>] containing the fetched data.
  /// If an error occurs during the fetching process, it returns `null`.
  Future<Map<String, dynamic>?> getData(String userId) async {
    if (_cachedData != null) {
      return _cachedData;
    }
    try {
      DocumentSnapshot snapshot = await _firestore.doc('admin/$userId').get();
      _cachedData = snapshot.data() as Map<String, dynamic>?;
      return _cachedData;
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  /// Adds a new customer to Firestore.
  ///
  /// [adminNumber] The unique identifier of the admin.
  /// [userNumber] The unique identifier of the user.
  /// [customerData] A [Map<String, dynamic>] containing the customer data.
  ///
  /// Returns a [Future] that resolves when the customer is added successfully.
  /// If an error occurs during the adding process, it throws an [Exception].
  Future<void> addCustomer({
    required String adminNumber,
    required String customerNumber,
    // required String userNumber,
    required Map<String, dynamic> customerData,
  }) async {
    try {
      // Define the path: Admins/$adminNumber/Users/$userNumber/Customers
      DocumentReference customerRef = _firestore
          .collection('Admins')
          .doc(adminNumber)
          .collection('Customers')
          .doc(customerNumber);

      await customerRef.set(customerData);
    } catch (e) {
      throw Exception('Failed to add customer: $e');
    }
  }

  Future<void> updateCustomer({
    required String path,
    // required String customerNumber,
    required Map<String, dynamic> customerData,
  }) async {
    try {
      //  await FirebaseFirestore.instance
      //       .doc(widget.customerData!.reference.path) // Use existing document path
      //       .update(customerData);
      await _firestore.doc(path).update(customerData);
    } catch (e) {
      throw Exception('Failed to update customer: $e');
    }
  }

  Future<void> addGroup({
    required String addGroup,
  }) async {
    try {
      await _firestore
          .collection('Admins/$adminNumber/Groups')
          .doc(addGroup)
          .set({});
    } catch (e) {
      throw Exception('Failed to add Group: $e');
    }
  }

  Future<List<Brand>> fetchBrands() async {
    DocumentSnapshot snapshot =
        await _firestore.doc('/Admins/$adminNumber').get();
    List<Brand> brands = [];

    if (snapshot.exists) {
      // Ensure that the data is cast to Map<String, dynamic>
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        List<dynamic> brandData = data['Brands'] ?? [];
        brands = brandData
            .map((data) => Brand.fromMap(data as Map<String, dynamic>))
            .toList();
      }
    }

    return brands;
  }

  Future<List<Brand>> fetchProfile() async {
    DocumentSnapshot snapshot =
        await _firestore.doc('/Admins/$adminNumber').get();
    List<Brand> profiles = [];

    if (snapshot.exists) {
      // Ensure that the data is cast to Map<String, dynamic>
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        List<dynamic> brandData = data['profile'] ?? [];
        profiles = brandData
            .map((data) => Brand.fromMap(data as Map<String, dynamic>))
            .toList();
      }
    }

    return profiles;
  }

  Future<List<Customer>> fetchCustomers() async {
    QuerySnapshot snapshot =
        await _firestore.collection('/Admins/$adminNumber/Customers').get();
    List<Customer> customers = snapshot.docs
        .map((doc) => Customer.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    return customers;
  }

  // services/firebase_service.dart

  Future<User> fetchUser(String userId) async {
    // Fetching user data from Firestore
    final docSnapshot = await _firestore.collection('Admins').doc(userId).get();

    if (docSnapshot.exists) {
      return User.fromJson(docSnapshot.data()!);
    } else {
      throw Exception("Admin not found");
    }
  }

  Future<void> updateUser(User user) async {
    // Updating user data in Firestore
    await _firestore.collection('Admins').doc(user.uId).set({
      'name': user.name,
      'email': user.email,
      'address': user.address,
      'profiles': user.profiles,
      'brands': user.brands
          .map((brand) => {
                'Image': brand.image,
                'Name': brand.name,
              })
          .toList(),
    });
  }
}
