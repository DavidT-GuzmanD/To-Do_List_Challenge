
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_challenge/core/theme/app_colors.dart';
import 'package:todo_list_challenge/features/task/presentation/utils/calendar_utils.dart';

class IconPickerDialog extends StatelessWidget {
  final String selectedIcon;
  final Function(String) onIconSelected;

  const IconPickerDialog({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Seleccionar Icono',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      content: Wrap(
        children: CalendarUtils.taskIcons
            .map(
              (icon) => GestureDetector(
                onTap: () {
                  onIconSelected(icon);
                  context.pop();
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedIcon == icon
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  static void show(
    BuildContext context, 
    String selectedIcon, 
    Function(String) onSelected
  ) {
    showDialog(
      context: context,
      builder: (context) => IconPickerDialog(
        selectedIcon: selectedIcon,
        onIconSelected: onSelected,
      ),
    );
  }
}