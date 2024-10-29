// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'otp_provider.dart'; // Import your provider
//
// class CustomOtpInput extends StatefulWidget {
//   final int length;
//   final double boxSize;
//   final Color fillColor;
//   final Color borderColor;
//   final Color focusedBorderColor;
//   final TextStyle textStyle;
//
//   const CustomOtpInput({
//     super.key,
//     required this.length,
//     this.boxSize = 50,
//     this.fillColor = const Color(0xFFEEEEEE),
//     this.borderColor = Colors.grey,
//     this.focusedBorderColor = Colors.blue,
//     this.textStyle = const TextStyle(fontSize: 20),
//   });
//
//   @override
//   CustomOtpInputState createState() => CustomOtpInputState();
// }
//
// class CustomOtpInputState extends State<CustomOtpInput> {
//   late List<FocusNode> _focusNodes;
//   late List<TextEditingController> _controllers;
//
//   @override
//   void initState() {
//     super.initState();
//     _focusNodes = List.generate(widget.length, (index) => FocusNode());
//     _controllers = List.generate(widget.length, (index) => TextEditingController());
//
//     for (var i = 0; i < widget.length; i++) {
//       _focusNodes[i].addListener(() {
//         // No need to call setState here
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   void _onChanged(String value, int index) {
//     if (value.length == 1) {
//       // Update the OTP in the provider
//       Provider.of<OtpProvider>(context, listen: false).updateOtp(
//           _controllers.map((controller) => controller.text).join() + value);
//       if (index < widget.length - 1) {
//         _focusNodes[index + 1].requestFocus();
//       } else {
//         _focusNodes[index].unfocus();
//         // Optionally notify completion if necessary
//       }
//     } else if (value.isEmpty && index > 0) {
//       // Update the OTP in the provider when deleting a character
//       Provider.of<OtpProvider>(context, listen: false).updateOtp(
//           _controllers.map((controller) => controller.text).join());
//       _focusNodes[index - 1].requestFocus();
//     }
//
//     // No need to call setState here to prevent flickering
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(
//         widget.length,
//             (index) => Container(
//           width: widget.boxSize,
//           height: widget.boxSize,
//           margin: const EdgeInsets.symmetric(horizontal: 5),
//           decoration: BoxDecoration(
//             color: widget.fillColor,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: _focusNodes[index].hasFocus
//                   ? widget.focusedBorderColor
//                   : widget.borderColor,
//               width: _focusNodes[index].hasFocus ? 2 : 1,
//             ),
//           ),
//           child: TextField(
//             controller: _controllers[index],
//             focusNode: _focusNodes[index],
//             textAlign: TextAlign.center,
//             keyboardType: TextInputType.number,
//             style: widget.textStyle,
//             maxLength: 1,
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               counterText: '',
//             ),
//             inputFormatters: [
//               FilteringTextInputFormatter.digitsOnly,
//             ],
//             onChanged: (value) => _onChanged(value, index),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class OtpInput extends StatefulWidget {
  final int length;

  const OtpInput({super.key, this.length = 4});

  @override
  _OtpInputState createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 40,
          height: 50,
          child: TextField(
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            onChanged: (value) {
              if (value.isNotEmpty) {
                // context.read<OTPProvider>().updateOTP(value as int);
                // Move to next field if not the last one
                if (index < widget.length - 1) {
                  FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                }
              } else if (index > 0) {
                // Move back to previous field if cleared
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
            },
            decoration: const InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
            ),
          ),
        );
      }),
    );
  }
}