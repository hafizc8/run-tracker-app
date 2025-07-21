import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/models/enums/challenge_enum.dart';
import 'package:zest_mobile/app/core/models/model/challenge_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';

class CardChallenge extends StatelessWidget {
  const CardChallenge({super.key, required this.challengeModel});
  final ChallengeModel challengeModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
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
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        ChallengeTypeEnum.fromValue(challengeModel.type ?? 0)
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
                if (challengeModel.isOwner == 1) ...[
                  Text(
                    'You are the Host',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
                const Spacer(),
                SvgPicture.asset(
                  'assets/icons/ic_share-2.svg',
                  height: 24.r,
                  width: 24.r,
                ),
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
                challengeModel.title ?? '-',
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
              "${challengeModel.typeText} Challenge",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(height: 16),
            // Target dan Start Date
            Row(
              children: [
                if (challengeModel.mode == 0) ...[
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
                            challengeModel.target.toString(),
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
                            (challengeModel.endDate ?? DateTime.now())
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
                const SizedBox(width: 32),
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
                          (challengeModel.startDate ?? DateTime.now())
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
              ],
            ),
            if (challengeModel.cancelledAt != null) ...[
              const SizedBox(height: 16),
              GradientOutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11.r),
                    ),
                  ),
                ),
                onPressed: null,
                child: const Text('Cancelled'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
