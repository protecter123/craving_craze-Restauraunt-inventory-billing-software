import 'package:country_code_picker/country_code_picker.dart';
import 'package:craving_craze/Screens/Splash/Connectivity/connectivity_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


import '../../../Utils/Global/global.dart';
import '../../../Utils/utils.dart';
import '../../../Widgets/widgets.dart';
import '../OTP Screen/otp.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final TextEditingController _phoneController = TextEditingController();
  String _countryCode = '+91';
  bool _isValidNumber = false;
  final FocusNode _focusNode = FocusNode();

  bool _isLoading = false;

  void _validatePhoneNumber(String value) {
    setState(() {
      _isValidNumber = value.length == 10 && RegExp(r'^[6789]').hasMatch(value);
      if (value.length == 10) _focusNode.unfocus();
    });
  }

  void _clearPhoneNumber() {
    _phoneController.clear();
    setState(() {
      // _isValidNumber = true;
    });
  }

  Future<void> _sendOtp() async {
    final ConnectivityModel connectivityModel =
    Provider.of<ConnectivityModel>(context, listen: false);
    if (_isValidNumber && connectivityModel.hasInternet) {
      setState(() {
        _isLoading = true;
      });
      final phone = '$_countryCode${_phoneController.text}';
      SharedPreferencesHelper.setString('number', phone);
      try {
        Map<String, bool> status = await checkAdminOrUserExists(phone);
        if (status['isAdmin']! || status['isUser']!) {
        await _sendVerificationCode(phone);
      } else {
        _showErrorBottomSheet('Admin doesn\'t allow this number');
      }
        // await FirebaseAuth.instance.verifyPhoneNumber(
        //   phoneNumber: phone,
        //   verificationCompleted: (PhoneAuthCredential credential) {},
        //   verificationFailed: (FirebaseAuthException e) {
        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       content: Text('Failed to verify Phone Number:${e.message}'),
        //     ));
        //   },
        //   codeSent: (String verificationId, int? resendToken) {
        //     push(context, Otp(verificationId: verificationId, phone: phone));
        //   },
        //   codeAutoRetrievalTimeout: (String verificationId) {},
        // );

      }catch(e){
         _showErrorBottomSheet('Error occurred: $e');

         print("connectivity: ${connectivityModel.hasInternet}");
      }
      finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // connectivityModel.hasInternet?
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Center(child: Text('Please enter a valid phone number'))),
      )
      // :NoConnection()
      ;
    }
  }

Future<void> _sendVerificationCode(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      
      verificationCompleted: (credential) {
        
        print('Auto verification completed: $credential');
      },
      verificationFailed: (e) {
        print('Verification failed: ${e.message}');
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to verify Phone Number:${e.message}'),
            ));
      },
      codeSent: (verificationId, resendToken) {
        push(context, Otp(
              verificationId: verificationId,
              phone: phone),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) => print('Auto retrieval timeout: $verificationId'),
      timeout: const Duration(seconds: 60),
    );
  }

// Future<bool> _checkUserExists(String phoneNumber) async {
//     final adminDoc = await FirebaseFirestore.instance.collection('Admin').doc(phoneNumber).get();
//  CollectionReference admin = FirebaseFirestore.instance.collection('Admin');
//     QuerySnapshot querySnapshot = await admin.get();
//     for (QueryDocumentSnapshot userDoc in querySnapshot.docs) {

//      DocumentReference userDocRef =  userDoc.reference.collection('Users').doc(phoneNumber);
//      DocumentSnapshot userSnapshot =  await userDocRef.get();
//   bool success = userSnapshot.exists;
//     }
    
//     // If user or admin document does not exist, return false
//     return userDoc.exists || adminDoc.exists;
//   }



   void _showErrorBottomSheet(String message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 30),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(color: Colors.black, fontSize: 16)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }


  //
  // @override
  // void dispose() {
  //   _phoneController.dispose();
  //   _focusNode.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ConnectivityModel>(
        builder: (context,model,child){
          return
          // model.hasInternet?
          
          Scaffold(
          backgroundColor: lm,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Lottie.asset('assets/animations/phone.json'),
                Gap.h(150),

                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset('assets/images/logo.png',height: 80,width: 100,fit: BoxFit.cover,)),
                Gap.h(20),
                Text(
                  'Phone Verification',
                  style: textTheme.titleMedium,
                ),
                Gap.h(10),
                Text(
                  'We need to register your phone before\ngetting started!',
                  style: textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
                Gap.h(20),
                Container(
                  alignment: Alignment.centerLeft,
                  height: MediaQuery.of(context).size.height / 17,
                  padding: const EdgeInsets.symmetric(horizontal: .1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CountryCodePicker(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                        flagWidth: 45,
                        // showOnlyCountryWhenClosed: true,
                        showCountryOnly: true,
                        showFlagDialog: true,
                        showFlag: true,
                        // showDropDownButton: true,
                        hideMainText: true,
                        // alignLeft: true,
                        // onInit:(countryCode){
                        //   setState(() {
                        //     _countryCode = countryCode.toString();
                        //   });
                        // },
                        onChanged: (countryCode) {
                          setState(() {
                            _countryCode = countryCode.toString();
                          });
                        },
                        initialSelection: 'IN',
                        favorite: const ['IN'],
                      ),
                      const SizedBox(
                        height: 30,
                        child: VerticalDivider(
                          thickness: 1,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: TextField(
                            focusNode: _focusNode,
                            textAlignVertical: TextAlignVertical.top,
                            // scrollPadding: ,
                            controller: _phoneController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintTextDirection: TextDirection.ltr,
                              contentPadding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                              hintText: 'Enter phone number',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              // suffixIcon:
                            ),
                            onChanged: _validatePhoneNumber,
                          ),
                        ),
                      ),
                      _phoneController.text.isNotEmpty
                          ? !_isValidNumber
                          ? IconButton(
                        icon: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Center(
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 15,
                              ),
                            )),
                        onPressed: _clearPhoneNumber,
                      )
                          : const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: buildBottomButton(
            context,
            textTheme,
            'Next',
            _isLoading,
            _isValidNumber
                ? _sendOtp
                : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please enter a valid phone number')),
              );
            },
          ))
          // :NoConnection()
          ;
        }

      ),
    );
  }
}
