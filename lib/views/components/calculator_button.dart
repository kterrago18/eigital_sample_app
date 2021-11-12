import 'package:eigital_sample_app/views/res/text_styles.dart';
import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  final String value;
  final Function funct;
  final bool isIcon;
  final Widget? icon;
  final bool isOperator;
  const CalcButton({
    Key? key,
    required this.value,
    required this.funct,
    this.isIcon = false,
    this.icon,
    this.isOperator = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: RawMaterialButton(
        padding: const EdgeInsets.all(20.0),
        fillColor: !isOperator ? Colors.grey.shade200 : Colors.orange.shade400,
        shape: const CircleBorder(),
        child: !isIcon
            ? Text(
                value,
                style: kText20TextStyle,
              )
            : icon,
        onPressed: () => value == '=' ? funct() : funct(value),
      ),
    );
  }
}
