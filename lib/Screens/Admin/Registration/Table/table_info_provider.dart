import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Provider to manage the table information, like number of persons and current date/time.
class TableInfoProvider with ChangeNotifier {
  int personCount = 2;
  String tableNo = "700000";
  String cgstLabel = "CGST/CGST";
  String diningType = "Dine In";
  String currentDateTime =
      DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

  // Toggle between CGST and IGST
  void toggleCgst() {
    cgstLabel = (cgstLabel == "CGST/CGST") ? "IGST" : "CGST/CGST";
    notifyListeners();
  }

  // Set dining type (Dine In, Take Away, Delivery)
  void setDiningType(String type) {
    diningType = type;
    notifyListeners();
  }

  // Update person count
  void updatePersonCount(int count) {
    personCount = count;
    notifyListeners();
  }

  // Update the current date and time
  void updateDateTime() {
    currentDateTime = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    notifyListeners();
  }
}
