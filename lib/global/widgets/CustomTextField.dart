import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  late bool? obscureText;
  final IconData? iconName;
  CustomTextField(
      {required this.label,
      required this.hint,
      this.obscureText,
      this.iconName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20.0),
          child: Text(
            label,
          ),
        ),
        Container(
            margin: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 10.0, bottom: 15.0),
            child: TextField(
              obscureText: obscureText ?? false,
              decoration: InputDecoration(
                prefixIcon: Icon(iconName),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                hintText: hint,
              ),
            )),
      ],
    );
  }
}
