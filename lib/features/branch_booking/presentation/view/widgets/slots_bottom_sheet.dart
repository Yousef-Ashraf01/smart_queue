import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

class SlotsBottomSheet extends StatelessWidget {
  final List slots;
  final Map<String, String>? selectedSlot;
  final Function(Map<String, String>) onSelect;

  const SlotsBottomSheet({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> morningSlots = [];
    final List<Map<String, String>> afternoonSlots = [];
    final List<Map<String, String>> eveningSlots = [];
    final ext = context.appTheme;

    for (final rawSlot in slots) {
      if (rawSlot is Map) {
        final slotMap = Map<String, String>.from(rawSlot);
        final start = slotMap['start'] ?? '';
        final hour = int.tryParse(start.split(':').first) ?? 0;
        if (hour < 12) {
          morningSlots.add(slotMap);
        } else if (hour < 17) {
          afternoonSlots.add(slotMap);
        } else {
          eveningSlots.add(slotMap);
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: ext.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDark ? 0.22 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 45,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: ext.cardBorder,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "select_time_slot".tr(),
                      style: TextStyle(
                        fontFamily: AppStyle.fontFamily,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "choose_convenient_slot".tr(),
                      style: TextStyle(
                        fontFamily: AppStyle.fontFamily,
                        fontSize: 13,
                        color: ext.subtleText,
                      ),
                    ),
                  ],
                ),
              ),
              if (slots.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff3CC572).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "slots_count".tr(args: [slots.length.toString()]),
                    style: const TextStyle(
                      fontFamily: AppStyle.fontFamily,
                      color: Color(0xff3CC572),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: ext.cardBorder, thickness: 1, height: 1),
          const SizedBox(height: 16),

          if (slots.isEmpty)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ext.cardBorder.withOpacity(0.35),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          color: ext.subtleText,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "no_time_slots_available".tr(),
                        style: TextStyle(
                          fontFamily: AppStyle.fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "select_service_date_first".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppStyle.fontFamily,
                          color: ext.subtleText,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (morningSlots.isNotEmpty) ...[
                      _buildSectionHeader(
                        context,
                        title: "morning".tr(),
                        icon: Icons.wb_twilight_rounded,
                        iconColor: Colors.orangeAccent,
                        count: morningSlots.length,
                      ),
                      const SizedBox(height: 12),
                      _buildSlotsGrid(context, morningSlots),
                      const SizedBox(height: 24),
                    ],
                    if (afternoonSlots.isNotEmpty) ...[
                      _buildSectionHeader(
                        context,
                        title: "afternoon".tr(),
                        icon: Icons.wb_sunny_rounded,
                        iconColor: Colors.amber,
                        count: afternoonSlots.length,
                      ),
                      const SizedBox(height: 12),
                      _buildSlotsGrid(context, afternoonSlots),
                      const SizedBox(height: 24),
                    ],
                    if (eveningSlots.isNotEmpty) ...[
                      _buildSectionHeader(
                        context,
                        title: "evening".tr(),
                        icon: Icons.nights_stay_rounded,
                        iconColor: Colors.indigoAccent,
                        count: eveningSlots.length,
                      ),
                      const SizedBox(height: 12),
                      _buildSlotsGrid(context, eveningSlots),
                      const SizedBox(height: 24),
                    ],
                    // Safe area spacing
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 16,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required int count,
  }) {
    final ext = context.appTheme;
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: AppStyle.fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: ext.cardBorder.withOpacity(0.35),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "$count",
            style: TextStyle(
              fontFamily: AppStyle.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: ext.subtleText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlotsGrid(
    BuildContext context,
    List<Map<String, String>> periodSlots,
  ) {
    final ext = context.appTheme;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: periodSlots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3.4,
      ),
      itemBuilder: (context, index) {
        final slotMap = periodSlots[index];
        final isSelected = selectedSlot?['start'] == slotMap['start'];

        return GestureDetector(
          onTap: () {
            onSelect(slotMap);
            Navigator.pop(context);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              gradient:
                  isSelected
                      ? const LinearGradient(
                        colors: [Color(0xff3CC572), Color(0xff2ea85c)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                      : null,
              color: isSelected ? null : ext.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Colors.transparent : ext.cardBorder,
                width: 1.5,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: const Color(0xff3CC572).withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withOpacity(context.isDark ? 0.08 : 0.02),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.access_time_rounded,
                  size: 16,
                  color: isSelected ? Colors.white : ext.subtleText,
                ),
                const SizedBox(width: 8),
                Text(
                  "${slotMap['start']} - ${slotMap['end']}",
                  style: TextStyle(
                    fontFamily: AppStyle.fontFamily,
                    color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
