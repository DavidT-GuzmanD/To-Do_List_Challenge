part of 'calendar_bloc.dart';


abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class LoadCalendarTasks extends CalendarEvent {
  final DateTime month;

  const LoadCalendarTasks(this.month);

  @override
  List<Object> get props => [month];
}

class SelectDate extends CalendarEvent {
  final DateTime selectedDate;

  const SelectDate(this.selectedDate);

  @override
  List<Object> get props => [selectedDate];
}

class ChangeMonth extends CalendarEvent {
  final DateTime month;

  const ChangeMonth(this.month);

  @override
  List<Object> get props => [month];
}
