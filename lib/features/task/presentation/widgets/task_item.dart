
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_challenge/features/task/domain/entities/task.dart';
import 'package:todo_list_challenge/features/task/presentation/blocs/task_bloc/task_bloc.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final bool isCalendarView;

  const TaskItem({super.key, required this.task, this.isCalendarView = false});

  bool _isOverdue(DateTime? dueDate) {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.isBefore(today);
  }

  String _formatDueDate(DateTime? dueDate) {
    if (dueDate == null) return '';
    return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Tarea'),
          content: Text('¿Estás seguro de eliminar "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
                context.pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEdit(BuildContext context) {
    context.pushNamed('add_task', extra: task);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isCalendarView
        ? Row(
          children: [
            if (task.icon != null)
            Text(task.icon!, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 16),
            Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              if (_isOverdue(task.dueDate))
                Text(
                '¡Tarea vencida!',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                ),
              Text(
                task.title,
                style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted ? Colors.grey : Colors.black87,
                ),
              ),
              if (task.description != null) ...[
                Text(
                task.description!,
                style: TextStyle(
                  color: task.isCompleted ? Colors.grey : Colors.grey[600],
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                if (task.category != null)
                  Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    task.category!,
                    style: const TextStyle(
                    fontSize: 11,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    ),
                  ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                  ),
                  decoration: BoxDecoration(
                  color: task.priority.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: task.priority.color.withOpacity(0.3),
                  ),
                  ),
                  child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                    Icons.flag,
                    size: 12,
                    color: task.priority.color,
                    ),
                    const SizedBox(width: 2),
                    Text(
                    task.priority.displayName,
                    style: TextStyle(
                      fontSize: 11,
                      color: task.priority.color,
                      fontWeight: FontWeight.w500,
                    ),
                    ),
                  ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                  ),
                  decoration: BoxDecoration(
                  color: _isOverdue(task.dueDate)
                    ? Colors.red.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isOverdue(task.dueDate)
                      ? Colors.red.withOpacity(0.3)
                      : Colors.orange.withOpacity(0.3),
                  ),
                  ),
                  child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                    Icons.schedule,
                    size: 12,
                    color: _isOverdue(task.dueDate)
                      ? Colors.red
                      : Colors.orange,
                    ),
                    const SizedBox(width: 2),
                    Text(
                    _formatDueDate(task.dueDate),
                    style: TextStyle(
                      fontSize: 11,
                      color: _isOverdue(task.dueDate)
                        ? Colors.red
                        : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                    ),
                  ],
                  ),
                ),
                ],
              ),
              ],
            ),
            ),
          ],
          )
        : Dismissible(
          key: Key(task.id),
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerLeft,
            child: const Row(
            children: [
              Icon(Icons.edit, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
              'Editar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              ),
            ],
            ),
          ),
          secondaryBackground: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
              'Eliminar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              ),
              SizedBox(width: 8),
              Icon(Icons.delete, color: Colors.white, size: 24),
            ],
            ),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
            _navigateToEdit(context);
            return false;
            } else if (direction == DismissDirection.endToStart) {
            _showDeleteConfirmation(context);
            return false;
            }
            return false;
          },
          child: Row(
            children: [
            if (task.icon != null)
              Text(task.icon!, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isOverdue(task.dueDate))
                Text(
                  '¡Tarea vencida!',
                  style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                task.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted ? Colors.grey : Colors.black87,
                ),
                ),
                if (task.description != null) ...[
                Text(
                  task.description!,
                  style: TextStyle(
                  color: task.isCompleted ? Colors.grey : Colors.grey[600],
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                ],
                const SizedBox(height: 4),
                Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (task.category != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                    ),
                    decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                    ),
                    ),
                    child: Text(
                    task.category!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                    ),
                  ),
                  Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: task.priority.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                    color: task.priority.color.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    Icon(
                      Icons.flag,
                      size: 12,
                      color: task.priority.color,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      task.priority.displayName,
                      style: TextStyle(
                      fontSize: 11,
                      color: task.priority.color,
                      fontWeight: FontWeight.w500,
                      ),
                    ),
                    ],
                  ),
                  ),
                  Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _isOverdue(task.dueDate)
                      ? Colors.red.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                    color: _isOverdue(task.dueDate)
                      ? Colors.red.withOpacity(0.3)
                      : Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    Icon(
                      Icons.schedule,
                      size: 12,
                      color: _isOverdue(task.dueDate)
                        ? Colors.red
                        : Colors.orange,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      _formatDueDate(task.dueDate),
                      style: TextStyle(
                      fontSize: 11,
                      color: _isOverdue(task.dueDate)
                        ? Colors.red
                        : Colors.orange,
                      fontWeight: FontWeight.w500,
                      ),
                    ),
                    ],
                  ),
                  ),
                ],
                ),
              ],
              ),
            ),
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                context.read<TaskBloc>().add(ToggleTaskCompletion(task));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: Colors.blue,
              ),
            ),
            ],
          ),
          ),
    );
  }
}