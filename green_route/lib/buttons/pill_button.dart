import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  PillButton(
      {this.logo_img,
      this.display_text,
      this.padding,
      @required this.onPressed});

  AssetImage logo_img;
  Text display_text;
  EdgeInsets padding;
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: logo_img, height: 30.0),
            Padding(
                padding: const EdgeInsets.only(left: 10), child: display_text)
          ],
        ),
      ),
    );
  }
}
