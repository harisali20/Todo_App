import 'package:flutter/material.dart';


Color whiteColor = Colors.white;

Color textFieldColor = const Color.fromARGB(50, 39, 39, 39);
OutlineInputBorder borderDecor(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: color, width: 2),
  );
}
Color buttonColor = const Color.fromRGBO(247, 158, 137, 1);

Color secondaryColor = const Color.fromRGBO(247, 108, 106, 1);

SnackBar snackBar(String message) {
  return SnackBar(
    content: Text(message),
    backgroundColor: buttonColor,
    behavior: SnackBarBehavior.floating,
  );
}
