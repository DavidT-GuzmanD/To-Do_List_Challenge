class CalendarUtils {
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  static String getMonthName(int month) {
    const monthNames = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return monthNames[month];
  }

  static List<String> get weekDays => ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  static List<String> get taskIcons => [
    '📝', '💼', '🏠', '🎯', '💡', '📚', '🛒', '💪', '🎵', '🎨'
  ];
}