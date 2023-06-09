import 'package:flutter/material.dart';

class AuthUtils {
  static void showLoadingDialog(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Material(
            type: MaterialType.transparency,
            child: WillPopScope(
              onWillPop: () async => false,
              child: const SizedBox(
                height: 60,
                width: 60,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        });
  }
}
