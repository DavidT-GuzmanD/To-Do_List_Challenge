
import 'package:flutter/material.dart';
import 'package:todo_list_challenge/core/theme/app_colors.dart';

class TimePickerHelper {
  static Future<TimeOfDay?> selectTime(
    BuildContext context, 
    TimeOfDay? initialTime
  ) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}