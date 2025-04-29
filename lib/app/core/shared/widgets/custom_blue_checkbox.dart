import 'package:flutter/material.dart';

class CustomBlueCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomBlueCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.blue; // Warna saat dicentang
            }
            return Colors.white; // Warna saat belum dicentang
          }),
          checkColor: MaterialStateProperty.all(Colors.white), // warna ikon centang
          side: const BorderSide(
            color: Colors.black, // outline saat uncheck
            width: 1.5,
          ),
        ),
      ),
      child: Checkbox(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
