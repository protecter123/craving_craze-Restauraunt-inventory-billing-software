// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craving_craze/Utils/Global/global.dart';
import 'package:craving_craze/Widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Function/Firebase/get_data.dart';

class AddC extends StatefulWidget {
  final int counts;
  final DocumentSnapshot<Object?>? customerData;
  const AddC({super.key, required this.counts, this.customerData});

  @override
  AddCState createState() => AddCState();
}

class AddCState extends State<AddC> {
  // int get counts => widget.count;
  final _formKey = GlobalKey<FormState>();
  // Form fields
  int _priceControl = 1; // Default price control level
  // int _autoIncrementCode = widget.counts;
  // final int _autoIncrementCode = counts+1;
  // double _autoDiscount = 0.0;
  bool _isActive = true; // Checkbox default value

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _balanceLimitController = TextEditingController();
  final TextEditingController _gstinController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _l8Controller = TextEditingController();
  final TextEditingController _l9Controller = TextEditingController();

  // Firebase Service
  final FirebaseService _firebaseService = FirebaseService();

  //  int get counts => widget.counts+1;
  int counts = 0;

  @override
  void initState() {
    super.initState();
    counts = widget.counts;
    if (widget.customerData != null) {
      // If customer data exists (edit mode), populate the fields
      var data = widget.customerData!.data() as Map<String, dynamic>;

      _nameController.text = data['name'] ?? '';
      _balanceController.text = data['balance']?.toString() ?? '';
      _balanceLimitController.text = data['balance_limit']?.toString() ?? '';
      _gstinController.text = data['gstin'] ?? '';
      _mobileController.text =
          data['mobile_number']?.substring(3) ?? ''; // Remove +91
      _addressController.text = data['address'] ?? '';
      _zipCodeController.text = data['zip_code'] ?? '';
      _emailController.text = data['email'] ?? '';
      _discountController.text = data['auto_discount_percent'] ?? '';
      _priceControl = data['price_control_level'] ?? 1;
      _isActive = data['is_active'] ?? true;
    } else {
      counts += 1;
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _balanceController.dispose();
    _balanceLimitController.dispose();
    _gstinController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _zipCodeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Customer')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Tablet and Desktop
            return _buildForm(isMobile: false);
          } else {
            // Mobile
            return _buildForm(isMobile: true);
          }
        },
      ),
    );
  }

  // Build form UI with responsiveness
  Widget _buildForm({required bool isMobile}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Code: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$counts'),
                const Spacer(
                  flex: 2,
                ),
                _buildStatusField(),
                const Spacer()
              ],
            ),

            _buildFieldWithLabel('Name', _buildNameField()),
            _buildFieldWithLabel('Balance', _buildBalanceField()),
            _buildFieldWithLabel('Balance Limit', _buildBalanceLimitField()),
            _buildPriceControlField(),
            // _buildAutoDiscountField(),
            _buildFieldWithLabel('GSTIN (Optional)', _buildGstinField()),
            _buildFieldWithLabel('Mobile Number', _buildMobileNumberField()),
            _buildFieldWithLabel('Address', _buildAddressField()),
            _buildFieldWithLabel('Zip Code', _buildZipCodeField()),
            _buildFieldWithLabel('Email', _buildEmailField()),
            _buildFieldWithLabel(
                'L8', buildTextFormField(controller: _l8Controller)),
            _buildFieldWithLabel(
                'L9', buildTextFormField(controller: _l9Controller)),
            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Generic field builder with label
  Widget _buildFieldWithLabel(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        field,
        const SizedBox(height: 16),
      ],
    );
  }

  // Widget _buildIsActiveCheckbox() {
  //   return CheckboxListTile(
  //     title: const Text("Active"),
  //     value: _isActive,
  //     onChanged: (bool? value) {
  //       setState(() {
  //         _isActive = value ?? true; // Update the checkbox state
  //       });
  //     },
  //     controlAffinity: ListTileControlAffinity.leading, // Align the checkbox to the left
  //   );
  // }

  // Price control radio buttons
  Widget _buildPriceControlField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price Control',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              if (index == 3) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Radio(
                            activeColor: Colors.black,
                            groupValue: _priceControl,
                            value: index + 1,
                            onChanged: (value) {
                              setState(() {
                                _priceControl = value!;
                                // _autoDiscount = _getDiscountBasedOnLevel(_priceControl);
                              });
                            }),
                        const Text('Auto Discount (%)'),
                      ],
                    ),
                    if (_priceControl == 4) _buildDiscountField(),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Radio(
                        activeColor: Colors.black,
                        groupValue: _priceControl,
                        value: index + 1,
                        onChanged: (value) {
                          setState(() {
                            _priceControl = value!;
                            // _autoDiscount = _getDiscountBasedOnLevel(_priceControl);
                          });
                        }),
                    Text('Level ${index + 1}'),
                  ],
                );
              }
            })),
        // Row(
        //   children: List.generate(3, (index) {
        //     return Expanded(
        //       child: RadioListTile<int>(
        //         materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
        //         contentPadding: const EdgeInsets.all(0),
        //         activeColor: Colors.black,
        //         dense: true,
        //         title: Text('Level ${index + 1}',style: const TextStyle(fontSize:14),),
        //         value: index + 1,
        //         groupValue: _priceControl,
        //         onChanged: (value) {
        //           setState(() {
        //             _priceControl = value!;
        //             _autoDiscount = _getDiscountBasedOnLevel(_priceControl);
        //           });
        //         },
        //       ),
        //     );
        //   }),
        // ),
        // const SizedBox(height: 16),

        const SizedBox(height: 16),
      ],
    );
  }

  // Auto discount display based on price control level
  Widget _buildAutoDiscountField() {
    return _buildFieldWithLabel('Auto Discount (%)', _buildDiscountField()
        //  Text('${_autoDiscount.toStringAsFixed(2)}%')
        );
  }

  Widget _buildDiscountField() {
    return TextFormField(
      controller: _discountController,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2)
      ],
      // initialValue: '0.0',
      keyboardType: TextInputType.number,
      // onChanged: (value) {
      //   setState(() {
      //     _autoDiscount = double.parse(value);
      //   });
      // },
    );
  }

  // Sample TextFormField for customer name
  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter customer name';
        return null;
      },
    );
  }

  // Other fields follow the same structure as _buildNameField
  Widget _buildBalanceField() {
    return TextFormField(
      controller: _balanceController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter balance';
        return null;
      },
    );
  }

  Widget _buildBalanceLimitField() {
    return TextFormField(
      controller: _balanceLimitController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter balance limit';
        return null;
      },
    );
  }

  Widget _buildGstinField() {
    return TextFormField(
      controller: _gstinController,
      inputFormatters: [
        // FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(15)
      ],
      // validator: (value) {
      //   if (value == null || value.isEmpty) return 'Please enter GSTIN';
      //   return null;
      // },
    );
  }

  Widget _buildMobileNumberField() {
    return TextFormField(
      controller: _mobileController,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10)
      ],
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
          // hintText: 'Enter Mobile Number',

          prefix: Text('+91 ')),
      validator: (value) {
        if (value == null || !RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
          return 'Enter valid mobile number';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      maxLines: 3,
      controller: _addressController,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter address';
        return null;
      },
    );
  }

  Widget _buildZipCodeField() {
    return TextFormField(
      controller: _zipCodeController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6)
      ],
      validator: (value) {
        if (value == null || value.length != 6) {
          return 'Enter valid 6 digit zip code';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter valid email';
        }
        return null;
      },
    );
  }

  // Submit button
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () => _submitForm(),
      child: Text(widget.customerData != null ? 'Update' : 'Submit'),
    );
  }

  // Discount logic based on price control level
  double _getDiscountBasedOnLevel(int level) {
    switch (level) {
      case 1:
        return 5.0;
      case 2:
        return 10.0;
      case 3:
        return 15.0;
      default:
        return 0.0;
    }
  } //write widget for checkbox active by default

  Widget _buildStatusField() {
    return Row(
      children: [
        // Text('Status: '),
        // SizedBox(width: 10),
        Checkbox(
            value: _isActive,
            onChanged: (bool? value) {
              setState(() {
                _isActive = value ?? true; // Update the checkbox state
              });
            }),
        _status(_isActive)
      ],
    );
  }

  Widget _status(bool status) {
    return Text(status ? 'Active' : 'Inactive');
  }

  // Handle form submission
  Future<void> _submitForm() async {
    String? adminNumber = SharedPreferencesHelper.getString('adminNumber'),
        userNumber = SharedPreferencesHelper.getString('userNumber');
    if (_formKey.currentState!.validate()) {
      // Generate unique auto increment code
      // int _autoIncrementCode = widget.counts+1;
      // Collect form data
      Map<String, dynamic> customerData = {
        'created_by': userNumber,
        'code': counts,
        'name': _nameController.text.trim(),
        'balance': double.parse(_balanceController.text.trim()),
        'balance_limit': double.parse(_balanceLimitController.text.trim()),
        'price_control_level': _priceControl,
        'auto_discount_percent': _discountController.text.trim(),
        'gstin': _gstinController.text.trim(),
        'mobile_number': '+91${_mobileController.text.trim()}',
        'address': _addressController.text.trim(),
        'zip_code': _zipCodeController.text.trim(),
        'email': _emailController.text.trim(),
        'is_active': _isActive,
        'created_at': FieldValue.serverTimestamp(), // Optional: Timestamp
        'l8': _l8Controller.text.trim(),
        'l9': _l9Controller.text.trim()
      };

      try {
        if (widget.customerData != null) {
          _firebaseService.updateCustomer(
              path: widget.customerData!.reference.path,
              customerData: customerData);
          // await FirebaseFirestore.instance
          // .doc(widget.customerData!.reference.path) // Use existing document path
          // .update(customerData);
        } else {
          // Upload to Firebase
          String customerNumber = '+91${_mobileController.text.trim()}';
          await _firebaseService.addCustomer(
            customerNumber: customerNumber,
            adminNumber: adminNumber!,
            // userNumber: userNumber!,

            customerData: customerData,
          );
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Customer save successfully')),
        );

        // Optionally, reset the form or navigate away
        // _formKey.currentState!.reset();
        // setState(() {
        //   _isActive = true;
        //   _priceControl = 1;
        //   // _autoDiscount = _getDiscountBasedOnLevel(_priceControl);
        //   // _autoIncrementCode += 1; // Increment code for next customer
        // });
      } catch (e) {
        // Handle errors by showing a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
        // Optionally, log the error or send it to an error tracking service
        print('Error adding customer: $e');
      } finally {
        //Navigate to the previous
        Navigator.pop(context, true);
      }
    }
  }
}
