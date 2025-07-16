import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  gradient: headerGradient,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular((10 - 1).r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_streak_2.svg',
                        width: 21.w,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Total Daily Streak',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFA5A5A5),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      ShaderMask(
                        shaderCallback: (bounds) => headerGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: Text(
                          '01',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFA5A5A5),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                      final isAnotherDaySelected = controller.selectedDay.value != null && !isSameDay(controller.selectedDay.value, day);
        
                      return _buildCalendarDay(
                        day: day,
                        hasStreak: controller.streakDays.contains(day.day),
                        isToday: !isAnotherDaySelected,
                        isSelected: isSameDay(controller.selectedDay.value, day),
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

              SizedBox(height: 15.h),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF595959),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      height: 48.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Steps\nXp',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFA5A5A5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                '21',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: darkColorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Daily Goals\nXp',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFA5A5A5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                '21',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: darkColorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Activity\nXp',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFA5A5A5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                '21',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: darkColorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Special Event\nXp',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFA5A5A5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                '21',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: darkColorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: darkColorScheme.primary,
                        ),
                        children: <TextSpan>[
                          const TextSpan(text:'Total Xp Gained  '),
                          TextSpan(
                            text: '21',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: darkColorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                  ],
                ),
              ),

              SizedBox(height: 25.h),
            ],
          ),
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
      decoration: isSelected || isToday
          ? BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)]),
            borderRadius: BorderRadius.circular(5),
          )
          : null,
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