// class DepartmentModel {
//   final String id;
//   final String name;

//   DepartmentModel({required this.id, required this.name});

//   factory DepartmentModel.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return DepartmentModel(
//       id: doc.id,
//       name: data['name'] ?? '', // Make sure to match the field name from Firestore
//     );
//   }
// }

class DepartmentModel {
  final String sN,
      code,
      description,
      vat,
      group; // Assuming there is an ID field
  final bool enable; // Assuming vatEnabled and vat fields are boolean

  DepartmentModel(
      {required this.code,
      required this.description,
      required this.enable,
      required this.vat,
      required this.group,
      required this.sN});

  // Factory constructor to create an instance from a Map
  factory DepartmentModel.fromMap(Map<String, dynamic> data) {
    return DepartmentModel(
      sN: data[''] as String, // Adjust according to your data structure
      code: data['code'] as String,
      description: data['description'] as String,
      enable: data['vatEnabled'] as bool,
      vat: data['vat'] as String,
      group: data['group'] as String,
    );
  }
}
