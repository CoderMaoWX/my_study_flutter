import 'package:flutter/material.dart';
import 'package:my_study_flutter/util/color.dart';

class LoginButton extends StatelessWidget {
  final String title;
  final bool enable;
  final VoidCallback onPressed;

  const LoginButton(this.title,
      {super.key, required this.enable, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          onPressed: enable ? onPressed : null,
          height: 45,
          disabledColor: primary[50],
          color: primary,
          child:
              Text(title, style: TextStyle(color: Colors.white, fontSize: 16))),
    );
  }
}
