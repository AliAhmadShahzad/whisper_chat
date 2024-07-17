import 'package:flutter/material.dart';
import '../Colors/colors.dart';

class Messages {
  static  showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: colors.textColor3,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showProgressbar(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));
  }
}
