import 'package:flutter/material.dart';
import 'package:my_study_flutter/util/color.dart';

class LoginInput extends StatefulWidget {
  final String title;
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<bool> focusChanged;
  final bool lineStretch;
  final bool obscureText;
  final TextInputType keyboardType;

  const LoginInput(this.title, this.hint,
      {super.key,
      required this.onChanged,
      required this.focusChanged,
      this.lineStretch = false,
      this.obscureText = false,
      required this.keyboardType});

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      print("has focus: ${_focusNode.hasFocus}");
      if (_focusNode.hasFocus) {
        widget.focusChanged(widget.obscureText);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15),
              width: 100,
              height: 40,
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 16),
              ),
            ),
            _input()
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: !widget.lineStretch ? 15 : 0),
          child: Divider(
            height: 1,
            thickness: 0.5,
          ),
        )
      ],
    );
  }

  _input() {
    return Expanded(
        child: SizedBox(
      height: 40,
      child: TextField(
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          autofocus: !widget.obscureText,
          cursorColor: primary,
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w300),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 20, right: 20),
            hintText: widget.hint ?? '',
            hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
            border: InputBorder.none,
            isDense: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          )),
    ));
  }
}
