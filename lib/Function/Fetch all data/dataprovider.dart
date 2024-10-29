import 'package:flutter/material.dart';

import '../../Screens/Admin/Profile/profile_modal.dart';
import '../Firebase/get_data.dart';
import 'models.dart';
import 'sqlflite.dart';


class DataProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final LocalDatabaseService _localDatabaseService = LocalDatabaseService();

  List<Brand> _brands = [];
  List<Customer> _customers = [];

  List<Brand> get brands => _brands;
  List<Customer> get customers => _customers;

  Future<void> loadBrands() async {
    try {
      _brands = await _firebaseService.fetchBrands();
      await _localDatabaseService.saveBrands(_brands);
    } catch (e) {
      _brands = await _localDatabaseService.getBrands();
    }
    notifyListeners();
  }

  Future<void> loadCustomers() async {
    try {
      _customers = await _firebaseService.fetchCustomers();
      await _localDatabaseService.saveCustomers(_customers);
    } catch (e) {
      _customers = await _localDatabaseService.getCustomers();
    }
    notifyListeners();
  }

  // Similarly, implement methods for Groups and Users
}
