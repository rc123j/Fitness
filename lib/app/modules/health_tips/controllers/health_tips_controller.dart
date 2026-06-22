import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HealthTipsController extends GetxController {
  // Search query
  final searchQuery = "".obs;

  // Selected category tab
  final selectedCategory = "All".obs;

  // Categories list
  final categories = ["All", "Nutrition", "Workouts", "Mental Health", "Sleep"];

  // Mock Health Tips / Articles Database
  final healthTipsList = <Map<String, dynamic>>[
    {
      "id": 1,
      "title": "Top 5 High-Protein Snacks for Lean Muscle",
      "subtitle": "Easy grab-and-go options for busy athletes",
      "category": "Nutrition",
      "readTime": "3 min read",
      "image": "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=300",
      "likes": 240,
      "isLiked": false.obs,
      "content": "Meeting your daily protein target is essential for building muscle and promoting recovery. Here are five easy, high-protein snacks you can prepare under 5 minutes:\n\n1. Greek Yogurt with Chia Seeds: 15g protein. Greek yogurt is packed with casein protein which digests slowly and keeps you full.\n2. Hard-Boiled Eggs: 12g protein. A classic, portable protein source loaded with healthy fats and choline.\n3. Roasted Chickpeas: 7g protein. Perfect crunchy snack high in fiber and complex carbohydrates.\n4. Whey Protein Shake: 25g protein. The ultimate post-workout recovery convenience.\n5. Cottage Cheese with Berries: 14g protein. Rich in slow-release protein and antioxidants.",
      "takeaways": [
        "Greek yogurt offers excellent slow-release casein protein.",
        "Combine protein with fiber for longer satiety.",
        "Pre-boil eggs on Sunday for easy mid-week snack prep."
      ]
    },
    {
      "id": 2,
      "title": "Understanding Progressive Overload",
      "subtitle": "The key principle behind all muscle growth",
      "category": "Workouts",
      "readTime": "5 min read",
      "image": "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=300",
      "likes": 510,
      "isLiked": true.obs,
      "content": "Progressive overload is the gradual increase of stress placed upon the body during exercise training. If you don't continuously challenge your muscles, they will adapt and stop growing. You can achieve progressive overload in several ways:\n\n1. Increase resistance (lift heavier weights).\n2. Increase volume (perform more reps or sets).\n3. Improve form and control (slowing down the eccentric phase).\n4. Reduce rest times between sets to increase density.\n5. Increase frequency (training the muscle group more often).",
      "takeaways": [
        "Track every workout using a log to ensure weekly progress.",
        "Only increase weight if you can maintain strict form.",
        "Focus on slow negatives to increase time-under-tension."
      ]
    },
    {
      "id": 3,
      "title": "Mindfulness Methods for Stress & Cortisol Reduction",
      "subtitle": "How lower stress triggers faster fat loss",
      "category": "Mental Health",
      "readTime": "4 min read",
      "image": "https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=300",
      "likes": 185,
      "isLiked": false.obs,
      "content": "Chronically high stress levels trigger cortisol, a hormone that causes your body to hold onto visceral fat (especially around the abdominal area) and breaks down muscle tissue. Implementing mindfulness methods can reverse this state:\n\n1. Box Breathing: Inhale for 4s, hold 4s, exhale 4s, hold 4s. Instantly lowers heart rate and stress.\n2. Journaling: Write down stressors to externalize anxiety.\n3. Digital Detox: Turn off notifications 1 hour before bed to limit blue light and digital stress.\n4. Nature Walks: Spending 20 minutes outdoors decreases cortisol production rapidly.",
      "takeaways": [
        "Visceral fat storage is highly linked to high cortisol.",
        "Daily 5-minute breathing exercises reset the nervous system.",
        "Disconnect from screens before bed to promote melatonin release."
      ]
    },
    {
      "id": 4,
      "title": "The Science of Deep Sleep (REM & Deep Sleep Tiers)",
      "subtitle": "Optimize sleep hygiene for recovery",
      "category": "Sleep",
      "readTime": "6 min read",
      "image": "https://images.unsplash.com/photo-1511295742364-92767fa62d9f?q=80&w=300",
      "likes": 320,
      "isLiked": false.obs,
      "content": "Muscle recovery, growth hormone release, and fat metabolism occur primarily during deep sleep. If your sleep is disrupted, your body cannot heal. Optimize your cycles with these rules:\n\n1. Keep room temperature between 18-20°C. Cool environments prompt deep sleep.\n2. Eliminate light sources completely. Use blackout curtains or an eye mask.\n3. Avoid caffeine within 8 hours of sleep. Caffeine blocks adenosine receptors, preventing deep cycles.\n4. Sleep at the same time daily to maintain circadian rhythm.",
      "takeaways": [
        "Growth hormone peaks during deep sleep cycles.",
        "Avoid eating heavy meals 2-3 hours before bedtime.",
        "Cooler rooms dramatically improve sleep quality indicators."
      ]
    },
    {
      "id": 5,
      "title": "Keto Diet vs. Carb Cycling: Which is best?",
      "subtitle": "Deciding which nutritional strategy fits your body",
      "category": "Nutrition",
      "readTime": "5 min read",
      "image": "https://images.unsplash.com/photo-1505576399279-565b52d4ac71?q=80&w=300",
      "likes": 420,
      "isLiked": true.obs,
      "content": "Choosing between Keto and Carb Cycling depends on your metabolic flexibility and training intensity. Keto focuses on zero carbs to use fat for fuel, while Carb Cycling alternates high-carb days (to fuel heavy workouts) with low-carb days (to promote fat burning). Keto is excellent for steady energy and fat loss without hunger, while Carb Cycling is optimal for building muscle strength and maintaining athletic performance.",
      "takeaways": [
        "Keto is great for metabolic reset and insulin control.",
        "Carb cycling fuels high-intensity performance cleanly.",
        "Select the diet that you can stick to consistently."
      ]
    }
  ].obs;

  // Filtered getter
  List<Map<String, dynamic>> get filteredTips {
    return healthTipsList.where((item) {
      bool matchesCategory = true;
      if (selectedCategory.value != "All") {
        matchesCategory = item["category"] == selectedCategory.value;
      }

      bool matchesSearch = true;
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final title = item["title"].toString().toLowerCase();
        final subtitle = item["subtitle"].toString().toLowerCase();
        final content = item["content"].toString().toLowerCase();
        matchesSearch = title.contains(query) || subtitle.contains(query) || content.contains(query);
      }

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Toggle Like status
  void toggleLike(int id) {
    final index = healthTipsList.indexWhere((item) => item["id"] == id);
    if (index != -1) {
      final item = healthTipsList[index];
      final rxLiked = item["isLiked"] as RxBool;
      if (rxLiked.value) {
        rxLiked.value = false;
        item["likes"] = (item["likes"] as int) - 1;
      } else {
        rxLiked.value = true;
        item["likes"] = (item["likes"] as int) + 1;
      }
      healthTipsList.refresh();
    }
  }
}
