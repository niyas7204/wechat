import 'package:chatapp/components/constants/colors.dart';
import 'package:flutter/material.dart';

logo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'weChat',
        style: TextStyle(fontSize: 40, color: ThemeColors.baseColor),
      ),
      Text(
        'Its Your Chat',
        style: TextStyle(
            fontSize: 20, color: ThemeColors.baseColor.withOpacity(.8)),
      ),
    ],
  );
}
