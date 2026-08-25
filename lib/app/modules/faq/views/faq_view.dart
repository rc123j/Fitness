import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/premium_layout_components.dart';

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem(this.question, this.answer);
}

/// Static FAQ screen — answers are specific to how Nutri Shape actually
/// works (meal options/locking, FitCoins, reminders, expert bookings, plan
/// targets), not generic placeholder copy.
class FaqView extends StatefulWidget {
  const FaqView({super.key});

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  int? _expandedIndex = 0;

  static const List<_FaqItem> _faqs = [
    _FaqItem(
      "How is my meal plan created?",
      "Your plan is built using a food-exchange method based on your goal, "
          "diet preference, activity level and body metrics from onboarding. "
          "It targets a daily calorie and macro (carbs/protein/fat) budget "
          "and runs on a 30-day rotation, so Day 1 and Day 31 repeat the "
          "same structure.",
    ),
    _FaqItem(
      "What do Option 1, 2 and 3 mean on a meal?",
      "Each meal slot has up to 3 interchangeable food choices with the "
          "same portion logic. Option 1 is shown by default — tap "
          "\"Exchange Options\" on a meal card to swap the whole meal to "
          "Option 2 or 3, or check the italic \"Swap: X OR Y\" line under "
          "an item to substitute just that one ingredient.",
    ),
    _FaqItem(
      "Why is a day showing a lock icon on the Meal screen?",
      "Two reasons: it's a future date that hasn't been revealed yet "
          "(unlocks automatically when it arrives), or it's a date before "
          "your plan actually started — there's nothing to show for days "
          "before you joined.",
    ),
    _FaqItem(
      "What happens when I tap \"Mark as Complete\"?",
      "It logs that meal for the day, updates your Today's Nutrition "
          "totals on the Progress screen, marks it in your Nutrition "
          "History log, and adds FitCoins to your wallet.",
    ),
    _FaqItem(
      "What are FitCoins?",
      "Reward points you earn by logging your meals. You can view your "
          "balance and redeem them from the Rewards Hub, accessible from "
          "your Profile.",
    ),
    _FaqItem(
      "How is \"Day X of 30\" calculated?",
      "It's the number of days since your diet plan was activated, capped "
          "at 30. It's shown on the Progress screen's Journey card along "
          "with days remaining and percentage complete.",
    ),
    _FaqItem(
      "Can I talk to a nutrition expert?",
      "Yes — use the \"Talk to an Expert Dietitian\" option from the Home "
          "screen to view available consultants, check their available "
          "time slots and book a session directly in the app.",
    ),
    _FaqItem(
      "How do daily reminders work?",
      "The app schedules reminders for meals, hydration and a weekly "
          "weight check-in by default. Open Reminders from your profile to "
          "turn any of them on/off, adjust snooze time, or add your own "
          "custom reminder with any label, time and repeat days.",
    ),
    _FaqItem(
      "Where can I see which meals I've logged in the past?",
      "Tap the history icon next to \"Daily Meals\" on the Meal screen to "
          "open your Nutrition History — a day-by-day attendance log "
          "starting from the day your plan was activated.",
    ),
    _FaqItem(
      "How are my daily calorie and macro targets set?",
      "They're calculated from the body metrics, goal and activity level "
          "you provided during onboarding. You can review your current "
          "targets any time under the Macros tab on the Meal screen.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffB100FF).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                PremiumAppBar(
                  title: "FAQs",
                  subtitle: "Common questions about Nutri Shape",
                  onBackPressed: () => Get.back(),
                ),
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
                    itemCount: _faqs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _faqs[index];
                      final isExpanded = _expandedIndex == index;
                      return _buildFaqCard(item, isExpanded, () {
                        setState(() {
                          _expandedIndex = isExpanded ? null : index;
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqCard(_FaqItem item, bool isExpanded, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0B0817).withOpacity(0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isExpanded
              ? const Color(0xffB100FF).withOpacity(0.35)
              : Colors.white.withOpacity(0.10),
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.question,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isExpanded
                            ? const Color(0xffB100FF)
                            : Colors.white.withOpacity(0.4),
                        size: 22,
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      item.answer,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.60),
                        fontSize: 12.5,
                        height: 1.55,
                      ),
                    ),
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
