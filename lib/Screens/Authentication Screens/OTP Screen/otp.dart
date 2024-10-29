import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craving_craze/Screens/Admin/admin_home.dart';
import 'package:craving_craze/Screens/Users/user_home.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

import '../../../Utils/Global/global.dart';
import '../../../Utils/utils.dart';
import '../../../Widgets/widgets.dart';
import '../Phone Auth Screen/phone_auth.dart';

class Otp extends StatefulWidget {
  final String verificationId, phone;

  const Otp({super.key, required this.verificationId, required this.phone});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  // final List<TextEditingController> _otpControllers =
  // List.generate(6, (_) => TextEditingController());
  final TextEditingController _otpController = TextEditingController();
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _secondsRemaining = 30;
  bool _isResendAvailable = false, _isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _isResendAvailable = false;
    _secondsRemaining = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isResendAvailable = true;
          timer.cancel();
        }
      });
    });
  }

  void _resendOtp() {
    _startTimer();
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to Resend OTP: ${e.message}')));
      },
      codeSent: (String verificationId, int? resendToken) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('OTP Resent')));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

  }

  void _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    // String otp = _otpControllers.map((controller) => controller.text).join();
    String otp = _otpController.text;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Phone number verified successfully')));
        await navigateToNextScreen();

        // SharedPreferences prefs = await SharedPreferences.getInstance();

        // await SharedPreferencesHelper.setString('number', widget.phone);
        // bool userExists = await checkIfUserExists(widget.phone);

        // if (userExists) {
        //   // Get user data
        //   Map<String, dynamic>? userData = await getUserData(widget.phone);

        //   if (userData != null) {
        //     // Save user data to SharedPreferences
        //     bool isVerified = userData['isVerified'] ?? false;

        //     await saveUserDataToSharedPreferences(userData);

        //     // Navigate to the home page if the user exists
        //     mounted ? remove(context, Splash2(isVerified: isVerified,)) : null;
        //     setState(() {
        //       _isLoading = false;
        //     });
        //     return;
        //   }
        // }
        // mounted
        //     ? remove(context, const BnbIndex()
        //     // userExists ? const Splash2() : PersonalInfo(number: widget.phone)
        //     )
        //     : null;
      }
    } catch (e) {
      if (mounted) {
        if (kDebugMode) {
          print('Failed to verify OTP: $e');
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(child: Text('Please enter OTP/ Invalid OTP'))));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> navigateToNextScreen() async {
    final phoneNumber = widget.phone;
    SharedPreferencesHelper.setString('phoneNumber', phoneNumber);
    Map<String, bool> status = await checkAdminOrUserExists(phoneNumber);
    if (status['isAdmin']! && mounted) {
      //check if it's Admin or User
      // var adminSnapshot = await FirebaseFirestore.instance.collection('Admin').doc(phoneNumber).get();
      // if (adminSnapshot.exists && mounted) {
      SharedPreferencesHelper.setString('adminNumber', phoneNumber);

      // Navigator.pushReplacement
      remove(
          context,

          // MaterialPageRoute(builder: (context) =>
          const AdminHome()
          // ),
          );

      // }
    } else if (status['isUser']! && mounted) {
      SharedPreferencesHelper.setString('userNumber', phoneNumber);

      // Navigator.pushReplacement
      remove(
          context,
          // MaterialPageRoute(builder: (context) =>
          const UserHome()
          // ),
          );
    } else {
      (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Users or Admin not found')),
        );
      };
    }
  }

  void _clearAllBoxes() {
    // for (var controller in _otpControllers) {
    //   controller.clear();
    // }
    _otpController.clear();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // @override
  // void dispose() {
  //   _timer?.cancel();
  //   for (var controller in _otpControllers) {
  //     controller.dispose();
  //   }
  //   for (var node in _focusNodes) {
  //     node.dispose();
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          // backgroundColor: m,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Center(
              child: Column(children: [
                Lottie.asset(
                  'assets/animations/otp.json',
                  height: 300,
                  width: 300,
                ),
                Text(
                  'Please verify your account by entering the OTP sent to ${widget.phone}.',
                  style: textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Gap.h(10),
                Text(
                  'Enter your OTP',
                  style: textTheme.titleMedium,
                ),
                Gap.h(15),
                // Stack(
                //   children: [
                //     Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                //       ...List.generate(6, (index) => _buildOtpBox(index)),
                //
                //     ]),
                //     Positioned(
                //       top: 11,
                //       right: -.1,
                //       child: GestureDetector(
                //           onTap: _clearAllBoxes,
                //           child: const CircleAvatar(
                //               radius: 10,
                //               backgroundColor: Colors.red,
                //               child: Center(
                //                 child: Icon(
                //                   Icons.clear,
                //                   color: Colors.white,
                //                   size: 15,
                //                 ),
                //               ))),
                //     )
                //   ],
                // ),
                Gap.h(10),
                // CustomOtpInput(
                //   length: 6,
                //   onCompleted: _verifyOtp,
                //   fillColor: Colors.white,
                //   borderColor: Colors.grey,
                //   focusedBorderColor: Colors.blue,
                //   textStyle: TextStyle(fontSize: 20),
                // ),
// OTPInput1(),
                Pinput(
                  // defaultPinTheme:PinTheme(
                  //   height: 40,width: 40,textStyle: TextStyle(fontSize: 18),
                  //   decoration: BoxDecoration(
                  //     color: sec
                  //   )
                  //
                  // ),
                  length: 6,
                  controller: _otpController,
                  onChanged: (value) {
                    if(_otpController.length ==6){
                    _verifyOtp();
                    }
                  },
                 
                ),
                Gap.h(15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      '$_secondsRemaining seconds',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    // const Spacer(flex: 4,),
                    Gap.w(MediaQuery.of(context).size.width/6),
                    
                    Text(
                      overflow: TextOverflow.ellipsis,
                      
                      "Didn't receive OTP?",
                      style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                    InkWell(
                        onTap: () => _isResendAvailable ? _resendOtp : null,
                        child: Text(
                          'Resend',
                          style: textTheme.bodyMedium?.copyWith(
                              color: _isResendAvailable
                                  ? Colors.blue
                                  : Colors.grey),
                        ))
                  ],
                ),
                Gap.h(20),
                Wrap(
                  runSpacing: 10,
                  spacing: 20,
                  // alignment: WrapAlignment.center,
                // runAlignment: WrapAlignment.center,
                  children: [Text(
                    'If the OTP is invalid. Please check or edit the phone number and resend the OTP.',
                    style: textTheme.bodyMedium,
                  ),
                
                GestureDetector(
                  onTap: () => remove(context, const PhoneAuth()),
                  child: Text(
                    'Click here to edit number',
                    style: textTheme.bodyMedium?.copyWith(
                        color: Colors.orangeAccent,
                        fontStyle: FontStyle.italic),
                    // textAlign: TextAlign.left,
                  ),
                ),])
              ]),
            ),
          ),
          bottomNavigationBar: buildBottomButton(
              context, textTheme, 'Next', _isLoading, _verifyOtp)
          // ElevatedButton(onPressed: _verifyOtp, child: const Text('Next')),
          ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: m.withOpacity(.3), borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: TextFormField(
          cursorColor: m,
          cursorHeight: 21,
          controller: TextEditingController(
            text: _otpController.text.length > index
                ? _otpController.text[index]
                : '',
          ),
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(bottom: 6),
          ),
          autocorrect: false,
          enableSuggestions: false,
          // onChanged: (value) {
          //   if (value.isNotEmpty) {
          //     // Move focus immediately without delay
          //     if (index < _otpControllers.length - 1) {
          //       FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          //     } else {
          //       FocusScope.of(context).unfocus();
          //     }
          //   } else {
          //     // Clear the current OTP box only
          //     _otpControllers[index].clear();
          //   }
          // },

          onChanged: (value) {
            if (value.isNotEmpty) {
              if (_otpController.text.length <= index) {
                _otpController.text += value;
              } else {
                _otpController.text =
                    _otpController.text.replaceRange(index, index + 1, value);
              }
              if (index < 5) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else {
                FocusScope.of(context).unfocus();
              }
            } else if (_otpController.text.length > index) {
              _otpController.text =
                  _otpController.text.replaceRange(index, index + 1, '');
              if (index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
            }
            setState(() {});
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1)
          ],
          autofocus: index == 0,
        ),
      ),
    );
  }
}
//   Future<void> saveUserDataToSharedPreferences(
//     Map<String, dynamic> userData) async {
//   await SharedPreferencesHelper.setString('name', userData['name'] ?? '');
//   await SharedPreferencesHelper.setString('dob', userData['dob'] ?? '');
//   await SharedPreferencesHelper.setString('email', userData['email'] ?? '');
//   await SharedPreferencesHelper.setString('gender', userData['gender'] ?? '');
//   await SharedPreferencesHelper.setString('panNo', userData['panNo'] ?? '');
//   await SharedPreferencesHelper.setString('aadhaarNo', userData['aadhaarNo'] ?? '');
//   await SharedPreferencesHelper.setString('profileImage', userData['profileImage'] ?? '');
//   await SharedPreferencesHelper.setString('city', userData['city'] ?? '');
//   await SharedPreferencesHelper.setString('state', userData['state'] ?? '');
//   await SharedPreferencesHelper.setString('address', userData['address'] ?? '');
// }

Future<bool> checkIfUserExists(String phoneNumber) async {
  try {
    // Construct the reference to the document
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await FirebaseFirestore.instance
            .collection('Delivery User') // Replace with your collection name
            .doc(phoneNumber) // Assuming phone number is the document ID
            .collection('User Info')
            .doc('Profile')
            .get();

    return docSnapshot.exists;
  } catch (e) {
    // Handle any errors here
    print('Error checking user existence: $e');
    return false; // Assuming user doesn't exist in case of an error
  }
}

Future<Map<String, dynamic>?> getUserData(String phoneN) async {
  final docSnapshot = await FirebaseFirestore.instance
      .collection('Delivery User')
      .doc(phoneN)
      .collection('User Info')
      .doc('Profile')
      .get();

  if (docSnapshot.exists) {
    return docSnapshot.data() as Map<String, dynamic>;
  } else {
    return null;
  }
}
