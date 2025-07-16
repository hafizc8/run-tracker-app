import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/modules/daily_streak/views/widgets/daily_streak_shimmer_layout.dart';
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
          child: Obx(
            () {
              if (controller.isInitialLoading.value) {
                return const DailyStreakShimmer();
              }

              return Column(
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
                              '${controller.user?.recordDailyStreakCount ?? 0}',
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
                    return Column(
                      children: [
                        Stack(
                          children: [
                            TableCalendar(
                              // Atur hari pertama dan terakhir yang bisa ditampilkan
                              firstDay: DateTime.utc(2025, 1, 1),
                              lastDay: DateTime.utc(2030, 12, 31),
                              // Ambil state dari controller
                              focusedDay: controller.focusedDay.value,
                                          
                              availableGestures: AvailableGestures.none,
                              
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
                            ),
                            Obx(() {
                              if (controller.isPageLoading.value) {
                                return Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                          ],
                        ),
              
                        SizedBox(height: 15.h),
                        _buildXpDetails(context),
                      ],
                    );
                  }),
              
                  SizedBox(height: 25.h),
                ],
              );
            }
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

  Widget _buildXpDetails(BuildContext context) {
    // Ambil data dari state selectedRecord
    final record = controller.selectedRecord.value;
    
    // Hitung total XP
    final totalXp = (record?.xpPerStep ?? 0) +
      (record?.xpDailyBonus ?? 0) +
      (record?.xpRecordActivity ?? 0) +
      (record?.xpSpecialEvent ?? 0);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF595959),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
            ),
            child: Center(
              child: Text(
                // Tampilkan tanggal yang dipilih atau teks default
                record?.date != null
                    ? DateFormat('EEEE, dd MMMM yyyy').format(record!.date!)
                    : 'Select a date to see details',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                    ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildXpColumn(context, 'Steps\nXp', record?.xpPerStep ?? 0),
                _buildXpColumn(context, 'Daily Goals\nXp', record?.xpDailyBonus ?? 0),
                _buildXpColumn(context, 'Activity\nXp', record?.xpRecordActivity ?? 0),
                _buildXpColumn(context, 'Special Event\nXp', record?.xpSpecialEvent ?? 0),
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
                const TextSpan(text: 'Total Xp Gained  '),
                TextSpan(
                  text: NumberHelper().formatNumberToKWithComma(totalXp),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  Widget _buildXpColumn(BuildContext context, String label, int value) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFFA5A5A5)), textAlign: TextAlign.center),
        SizedBox(height: 8.h),
        Text(NumberHelper().formatNumberToKWithComma(value), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: darkColorScheme.primary)),
      ],
    );
  }
}