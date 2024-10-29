import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OTPProvider with ChangeNotifier {
  List<String> _otp = List.filled(6, '');

   String get otp => _otp.join('');

  void updateOTP(int index, String value) {
    _otp[index] = value;
    notifyListeners();
  }


  void clearOTP() {
    _otp = List.filled(6, '');
    notifyListeners();
  }
}


class OTPInput1 extends StatelessWidget {
  const OTPInput1({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OTPProvider>(
      builder: (context, otpProvider, child) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                growable: false,
                6, (index) {
              return SizedBox(
                width: 40,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  autofocus: index == 0,
                  onChanged: (value) {
                    if (value.length == 1) {
                      otpProvider.updateOTP(index, value);
                      // Move to next field
                      if (index < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                    } else if (value.isEmpty) {
                      otpProvider.updateOTP(index, '');
                      // Move to previous field
                      if (index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    }
                  },
                  decoration: const InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(),
                  ),
                ),
              );
            }));
      },
    );
  }
}