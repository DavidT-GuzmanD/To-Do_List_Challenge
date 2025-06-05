import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_list_challenge/features/task/domain/entities/task.dart';
import 'package:todo_list_challenge/features/task/domain/usecases/get_tasks_for_date_usecase.dart';
import 'package:todo_list_challenge/features/task/domain/usecases/get_tasks_for_month_usecase.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';


class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetTasksForMonthUseCase getTasksForMonthUseCase;
  final GetTasksForDateUseCase getTasksForDateUseCase;

  CalendarBloc({
    required this.getTasksForMonthUseCase,
    required this.getTasksForDateUseCase,
  }) : super(CalendarInitial()) {
    on<LoadCalendarTasks>(_onLoadCalendarTasks);
    on<SelectDate>(_onSelectDate);
    on<ChangeMonth>(_onChangeMonth);
  }

  Future<void> _onLoadCalendarTasks(
    LoadCalendarTasks event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());
    try {
      final monthTasks = await getTasksForMonthUseCase(event.month);
      final today = DateTime.now();
      final selectedDateTasks = await getTasksForDateUseCase(today);

      emit(CalendarLoaded(
        selectedDate: today,
        displayedMonth: event.month,
        monthTasks: monthTasks,
        selectedDateTasks: selectedDateTasks,
      ));
    } catch (e) {
      emit(CalendarError(e.toString()));
    }
  }

  Future<void> _onSelectDate(
    SelectDate event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is CalendarLoaded) {
      final currentState = state as CalendarLoaded;
      try {
        final selectedDateTasks = await getTasksForDateUseCase(event.selectedDate);
        emit(currentState.copyWith(
          selectedDate: event.selectedDate,
          selectedDateTasks: selectedDateTasks,
        ));
      } catch (e) {
        emit(CalendarError(e.toString()));
      }
    }
  }

  Future<void> _onChangeMonth(
    ChangeMonth event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is CalendarLoaded) {
      final currentState = state as CalendarLoaded;
      emit(CalendarLoading());
      try {
        final monthTasks = await getTasksForMonthUseCase(event.month);
        final selectedDateTasks = await getTasksForDateUseCase(currentState.selectedDate);

        emit(CalendarLoaded(
          selectedDate: currentState.selectedDate,
          displayedMonth: event.month,
          monthTasks: monthTasks,
          selectedDateTasks: selectedDateTasks,
        ));
      } catch (e) {
        emit(CalendarError(e.toString()));
      }
    }
  }
}