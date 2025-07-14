import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/daily_streak_controller.dart';

class DailyStreakView extends GetView<DailyStreakController> {
  const DailyStreakView({super.key});

  @override
  Widget build(BuildContext context) {
    const headerGradient = LinearGradient(
      colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Daily Streak',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 17.sp
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            Obx(() {
              return TableCalendar(
                // Atur hari pertama dan terakhir yang bisa ditampilkan
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                // Ambil state dari controller
                focusedDay: controller.focusedDay.value,
                
                selectedDayPredicate: (day) {
                  return isSameDay(controller.selectedDay.value, day);
                },
                // Panggil method dari controller
                onDaySelected: controller.onDaySelected,
                onPageChanged: controller.onPageChanged,
                rowHeight: 60.h,
                daysOfWeekHeight: 40.h,
        
                // --- Kustomisasi Tampilan (tidak berubah) ---
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  leftChevronIcon: ShaderMask(
                    shaderCallback: (bounds) => headerGradient.createShader(bounds),
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 25),
                  ),
                  rightChevronIcon: ShaderMask(
                    shaderCallback: (bounds) => headerGradient.createShader(bounds),
                    child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 25),
                  ),
                  leftChevronMargin: const EdgeInsets.all(0),
                  rightChevronMargin: const EdgeInsets.all(0),
                  headerMargin: EdgeInsets.only(bottom: 15.h),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0],
                  weekdayStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFFA5A5A5),
                    fontSize: 14.sp,
                  ) ?? const TextStyle(fontWeight: FontWeight.bold),
                  weekendStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFFA5A5A5),
                    fontSize: 14.sp,
                  ) ?? const TextStyle(fontWeight: FontWeight.bold),
                ),
                calendarBuilders: CalendarBuilders(
                  headerTitleBuilder: (context, date) {
                    final titleText = DateFormat.yMMMM().format(date);
                    return Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) => headerGradient.createShader(bounds),
                        child: Text(
                          titleText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                  defaultBuilder: (context, day, focusedDay) {
                    return _buildCalendarDay(
                      day: day,
                      hasStreak: controller.streakDays.contains(day.day),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    return _buildCalendarDay(
                      day: day,
                      hasStreak: controller.streakDays.contains(day.day),
                      isToday: true,
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return _buildCalendarDay(
                      day: day,
                      hasStreak: controller.streakDays.contains(day.day),
                      isToday: false,
                      isSelected: true,
                    );
                  },
                  outsideBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.transparent),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Helper widget untuk membangun setiap sel tanggal kustom
  Widget _buildCalendarDay({
    required DateTime day,
    bool hasStreak = false,
    bool isToday = false,
    bool isSelected = false,
  }) {
    return Container(
      padding: isToday || isSelected ? const EdgeInsets.symmetric(horizontal: 8) : null,
      margin: EdgeInsets.only(bottom: 8.h, top: 8.h),
      decoration: isToday 
        ? BoxDecoration(
          gradient: LinearGradient(colors: [
            const Color(0xFFA2FF00).withOpacity(0.7),
            const Color(0xFF00FF7F).withOpacity(0.7),
          ]),
          borderRadius: BorderRadius.circular(5),
        ) 
        : (
          isSelected
          ? BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)]),
            borderRadius: BorderRadius.circular(5),
          )
          : null
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/ic_streak_2.svg',
            height: 16.5,
            colorFilter: hasStreak
            ? null
            : (
              isToday || isSelected
              ? const ColorFilter.mode(Color(0xFF292929), BlendMode.srcIn)
              : const ColorFilter.mode(Color(0xFFA5A5A5), BlendMode.srcIn)
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${day.day}',
            style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
              color: hasStreak
                ? const Color(0xFFFFBC00)
                : (
                  isToday || isSelected
                  ? const Color(0xFF292929)
                  : const Color(0xFFA5A5A5)
                ),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}