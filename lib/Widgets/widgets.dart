import 'package:craving_craze/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildBottomButton(BuildContext context, TextTheme textTheme, String text,
    bool isLoading, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
    child: ElevatedButton(
      onPressed: onPressed, // Disable button when loading
      child: isLoading
          ? const CircularProgressIndicator(
            strokeWidth: 2,
            strokeCap:StrokeCap.square,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white,),
            )
          : Text(text),
    ),
  );
}

Widget buildTextFormField( {
   String? labelText,
  String? hintText,
  TextEditingController? controller,
  FormFieldValidator<String>? validator,
  void Function(String)? onChanged,
  void Function(String?)? onSave,
  Widget? sIcon,prefix,
  VoidCallback? onTap,
  TextInputType? type,
  List<TextInputFormatter>? inputFormatters,
  bool? obscureText = false,  autovalidate = true,readOnly = false,

  // bool? autovalidateMode = FormFieldAutovalidateMode.onSubmit,
  bool enabled = true,
  
  
  
}) {
  return TextFormField(
    inputFormatters: inputFormatters,
    readOnly:readOnly! ,
    onTap: onTap,
    // onEditingComplete: onSave,
    keyboardType: type,
    textInputAction: TextInputAction.done,
    autofocus: false,
    textCapitalization: TextCapitalization.words,
    onSaved: onSave,
    controller: controller,
    onChanged: onChanged,
    validator: validator,
    decoration: InputDecoration(
        labelText: labelText, hintText: hintText, suffixIcon: sIcon, prefix: prefix),
  );
}


Widget buildImageButton(BuildContext context, TextTheme textTheme, String text,
    // bool isLoading,
     VoidCallback onPressed) {
  return
  //  Padding(
    // padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    // child:
     ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: sec,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        minimumSize: const Size(40, 40)),
      onPressed: onPressed, // Disable button when loading
      child:
      //  isLoading
      //     ? const CircularProgressIndicator(
      //         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      //       )
      //     : 
          Text(text),
    // ),
  );
}

class DottedBorderContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;

  const DottedBorderContainer({super.key, required this.child, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          style: BorderStyle.none,
        ),
        shape: BoxShape.rectangle,
      ),
      child: CustomPaint(
        painter: DottedBorderPainter(),
        child: child,
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = m
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      

    Path path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    Path dashPath = Path();

    double dashWidth = 5.0;
    double dashSpace = 5.0;

    for (double i = 0; i < path.computeMetrics().first.length; i += dashWidth + dashSpace) {
      dashPath.addPath(
        path.computeMetrics().first.extractPath(i, i + dashWidth),
        Offset.zero,
      );
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}