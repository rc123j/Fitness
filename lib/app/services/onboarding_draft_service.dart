import 'package:get_storage/get_storage.dart';

/// Saves onboarding draft answers to local storage after each step so the user
/// can resume mid-flow after a restart without re-entering everything.
class OnboardingDraftService {
  static final _box = GetStorage();

  // Keys
  static const _kStep        = 'ob_step';
  static const _kGoalTitle   = 'ob_goal_title';
  static const _kGoalId      = 'ob_goal_id';
  static const _kGender      = 'ob_gender';
  static const _kAge         = 'ob_age';
  static const _kHeight      = 'ob_height';
  static const _kWeight      = 'ob_weight';
  static const _kActId       = 'ob_activity_level_id';
  static const _kActName     = 'ob_activity_level_name';
  static const _kTasteIds    = 'ob_taste_preference_ids';
  static const _kDietLabel   = 'ob_diet_label';
  static const _kFoodExcl    = 'ob_food_exclusions';
  static const _kCondIds     = 'ob_medical_condition_ids';
  static const _kSmoking     = 'ob_smoking_habit';
  static const _kAlcohol     = 'ob_alcohol_habit';

  // ── Read ──────────────────────────────────────────────────────────────────

  static int get lastStep => _box.read(_kStep) ?? 1;

  static Map<String, dynamic> getDraft() {
    return {
      'goalTitle':          _box.read(_kGoalTitle) ?? '',
      'goalId':             _box.read(_kGoalId) ?? 0,
      'gender':             _box.read(_kGender) ?? 'Male',
      'age':                _box.read(_kAge) ?? 24,
      'height':             _box.read(_kHeight) ?? 172,
      'weight':             (_box.read(_kWeight) ?? 70.0).toDouble(),
      'activityLevelId':    _box.read(_kActId) ?? 1,
      'activityLevelName':  _box.read(_kActName) ?? 'Sedentary',
      'tastePreferenceIds': List<int>.from(_box.read(_kTasteIds) ?? []),
      'dietLabel':          _box.read(_kDietLabel) ?? '',
      'foodExclusions':     List<String>.from(_box.read(_kFoodExcl) ?? []),
      'medicalConditionIds':List<int>.from(_box.read(_kCondIds) ?? []),
      'smokingHabit':       _box.read(_kSmoking) ?? 'No, never',
      'alcoholHabit':       _box.read(_kAlcohol) ?? 'No, never',
    };
  }

  // ── Write helpers — call one per step on Continue tap ────────────────────

  /// Step 1: Goal selected
  static void saveStep1({required String goalTitle, required int goalId}) {
    _box.write(_kStep, 1);
    _box.write(_kGoalTitle, goalTitle);
    _box.write(_kGoalId, goalId);
  }

  /// Step 2: Gender selected
  static void saveStep2({required String gender}) {
    _box.write(_kStep, 2);
    _box.write(_kGender, gender);
  }

  /// Step 3: Age selected
  static void saveStep3({required int age}) {
    _box.write(_kStep, 3);
    _box.write(_kAge, age);
  }

  /// Step 4: Height selected
  static void saveStep4({required int height}) {
    _box.write(_kStep, 4);
    _box.write(_kHeight, height);
  }

  /// Step 5: Weight selected
  static void saveStep5({required double weight}) {
    _box.write(_kStep, 5);
    _box.write(_kWeight, weight);
  }

  /// Step 6: Activity level chosen
  static void saveStep6({required int activityLevelId, required String activityLevelName}) {
    _box.write(_kStep, 6);
    _box.write(_kActId, activityLevelId);
    _box.write(_kActName, activityLevelName);
  }

  /// Step 7: Dietary preferences chosen
  static void saveStep7({
    required List<int> tastePreferenceIds,
    required String dietLabel,
    required List<String> foodExclusions,
  }) {
    _box.write(_kStep, 7);
    _box.write(_kTasteIds, tastePreferenceIds);
    _box.write(_kDietLabel, dietLabel);
    _box.write(_kFoodExcl, foodExclusions);
  }

  /// Step 8: Health / medical conditions chosen
  static void saveStep8({required List<int> medicalConditionIds}) {
    _box.write(_kStep, 8);
    _box.write(_kCondIds, medicalConditionIds);
  }

  /// Step 9: Lifestyle habits chosen
  static void saveStep9({required String smokingHabit, required String alcoholHabit}) {
    _box.write(_kStep, 9);
    _box.write(_kSmoking, smokingHabit);
    _box.write(_kAlcohol, alcoholHabit);
  }

  // ── Clear (call after successful onboarding submission) ───────────────────

  static void clear() {
    _box.remove(_kStep);
    _box.remove(_kGoalTitle);
    _box.remove(_kGoalId);
    _box.remove(_kGender);
    _box.remove(_kAge);
    _box.remove(_kHeight);
    _box.remove(_kWeight);
    _box.remove(_kActId);
    _box.remove(_kActName);
    _box.remove(_kTasteIds);
    _box.remove(_kDietLabel);
    _box.remove(_kFoodExcl);
    _box.remove(_kCondIds);
    _box.remove(_kSmoking);
    _box.remove(_kAlcohol);
  }
}
