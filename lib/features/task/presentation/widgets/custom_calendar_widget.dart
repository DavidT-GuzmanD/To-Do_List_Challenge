
import 'package:flutter/material.dart';
import 'package:todo_list_challenge/core/theme/app_colors.dart';
import 'package:todo_list_challenge/features/task/presentation/utils/calendar_utils.dart';

class CustomCalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime displayedMonth;
  final Function(DateTime) onDateSelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final String? errorText;

  const CustomCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.displayedMonth,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null ? AppColors.error : AppColors.border,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildCalendarHeader(),
              const SizedBox(height: 16),
              _buildCalendarGrid(),
            ],
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPreviousMonth,
          icon: const Icon(Icons.chevron_left),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Text(
          '${CalendarUtils.getMonthName(displayedMonth.month)} ${displayedMonth.year}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: onNextMonth,
          icon: const Icon(Icons.chevron_right),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final lastDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    
    return Column(
      children: [
        // Headers de días de la semana
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: CalendarUtils.weekDays
              .map((day) => SizedBox(
                    width: 40,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        
        // Días del mes
        ...List.generate(6, (weekIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex - firstDayWeekday + 1;
                
                if (dayNumber < 1 || dayNumber > lastDayOfMonth.day) {
                  return const SizedBox(width: 40, height: 40);
                }
                
                final currentDay = DateTime(displayedMonth.year, displayedMonth.month, dayNumber);
                final isSelected = CalendarUtils.isSameDay(currentDay, selectedDate);
                final isToday = CalendarUtils.isSameDay(currentDay, DateTime.now());
                
                return _buildDayCell(currentDay, isSelected, isToday);
              }),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDayCell(DateTime day, bool isSelected, bool isToday) {
    return GestureDetector(
      onTap: () => onDateSelected(day),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.calendarSelected
              : isToday 
                  ? AppColors.calendarToday
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isToday && !isSelected
              ? Border.all(color: AppColors.calendarTodayBorder, width: 1)
              : null,
        ),
        child: Center(
          child: Text(
            day.day.toString(),
            style: TextStyle(
              color: isSelected 
                  ? AppColors.calendarSelectedText
                  : isToday 
                      ? AppColors.calendarTodayBorder
                      : AppColors.calendarText,
              fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}