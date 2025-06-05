class CalendarUtils {
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  static String getMonthName(int month) {
    const monthNames = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return monthNames[month];
  }

  static List<String> get weekDays => ['D', 'L', 'M', 'M', 'J', 'V', 'S'];

  static List<String> get taskIcons => [
    '📝', '💼', '🏠', '🎯', '💡', '📚', '🛒', '💪', '🎵', '🎨'
  ];

  static DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime getEndOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  static DateTime getPreviousMonth(DateTime date) {
    return DateTime(date.year, date.month - 1, 1);
  }

  static DateTime getNextMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 1);
  }

  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}