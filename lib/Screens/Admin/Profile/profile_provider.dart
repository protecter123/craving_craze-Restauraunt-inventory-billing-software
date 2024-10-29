// providers/user_provider.dart

import 'package:flutter/material.dart';

import 'profile_modal.dart';


class UserProvider with ChangeNotifier {
  User _user = User(
    uId: '', // Provide default values as needed
    name: '',
    email: '',
    address: '',
    profiles: [],
    subCategories: [],
    categories: [],
    brands: [],
  );

  User get user => _user;

  void setUser (User user) {
    _user = user;
    notifyListeners();
  }

  void updateUser (User updatedUser ) {
    _user = updatedUser ;
    notifyListeners();
  }
}