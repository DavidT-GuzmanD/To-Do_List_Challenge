
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_challenge/core/theme/app_colors.dart';
import 'package:todo_list_challenge/features/task/presentation/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:todo_list_challenge/features/task/presentation/utils/calendar_utils.dart';
import 'package:todo_list_challenge/features/task/presentation/widgets/custom_calendar_widget.dart';
import 'package:todo_list_challenge/features/task/presentation/widgets/task_item.dart';


class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<CalendarBloc>().add(LoadCalendarTasks(DateTime.now()));
  }
  @override
  Widget build(BuildContext context) {
    super.build(context); // Mantiene el estado de la página al cambiar de pestaña
    return const CalendarView();
  }
  
  @override
  bool get wantKeepAlive => true;

  
}

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Calendario',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          if (state is CalendarLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CalendarError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CalendarBloc>().add(
                        LoadCalendarTasks(DateTime.now()),
                      );
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (state is CalendarLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendario
                  CustomCalendarWidget(
                    selectedDate: state.selectedDate,
                    displayedMonth: state.displayedMonth,
                    onDateSelected: (date) {
                      context.read<CalendarBloc>().add(SelectDate(date));
                    },
                    onPreviousMonth: () {
                      final previousMonth = CalendarUtils.getPreviousMonth(state.displayedMonth);
                      context.read<CalendarBloc>().add(ChangeMonth(previousMonth));
                    },
                    onNextMonth: () {
                      final nextMonth = CalendarUtils.getNextMonth(state.displayedMonth);
                      context.read<CalendarBloc>().add(ChangeMonth(nextMonth));
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Título de tareas del día seleccionado
                  Text(
                    _getFormattedDate(state.selectedDate),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Lista de tareas del día seleccionado
                  if (state.selectedDateTasks.isEmpty)
                    _buildEmptyTasksWidget()
                  else
                    ..._buildTasksList(state.selectedDateTasks),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  String _getFormattedDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = CalendarUtils.getMonthName(date.month);
    final year = date.year;
    return '$day de $month $year';
  }

  Widget _buildEmptyTasksWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.taskCardBorder,
          width: 1,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.event_available_outlined,
            size: 48,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            'No hay tareas para este día',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Selecciona otro día para ver las tareas',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTasksList(List<dynamic> tasks) {
    return tasks.map((task) => TaskItem(task: task, isCalendarView: true,)).toList();
  }
}