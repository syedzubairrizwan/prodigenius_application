import 'package:flutter/material.dart';

import 'customText.dart';

Widget upperHeader(
  String text,
  BuildContext context,
  bool isIcon, {
  required Widget page,
}) {
  var he = MediaQuery.of(context).size.height;

  return Padding(
    padding: EdgeInsets.only(top: he * 0.03),
    child: Row(
      children: [
        SizedBox(width: he * 0.03),
        customText(text, 28),
        Expanded(child: Container()),
        isIcon
            ? Icon(Icons.search, color: Colors.black, size: 30)
            : Container(),
      ],
    ),
  );
}
