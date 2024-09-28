import 'package:flutter/material.dart';

class TextBoxWidget extends StatelessWidget {
  final String label;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool? hiddenText;
  final TextEditingController? controller;
  final void Function(bool)? onFocusChange;
  final String? Function(String?)? validator;
  final String? labelText;

  const TextBoxWidget(
      {super.key,
      required this.label,
      required this.onChanged,
      this.keyboardType,
      this.controller,
      this.onFocusChange,
      this.validator,
      this.labelText,
      this.hiddenText});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Row(
          children: <Widget>[
            SizedBox(
              width: 80,
              child: Text(label),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 55,
                    child: Focus(
                      onFocusChange: onFocusChange,
                      child: TextFormField(
                        keyboardType: keyboardType,
                        obscureText: hiddenText ?? false,
                        controller: controller,
                        validator: validator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: labelText,
                        ),
                        onChanged: onChanged,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10.0)),
        const Row(
          children: <Widget>[],
        )
      ],
    );
  }
}
