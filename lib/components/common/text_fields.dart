import 'package:chatapp/components/common/text_widgets.dart';
import 'package:flutter/material.dart';

class TextFieldWidgets {
  static textFieldWithLabel(String label, TextEditingController controller) {
    bool passwordfield = false;
    if (label == 'Password' || label == "Confirm Password") {
      passwordfield = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Textwidgets.labelText(label),
        TextField(
          controller: controller,
          obscureText: passwordfield,
          keyboardType: passwordfield
              ? TextInputType.visiblePassword
              : TextInputType.text,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              hintText: label),
        ),
      ],
    );
  }
}
