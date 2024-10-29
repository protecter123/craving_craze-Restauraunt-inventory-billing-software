class UserProfile {
  String name, email, phone, profile;
  DateTime createdAt;
  bool percent,
      add,
      subtract,
      copyreciept,
      checkoutInClient,
      createPLU,
      customer,
      deliveryboy,
      itemClear,
      openDrawer,
      promoter,
      qty,
      returnMerchent,
      refund,
      report,
      stock,
      tVoid,
      tNPrt,
      taxShiftAndExempt,
      isVerified,
      amount,
      purchaseOf,
      level2,
      level3,
      tNVoid;

  UserProfile(
      {required this.name,
      required this.email,
      required this.phone,
      required this.profile,
      required this.createdAt,
      required this.percent,
      required this.add,
      required this.subtract,
      required this.copyreciept,
      required this.checkoutInClient,
      required this.createPLU,
      required this.customer,
      required this.deliveryboy,
      required this.itemClear,
      required this.openDrawer,
      required this.promoter,
      required this.qty,
      required this.amount,
      required this.stock,
      required this.isVerified,
      required this.level2,
      required this.level3,
      required this.purchaseOf,
      required this.refund,
      required this.report,
      required this.returnMerchent,
      required this.tNPrt,
      required this.tNVoid,
      required this.tVoid,
      required this.taxShiftAndExempt});
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phone,
      'profile': profile,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'percent': percent,
      'add': add,
      'subtract': subtract,
      'copyreciept': copyreciept,
      'checkoutInClient': checkoutInClient,
      'createPLU': createPLU,
      'customer': customer,
      'deliveryboy': deliveryboy,
      'itemClear': itemClear,
      'openDrawer': openDrawer,
      'promoter': promoter,
      'qty': qty,
      'amount': amount,
      'purchaseOf': purchaseOf,
      'level2': level2,
      'level3': level3,
      'stock': stock,
      'isVerified': isVerified,
      'tNPrt': tNPrt,
      'taxShiftAndExempt': taxShiftAndExempt,
      'tVoid': tVoid,
      'returnMerchent': returnMerchent,
      'refund': refund,
      'report': report,
      'tNVoid': tNVoid,
    };
  }

  static UserProfile fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'],
      email: map['email'],
      phone: map['phoneNumber'],
      profile: map['profile'],
      createdAt: map['createdAt'],
      percent: map['percent'],
      add: map['add'],
      subtract: map['subtract'],
      copyreciept: map['copyreciept'],
      checkoutInClient: map['checkoutInClient'],
      createPLU: map['createPLU'],
      customer: map['customer'],
      deliveryboy: map['deliveryboy'],
      itemClear: map['itemClear'],
      openDrawer: map['openDrawer'],
      promoter: map['promoter'],
      qty: map['qty'],
      amount: map['amount'],
      purchaseOf: map['purchaseOf'],
      level2: map['level2'],
      level3: map['level3'],
      stock: map['stock'],
      isVerified: map['isVerified'],
      tNPrt: map['tNPrt'],
      taxShiftAndExempt: map['taxShiftAndExempt'],
      tVoid: map['tVoid'],
      returnMerchent: map['returnMerchent'],
      refund: map['refund'],
      report: map['report'],
      tNVoid: map['tNVoid'],
    );
  }
}

class AdminProfile {
  String name, address, email, phone;

  AdminProfile(
      {required this.name,
      required this.address,
      required this.email,
      required this.phone});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'email': email,
      'phoneNumber': phone,
    };
  }

  static AdminProfile fromMap(Map<String, dynamic> map) {
    return AdminProfile(
      name: map['name'],
      address: map['address'],
      email: map['email'],
      phone: map['phoneNumber'],
    );
  }
}

class Brand {
  String image, name;

  Brand({required this.image, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
    };
  }
  static Brand fromMap(Map<String, dynamic> map) {
    return Brand(
      image: map['image'],
      name: map['name'],
    );

  }
  
}

class Category {
  String image;
  String name;

  Category({required this.image, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      image: json['Image'],
      name: json['Name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Image': image,
      'Name': name,
    };
  }
}

// class SubCategory {
//   String name;

//   SubCategory({required this.name});

//   factory SubCategory.fromJson(Map<String, dynamic> json) {
//     return SubCategory(
//       name: json['name'],
//     );
//   }
// }

class User {
  String uId;
  String name;
  String email;
  String address;
  List<String> profiles;
  List<String> subCategories;
  List<Category> categories;
  List<Brand> brands;

  User(
    { required this.uId,
      required this.name,
      required this.email,
      required this.address,
      required this.profiles,
      required this.subCategories,
      required this.categories,
      required this.brands});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uId: json['uId'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
      profiles: json['profiles'].cast<String>()??[],
      subCategories: json['subCategories'].cast<String>()??[],
          // .map((json) => SubCategory.fromJson(json))
          // .toList(),
      categories:
          json['categories'].map((json) => Category.fromJson(json)).toList(),
      brands: json['brands'].map((json) => Brand.fromMap(json)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'address': address,
      'profiles': profiles,
      'subCategories': subCategories,
      // .map((subCategory) => subCategory.toJson()).toList(),
      'categories': categories.map((category) => category.toJson()).toList(),
      'brands': brands.map((brand) => brand.toMap()).toList(),
    };
  }
}
