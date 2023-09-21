import 'package:chatapp/components/constants/sized.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertdiologeWidgets {
  static loadingAlert(BuildContext context) {
    AlertDialog loadingDiologe = const AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Sized.height10,
          Text('loading...')
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => loadingDiologe,
    );
  }
 static warnigAlert(String message){
 Get.defaultDialog(middleText: message, actions: [
        ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('ok'))
      ]);
 }
}
