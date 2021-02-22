import 'package:boticario/utils/colors/colors.dart';
import 'package:flutter/cupertino.dart';

class InputText extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final int minLines;
  final int maxLines;
  final int maxLength;
  final Function onChanged;
  final TextEditingController controller;

  const InputText({
    Key key,
    this.obscureText = false,
    this.label,
    this.keyboardType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: CupertinoTextField(
        maxLength: maxLength,
        controller: controller,
        obscureText: obscureText,
        minLines: minLines,
        maxLines: maxLines,
        keyboardType: keyboardType,
        placeholder: label,
        onChanged: onChanged,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.5,
            color: DefaultSwatches.primary,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        placeholderStyle: TextStyle(
          color: Color(0xFFAEAEAE),
          fontWeight: FontWeight.w400,
        ),
        style: TextStyle(
          color: DefaultSwatches.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
