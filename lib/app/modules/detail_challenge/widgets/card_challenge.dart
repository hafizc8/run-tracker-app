import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/models/enums/challenge_enum.dart';
import 'package:zest_mobile/app/core/models/model/challenge_detail_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/modules/detail_challenge/views/detail_challenge_view.dart';

class CardChallenge extends StatelessWidget {
  const CardChallenge({
    super.key,
    required this.challengeDetailModel,
    this.isStartChallenge,
  });
  final ChallengeDetailModel challengeDetailModel;
  final bool? isStartChallenge;

  @override
  Widget build(BuildContext context) {
    if (challengeDetailModel.completedAt == null) {
      return _unCompleteChallenge(context);
    }

    return _completeChallenge(context);
  }

  Widget _completeChallenge(context) {
    return Container(
      height: 296.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row atas
                Row(
                  children: [
                    // Label "Individual"
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 16,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            ChallengeTypeEnum.fromValue(
                                    challengeDetailModel.type ?? 0)
                                .challengeType,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                const SizedBox(height: 16),
                // Judul
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFA2FF00),
                      Color(0xFF00FF7F),
                    ],
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Text(
                    challengeDetailModel.title ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${challengeDetailModel.modeText} Challenge",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(height: 16),
                if (!(challengeDetailModel.startDate!.isFutureDate() == true) &&
                    challengeDetailModel.type == 0) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Progress',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFA5A5A5),
                              fontSize: 12.sp,
                            ),
                      ),
                      const SizedBox(height: 8),
                      ProgressWidget(
                        currentSteps: challengeDetailModel.userProgress ?? 0,
                        targetSteps: challengeDetailModel.target ?? 0,
                        startDate: challengeDetailModel.startDate,
                        endDate: challengeDetailModel.mode == 1
                            ? challengeDetailModel.endDate
                            : null,
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                ],
                Text(
                  "Challenge Overview",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(height: 16),
                // Target dan Start Date
                Row(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_date.svg',
                          color: Theme.of(context).colorScheme.onBackground,
                          height: 22.h,
                          width: 27.w,
                        ),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                  ),
                            ),
                            Text(
                              (challengeDetailModel.startDate ?? DateTime.now())
                                  .toLocal()
                                  .todMMMyyyyString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),
                    if (challengeDetailModel.mode == 0) ...[
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic_challange_tab.svg',
                            color: Theme.of(context).colorScheme.onBackground,
                            height: 22.h,
                            width: 27.w,
                          ),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Target',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    ),
                              ),
                              Text(
                                NumberHelper().formatNumberToKWithComma(
                                    challengeDetailModel.target ?? 0),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic_date.svg',
                            color: Theme.of(context).colorScheme.onBackground,
                            height: 22.h,
                            width: 27.w,
                          ),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'End Date',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    ),
                              ),
                              Text(
                                (challengeDetailModel.endDate ?? DateTime.now())
                                    .toLocal()
                                    .todMMMyyyyString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0, // kasih ini
            bottom: 0,
            child: Container(
              height: 296.h,
              alignment: Alignment.bottomCenter,
              color: const Color(0xFF2E2E2E).withOpacity(0.5),
              child: Container(
                padding: EdgeInsets.all(16.w),
                alignment: Alignment.centerLeft,
                height: 91.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF404040),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFA2FF00),
                          Color(0xFF00FF7F),
                        ],
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFA2FF00),
                            Color(0xFF00FF7F),
                          ],
                        ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: Text(
                          'Goal',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25.sp,
                                  ),
                        ),
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFA2FF00),
                          Color(0xFF00FF7F),
                        ],
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      child: Text(
                        'Reached',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 25.sp,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 15,
            bottom: 0,
            child: Image.asset(
              'assets/icons/ic_completed_challenge.png',
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _unCompleteChallenge(context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row atas
            Row(
              children: [
                // Label "Individual"
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        ChallengeTypeEnum.fromValue(
                                challengeDetailModel.type ?? 0)
                            .challengeType,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            const SizedBox(height: 16),
            // Judul
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFA2FF00),
                  Color(0xFF00FF7F),
                ],
              ).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: Text(
                challengeDetailModel.title ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${challengeDetailModel.modeText} Challenge",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(height: 16),
            if (!(challengeDetailModel.startDate!.isFutureDate() == true) &&
                challengeDetailModel.type == 0) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Progress',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA5A5A5),
                          fontSize: 12.sp,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ProgressWidget(
                    currentSteps: challengeDetailModel.userProgress ?? 0,
                    targetSteps: challengeDetailModel.target ?? 0,
                    startDate: challengeDetailModel.startDate,
                    endDate: challengeDetailModel.mode == 1
                        ? challengeDetailModel.endDate
                        : null,
                  ),
                  const SizedBox(height: 16),
                ],
              )
            ],
            Text(
              "Challenge Overview",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(height: 16),
            // Target dan Start Date
            Row(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_date.svg',
                      color: Theme.of(context).colorScheme.onBackground,
                      height: 22.h,
                      width: 27.w,
                    ),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Date',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                              ),
                        ),
                        Text(
                          (challengeDetailModel.startDate ?? DateTime.now())
                              .toLocal()
                              .todMMMyyyyString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                if (challengeDetailModel.mode == 0) ...[
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_challange_tab.svg',
                        color: Theme.of(context).colorScheme.onBackground,
                        height: 22.h,
                        width: 27.w,
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Target',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                ),
                          ),
                          Text(
                            NumberHelper().formatNumberToKWithComma(
                                challengeDetailModel.target ?? 0),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_date.svg',
                        color: Theme.of(context).colorScheme.onBackground,
                        height: 22.h,
                        width: 27.w,
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'End Date',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                ),
                          ),
                          Text(
                            (challengeDetailModel.endDate ?? DateTime.now())
                                .toLocal()
                                .todMMMyyyyString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
