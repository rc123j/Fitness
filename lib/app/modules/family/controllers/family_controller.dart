import 'package:get/get.dart';

class FamilyController extends GetxController {
  // Base plan price in INR
  final basePlanPrice = 2999;

  // List of Family Members
  final familyMembers = <Map<String, dynamic>>[
    {
      "id": 1,
      "name": "Kiran Sharma",
      "relationship": "Wife",
      "age": 30,
      "gender": "Female",
      "image": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=150",
      "hasActivePlan": true,
      "activePlanName": "Lean Muscle & Tone",
      "planProgressPercent": 0.45,
      "daysLeft": 16,
      "compliancePercent": 94,
      "weightHistory": [62.4, 61.8, 61.1, 60.5],
      "caloriesGoal": "1,600 kcal",
      "waterGoal": "2.5 L"
    },
    {
      "id": 2,
      "name": "Ramesh Sharma",
      "relationship": "Father",
      "age": 62,
      "gender": "Male",
      "image": "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=150",
      "hasActivePlan": true,
      "activePlanName": "Heart Health & Cardio",
      "planProgressPercent": 0.72,
      "daysLeft": 8,
      "compliancePercent": 88,
      "weightHistory": [78.2, 77.9, 77.3, 76.8],
      "caloriesGoal": "1,800 kcal",
      "waterGoal": "3.0 L"
    },
    {
      "id": 3,
      "name": "Savitri Sharma",
      "relationship": "Mother",
      "age": 58,
      "gender": "Female",
      "image": "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=150",
      "hasActivePlan": false,
      "activePlanName": "",
      "planProgressPercent": 0.0,
      "daysLeft": 0,
      "compliancePercent": 0,
      "weightHistory": [72.0],
      "caloriesGoal": "1,400 kcal",
      "waterGoal": "2.2 L"
    }
  ].obs;

  // New Member Form Fields
  final nameInput = "".obs;
  final relationshipInput = "Wife".obs;
  final ageInput = 0.obs;
  final genderInput = "Female".obs;

  // Available Relationships List
  final relationshipsList = ["Wife", "Husband", "Mother", "Father", "Sibling", "Son", "Daughter"];

  // Calculate tier-based savings
  int get memberCount => familyMembers.length;
  
  // 1 additional member = 20% discount on additional plan
  // 2 additional members = 30% discount on additional plans
  // 3+ additional members = 40% discount on additional plans
  double get additionalPlanDiscountFraction {
    int additionalCount = memberCount;
    if (additionalCount == 1) return 0.20;
    if (additionalCount == 2) return 0.30;
    if (additionalCount >= 3) return 0.40;
    return 0.0;
  }

  // Calculate pricing
  int get primaryPlanCost => basePlanPrice;
  
  int get additionalPlansCost {
    int additionalCount = familyMembers.where((m) => m["hasActivePlan"] == true).length;
    if (additionalCount <= 0) return 0;
    
    double discount = additionalPlanDiscountFraction;
    double singleCost = basePlanPrice * (1 - discount);
    return (additionalCount * singleCost).round();
  }

  int get totalFamilyCost => primaryPlanCost + additionalPlansCost;

  int get totalSavedAmount {
    int activeCount = familyMembers.where((m) => m["hasActivePlan"] == true).length;
    if (activeCount <= 0) return 0;
    return ((basePlanPrice * activeCount) - additionalPlansCost).round();
  }

  // Add family member function
  void addFamilyMember() {
    if (nameInput.value.trim().isEmpty || ageInput.value <= 0) {
      Get.snackbar(
        "Validation Error",
        "Please fill in a valid Name and Age.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    String mockAvatar = genderInput.value == "Male"
        ? "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150"
        : "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150";

    final newMember = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "name": nameInput.value.trim(),
      "relationship": relationshipInput.value,
      "age": ageInput.value,
      "gender": genderInput.value,
      "image": mockAvatar,
      "hasActivePlan": false,
      "activePlanName": "",
      "planProgressPercent": 0.0,
      "daysLeft": 0,
      "compliancePercent": 0,
      "weightHistory": [70.0],
      "caloriesGoal": "1,500 kcal",
      "waterGoal": "2.4 L"
    };

    familyMembers.add(newMember);

    // Reset inputs
    nameInput.value = "";
    relationshipInput.value = "Wife";
    ageInput.value = 0;
    genderInput.value = "Female";

    Get.snackbar(
      "Member Added",
      "Successfully added ${newMember['name']} to your Family Hub. You now unlock a larger family plan discount!",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Activate plan simulation for a family member
  void activatePlanForMember(int id) {
    int index = familyMembers.indexWhere((m) => m["id"] == id);
    if (index != -1) {
      var member = Map<String, dynamic>.from(familyMembers[index]);
      member["hasActivePlan"] = true;
      member["activePlanName"] = "Adaptive Weight Loss";
      member["planProgressPercent"] = 0.03; // Day 1
      member["daysLeft"] = 30;
      member["compliancePercent"] = 100;
      member["weightHistory"] = [member["weightHistory"].first];
      
      familyMembers[index] = member;

      Get.snackbar(
        "Plan Activated",
        "Personalized plan unlocked for ${member['name']}. Active timer started!",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Remove member from family hub
  void removeMember(int id) {
    familyMembers.removeWhere((m) => m["id"] == id);
    Get.snackbar(
      "Member Removed",
      "Profile successfully removed from Family Hub.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
