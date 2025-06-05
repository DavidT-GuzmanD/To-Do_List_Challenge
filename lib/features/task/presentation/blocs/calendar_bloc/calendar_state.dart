part of 'calendar_bloc.dart';


abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final DateTime selectedDate;
  final DateTime displayedMonth;
  final List<Task> monthTasks;
  final List<Task> selectedDateTasks;

  const CalendarLoaded({
    required this.selectedDate,
    required this.displayedMonth,
    required this.monthTasks,
    required this.selectedDateTasks,
  });

  CalendarLoaded copyWith({
    DateTime? selectedDate,
    DateTime? displayedMonth,
    List<Task>? monthTasks,
    List<Task>? selectedDateTasks,
  }) {
    return CalendarLoaded(
      selectedDate: selectedDate ?? this.selectedDate,
      displayedMonth: displayedMonth ?? this.displayedMonth,
      monthTasks: monthTasks ?? this.monthTasks,
      selectedDateTasks: selectedDateTasks ?? this.selectedDateTasks,
    );
  }

  @override
  List<Object> get props => [selectedDate, displayedMonth, monthTasks, selectedDateTasks];
}

class CalendarError extends CalendarState {
  final String message;

  const CalendarError(this.message);

  @override
  List<Object> get props => [message];
}
