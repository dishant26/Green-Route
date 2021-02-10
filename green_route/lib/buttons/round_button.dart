import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  RoundButton({this.btn_color, this.btn_icon, this.onPressed});

  Icon btn_icon;
  Color btn_color;
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: btn_color,
      child: btn_icon,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    );
  }
}
