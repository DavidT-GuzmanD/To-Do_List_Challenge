import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_challenge/features/todo/domain/entities/task.dart';
import 'package:todo_list_challenge/features/todo/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:uuid/uuid.dart';

class AddTaskPage extends StatefulWidget {
  final Task? task;

  const AddTaskPage({super.key, this.task});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TaskPriority? _selectedPriority;
  String? _selectedIcon = '📝';

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _categoryController.text = widget.task!.category ?? '';
      _selectedDate = widget.task!.dueDate;
      _selectedTime =
          widget.task!.dueTime != null
              ? TimeOfDay.fromDateTime(widget.task!.dueTime!)
              : null;
      _selectedPriority = widget.task!.priority;
      _selectedIcon = widget.task!.icon ?? '📝';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Tarea' : 'Nueva Tarea'),
        actions: [
          TextButton(onPressed: _saveTask, child: const Text('Guardar')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Título
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título de la tarea *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El título es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Descripción
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Fecha límite
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _selectedDate != null
                    ? 'Fecha límite: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Seleccionar fecha límite',
              ),
              trailing:
                  _selectedDate != null
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _selectedDate = null),
                      )
                      : null,
              onTap: _selectDate,
            ),
            const Divider(),

            // Hora límite
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(
                _selectedTime != null
                    ? 'Hora límite: ${_selectedTime!.format(context)}'
                    : 'Seleccionar hora límite',
              ),
              trailing:
                  _selectedTime != null
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _selectedTime = null),
                      )
                      : null,
              onTap: _selectTime,
            ),
            const Divider(),

            // Prioridad
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Prioridad'),
              subtitle:
                  _selectedPriority != null
                      ? Text(_getPriorityText(_selectedPriority!))
                      : const Text('Sin prioridad'),
              trailing:
                  _selectedPriority != null
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed:
                            () => setState(() => _selectedPriority = null),
                      )
                      : null,
              onTap: _selectPriority,
            ),
            const Divider(),

            // Categoría
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Categoría/Etiqueta (opcional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 16),

            // Icono
            ListTile(
              leading: const Icon(Icons.emoji_emotions),
              title: const Text('Icono personalizado'),
              subtitle: Text('Seleccionado: $_selectedIcon'),
              trailing: Text(
                _selectedIcon!,
                style: const TextStyle(fontSize: 24),
              ),
              onTap: _selectIcon,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _selectPriority() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.flag, color: Colors.red),
                title: const Text('Alta'),
                onTap: () {
                  setState(() => _selectedPriority = TaskPriority.high);
                  context.pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag, color: Colors.orange),
                title: const Text('Media'),
                onTap: () {
                  setState(() => _selectedPriority = TaskPriority.medium);
                  context.pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag, color: Colors.green),
                title: const Text('Baja'),
                onTap: () {
                  setState(() => _selectedPriority = TaskPriority.low);
                  context.pop();
                },
              ),
            ],
          ),
    );
  }

  void _selectIcon() {
    final icons = ['📝', '💼', '🏠', '🎯', '💡', '📚', '🛒', '💪', '🎵', '🎨'];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Seleccionar Icono'),
            content: Wrap(
              children:
                  icons
                      .map(
                        (icon) => GestureDetector(
                          onTap: () {
                            setState(() => _selectedIcon = icon);
                            context.pop();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    _selectedIcon == icon
                                        ? Colors.blue
                                        : Colors.grey,
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
          ),
    );
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.low:
        return 'Baja';
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      DateTime? dueDateTime;
      if (_selectedDate != null && _selectedTime != null) {
        dueDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
      }

      final task = Task(
        id: _isEditing ? widget.task!.id : const Uuid().v4(),
        title: _titleController.text.trim(),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
        dueDate: _selectedDate!,
        dueTime: dueDateTime,
        priority: _selectedPriority ?? TaskPriority.low,
        category:
            _categoryController.text.trim().isEmpty
                ? null
                : _categoryController.text.trim(),
        icon: _selectedIcon,
        isCompleted: _isEditing ? widget.task!.isCompleted : false,
        createdAt: _isEditing ? widget.task!.createdAt : DateTime.now(),
      );

      // Get TaskBloc from the root context (home page)
      final rootContext =
          GoRouter.of(context).routerDelegate.navigatorKey.currentContext!;
      final taskBloc = rootContext.read<TaskBloc>();

      if (_isEditing) {
        taskBloc.add(UpdateTaskEvent(task));
      } else {
        taskBloc.add(AddTaskEvent(task));
      }
      // Navigate back to the task list
      context.go('/'); // Close the add/edit task page
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
}
