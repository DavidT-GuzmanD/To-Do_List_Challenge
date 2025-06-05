import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_challenge/core/theme/app_colors.dart';
import 'package:todo_list_challenge/features/task/domain/entities/task.dart';
import 'package:todo_list_challenge/features/task/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:todo_list_challenge/features/task/presentation/cubit/add_task_cubit.dart';
import 'package:todo_list_challenge/features/task/presentation/helpers/time_picker_helper.dart';
import 'package:todo_list_challenge/features/task/presentation/widgets/custom_calendar_widget.dart';
import 'package:todo_list_challenge/features/task/presentation/widgets/custom_save_button.dart';
import 'package:todo_list_challenge/features/task/presentation/widgets/custom_selector_tile.dart';
import 'package:todo_list_challenge/features/task/presentation/widgets/custom_text_field.dart';
import 'package:todo_list_challenge/features/task/presentation/widgets/icon_picker_dialog.dart';
import 'package:todo_list_challenge/features/task/presentation/widgets/priority_bottom_sheet.dart';

class AddTaskPage extends StatelessWidget {
  final Task? task;

  const AddTaskPage({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskCubit(initialTask: task),
      child: const _AddTaskView(),
    );
  }
}

class _AddTaskView extends StatefulWidget {
  const _AddTaskView();

  @override
  State<_AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<_AddTaskView> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    final state = context.read<AddTaskCubit>().state;
    _titleController = TextEditingController(text: state.title.value);
    _descriptionController = TextEditingController(text: state.description);
    _categoryController = TextEditingController(text: state.category);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTaskCubit, AddTaskState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(context, state),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildForm(context, state),
                ),
              ),
              _buildSaveButton(context, state),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AddTaskState state) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: AppColors.textPrimary),
        onPressed: () => context.pop(),
      ),
      title: Text(
        state.isEditing ? 'Editar Tarea' : 'Nueva Tarea',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildForm(BuildContext context, AddTaskState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título
        CustomTextField(
          controller: _titleController,
          hint: 'Título de la tarea',
          isRequired: true,
          errorText:
              state.title.errorText.isEmpty ? null : state.title.errorText,
          onChanged:
              (value) => context.read<AddTaskCubit>().titleChanged(value),
        ),
        const SizedBox(height: 20),

        // Descripción
        CustomTextField(
          controller: _descriptionController,
          hint: 'Descripción (opcional)',
          maxLines: 3,
          onChanged:
              (value) => context.read<AddTaskCubit>().descriptionChanged(value),
        ),
        const SizedBox(height: 20),

        // Hora límite
        CustomSelectorTile(
          icon: Icons.access_time,
          title:
              state.selectedTime != null
                  ? 'Hora límite: ${state.selectedTime!.format(context)}'
                  : 'Seleccionar hora límite',
          onTap: () => _selectTime(context),
          onClear:
              state.selectedTime != null
                  ? () => context.read<AddTaskCubit>().clearTime()
                  : null,
        ),
        const SizedBox(height: 16),

        // Prioridad
        CustomSelectorTile(
          icon: Icons.flag,
          title: 'Prioridad',
          isRequired: true,
          subtitle:
              state.priority.value != null
                  ? state.priority.value!.displayName
                  : 'Sin prioridad',
          errorText:
              state.priority.errorText.isEmpty
                  ? null
                  : state.priority.errorText,
          onTap: () => _selectPriority(context),
          onClear:
              state.priority.value != null
                  ? () => context.read<AddTaskCubit>().clearPriority()
                  : null,
        ),
        const SizedBox(height: 20),

        // Categoría
        CustomTextField(
          controller: _categoryController,
          hint: 'Categoría/Etiqueta (opcional)',
          onChanged:
              (value) => context.read<AddTaskCubit>().categoryChanged(value),
        ),
        const SizedBox(height: 20),

        // Icono personalizado
        CustomSelectorTile(
          icon: Icons.emoji_emotions,
          title: 'Icono personalizado',
          subtitle: 'Seleccionado: ${state.selectedIcon}',
          trailing: Text(
            state.selectedIcon,
            style: const TextStyle(fontSize: 24),
          ),
          onTap: () => _selectIcon(context, state.selectedIcon),
        ),
        const SizedBox(height: 32),

        // Calendario integrado
        const Text(
          'Fecha límite *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        CustomCalendarWidget(
          selectedDate: state.selectedDate.value ?? DateTime.now(),
          displayedMonth: state.displayedMonth,
          errorText:
              state.selectedDate.errorText.isEmpty
                  ? null
                  : state.selectedDate.errorText,
          onDateSelected:
              (date) => context.read<AddTaskCubit>().dateSelected(date),
          onPreviousMonth: () => context.read<AddTaskCubit>().previousMonth(),
          onNextMonth: () => context.read<AddTaskCubit>().nextMonth(),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, AddTaskState state) {
    return CustomSaveButton(
      text: state.isEditing ? 'Actualizar' : 'Guardar',
      isEnabled: state.isValid,
      onPressed:
          state.isValid
              ? () {
                _saveTask(context);
                AlertInfo.show(
                  context: context,
                  text: state.isEditing ? 'Tarea actualizada' : 'Tarea creada',
                  position: MessagePosition.top,
                  padding: 70,
                  backgroundColor: AppColors.textPrimary,
                  textColor: AppColors.background,
                  typeInfo: TypeInfo.success,
                );
              }
              : null,
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final cubit = context.read<AddTaskCubit>();
    final picked = await TimePickerHelper.selectTime(
      context,
      cubit.state.selectedTime,
    );
    if (picked != null) {
      cubit.timeSelected(picked);
    }
  }

  void _selectPriority(BuildContext context) {
    PriorityBottomSheet.show(
      context,
      (priority) => context.read<AddTaskCubit>().prioritySelected(priority),
    );
  }

  void _selectIcon(BuildContext context, String selectedIcon) {
    IconPickerDialog.show(
      context,
      selectedIcon,
      (icon) => context.read<AddTaskCubit>().iconSelected(icon),
    );
  }

  void _saveTask(BuildContext context) {
    final cubit = context.read<AddTaskCubit>();
    final task = cubit.buildTask();

    debugPrint('Task to save: $task');

    // Acceso a la capa de aplicación (Use Cases) a través del BLoC
    final rootContext =
        GoRouter.of(context).routerDelegate.navigatorKey.currentContext!;
    final taskBloc = rootContext.read<TaskBloc>();

    if (cubit.state.isEditing) {
      taskBloc.add(UpdateTaskEvent(task));
    } else {
      taskBloc.add(AddTaskEvent(task));
    }

    // Navegación
    context.go('/');
  }
}
