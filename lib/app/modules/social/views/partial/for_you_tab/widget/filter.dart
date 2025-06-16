import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/event_location_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';

class FilterDialog extends GetView<EventController> {
  FilterDialog({super.key});

  var eventActionController = Get.find<EventActionController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (!controller.isApplyFilter.value) {
          controller.resetFormFilter();
        }
      },
      child: Dialog(
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
        insetPadding: const EdgeInsets.all(32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.resetFilter();
                      },
                      child: Text(
                        'Reset Filter',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF969696),
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activity',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                          (eventActionController.eventActivities.length / 2)
                              .ceil(), (rowIndex) {
                        final first =
                            eventActionController.eventActivities[rowIndex * 2];
                        final second = (rowIndex * 2 + 1 <
                                eventActionController.eventActivities.length)
                            ? eventActionController
                                .eventActivities[rowIndex * 2 + 1]
                            : null;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              // Left item
                              Expanded(
                                child: Obx(
                                  () => GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      controller.activity.value =
                                          (controller.activity.value ==
                                                  first.value)
                                              ? null
                                              : first.value;
                                    },
                                    child: Row(
                                      children: [
                                        Radio<String?>(
                                          value: first.value,
                                          groupValue: controller.activity.value,
                                          onChanged: null,
                                          fillColor: MaterialStateProperty.all(
                                              Colors.white),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        Text(
                                          first.label ?? '-',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Right item (if exists)
                              if (second != null)
                                Expanded(
                                  child: Obx(
                                    () => GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        controller.activity.value =
                                            (controller.activity.value ==
                                                    second.value)
                                                ? null
                                                : second.value;
                                      },
                                      child: Row(
                                        children: [
                                          Radio<String?>(
                                            value: second.value,
                                            groupValue:
                                                controller.activity.value,
                                            onChanged: null,
                                            fillColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                          Text(
                                            second.label ?? '-',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              else
                                const Spacer(), // biar rata kalau ganjil
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                TextFormField(
                  readOnly: true,
                  controller: controller.dateController,
                  onTap: () {
                    controller.pickDateRange(context);
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onPrimary,
                    contentPadding: const EdgeInsets.all(8),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(
                        12,
                      ), // optional: untuk sesuaikan padding
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(
                          'assets/icons/calendar_gradient.svg',
                        ),
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF969696),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    border: const UnderlineInputBorder(),
                    hintText: 'Date',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),

                const SizedBox(height: 20),

                // Location Dropdown
                DropdownButtonFormField<EventLocationModel?>(
                  dropdownColor: Theme.of(context).colorScheme.onPrimary,
                  isExpanded: true,
                  value: controller.location.value == null
                      ? null
                      : EventLocationModel(
                          value: controller.location.value,
                          label: controller.location.value),
                  items: [
                    ...controller.eventLocations.map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Obx(
                          () => Text(
                            e.value ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: controller.location.value == e.value
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    controller.location.value = value?.value ?? '';
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onPrimary,
                    contentPadding: const EdgeInsets.all(8),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF969696),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    border: const UnderlineInputBorder(),
                    hintText: 'Location',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  icon: SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset(
                      'assets/icons/arrow_down.svg',
                    ),
                  ),
                  iconSize: 20,
                ),

                const SizedBox(height: 30),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: GradientOutlinedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            onPressed: () => Get.back()),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 50,
                        child: GradientElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.zero,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            controller.applyFilter();
                          },
                          child: Text(
                            'Apply Filter',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
