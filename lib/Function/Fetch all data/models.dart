// class Brand {
//   final String image;
//   final String name;

//   Brand({required this.image, required this.name});

//   factory Brand.fromMap(Map<String, dynamic> map) {
//     return Brand(
//       image: map['Image'] ?? '',
//       name: map['Name'] ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'image': image,
//       'name': name,
//     };
//   }
// }

class Customer {
  final String address;
  final int balance;
  final int balanceLimit;
  final int code;
  final String createdBy;
  final String email;
  final String mobileNumber;
  final String name;
  final int priceControlLevel;
  final String zipCode;

  Customer({
    required this.address,
    required this.balance,
    required this.balanceLimit,
    required this.code,
    required this.createdBy,
    required this.email,
    required this.mobileNumber,
    required this.name,
    required this.priceControlLevel,
    required this.zipCode,
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      address: map['address'] ?? '',
      balance: map['balance'] ?? 0,
      balanceLimit: map['balance_limit'] ?? 0,
      code: map['code'] ?? 0,
      createdBy: map['created_by'] ?? '',
      email: map['email'] ?? '',
      mobileNumber: map['mobile_number'] ?? '',
      name: map['name'] ?? '',
      priceControlLevel: map['price_control_level'] ?? 0,
      zipCode: map['zip_code'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'balance': balance,
      'balanceLimit': balanceLimit,
      'code': code,
      'createdBy': createdBy,
      'email': email,
      'mobileNumber': mobileNumber,
      'name': name,
      'priceControlLevel': priceControlLevel,
      'zipCode': zipCode,
    };
  }
}

// Similarly, define models for Groups and Users
