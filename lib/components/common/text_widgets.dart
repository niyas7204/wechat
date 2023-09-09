import 'package:chatapp/components/constants/colors.dart';
import 'package:flutter/material.dart';

class Textwidgets {
  static captionHead(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 25, color: ThemeColors.captionColor),
    );
  }

  static labelText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, color: ThemeColors.captionColor),
    );
  }
}
