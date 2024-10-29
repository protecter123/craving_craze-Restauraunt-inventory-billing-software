import 'package:craving_craze/Utils/Global/global.dart';
import 'package:flutter/material.dart';
import 'customer_service.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerService _customerService = CustomerService();
  List<Map<String, String>> transactions = [];
  bool isLoading = true;

  Future<void> loadCustomers() async {
    isLoading = true;
    notifyListeners();
    String adminId = adminNumber!;
    transactions = await _customerService.fetchAllCustomers(adminId);
    // print('transactions: ' + $transactions);
    isLoading = false;
    notifyListeners();
  }
}
