
import 'package:flutter/material.dart';
import 'package:todo_list_challenge/core/theme/app_colors.dart';
import 'package:todo_list_challenge/features/task/domain/entities/task_priority.dart';

class PriorityBottomSheet extends StatelessWidget {
  final Function(TaskPriority) onPrioritySelected;

  const PriorityBottomSheet({
    super.key,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Seleccionar Prioridad',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          ...TaskPriority.values.map(
            (priority) => _buildPriorityOption(context, priority),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPriorityOption(BuildContext context, TaskPriority priority) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(Icons.flag, color: priority.color),
        title: Text(priority.displayName),
        onTap: () {
          onPrioritySelected(priority);
          Navigator.pop(context);
        },
      ),
    );
  }

  static void show(BuildContext context, Function(TaskPriority) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => PriorityBottomSheet(onPrioritySelected: onSelected),
    );
  }
}
