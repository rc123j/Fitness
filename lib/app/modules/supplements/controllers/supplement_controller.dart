import 'package:get/get.dart';

class SupplementController extends GetxController {
  // Selected category tab (All, Protein, Performance, Health/Wellness, Essentials)
  final selectedCategory = "All".obs;

  // Search Query
  final searchQuery = "".obs;

  // Mock Supplements Database
  final supplementsList = <Map<String, dynamic>>[
    {
      "name": "Whey Protein Isolate",
      "brand": "Optimum Nutrition",
      "category": "Protein",
      "price": 3499,
      "rating": 4.8,
      "reviews": 1240,
      "servings": "60 Servings",
      "goalTags": ["Muscle Gain", "Fat Loss"],
      "image": "https://images.unsplash.com/photo-1579758629938-03607ccdbaba?q=80&w=200",
      "desc": "Ultra-pure whey isolate for rapid muscle recovery and lean muscle synthesis. Zero sugar, low carb.",
      "dosage": "1 scoop (30g) post-workout in 250ml water."
    },
    {
      "name": "Micronized Creatine",
      "brand": "MuscleBlaze",
      "category": "Performance",
      "price": 1199,
      "rating": 4.9,
      "reviews": 850,
      "servings": "83 Servings",
      "goalTags": ["Muscle Gain", "Strength"],
      "image": "https://images.unsplash.com/photo-1593079831268-3381b0db4a77?q=80&w=200",
      "desc": "Pure micronized creatine monohydrate to boost muscle ATP, strength, power, and cellular hydration.",
      "dosage": "3g daily mixed with water or your protein shake."
    },
    {
      "name": "Triple Strength Fish Oil",
      "brand": "Swisse",
      "category": "Wellness",
      "price": 1499,
      "rating": 4.7,
      "reviews": 620,
      "servings": "90 Capsules",
      "goalTags": ["Wellness", "Heart Health", "Fat Loss"],
      "image": "https://images.unsplash.com/photo-1611926653458-09294b3142bf?q=80&w=200",
      "desc": "Rich in EPA and DHA to support cardiovascular health, joint mobility, cognitive function, and reduce inflammation.",
      "dosage": "1 softgel capsule daily during lunch."
    },
    {
      "name": "Daily Multivitamin Active",
      "brand": "GNC",
      "category": "Essentials",
      "price": 899,
      "rating": 4.6,
      "reviews": 430,
      "servings": "60 Tablets",
      "goalTags": ["Wellness", "Immunity", "Energy"],
      "image": "https://images.unsplash.com/photo-1584017911766-d451b3d0e843?q=80&w=200",
      "desc": "Comprises 38 essential vitamins, minerals, and antioxidants tailored for active fitness enthusiasts.",
      "dosage": "1 tablet daily after breakfast."
    },
    {
      "name": "Hydration Electrolytes Pack",
      "brand": "Fast&Up",
      "category": "Essentials",
      "price": 450,
      "rating": 4.8,
      "reviews": 920,
      "servings": "20 Effervescent Tablets",
      "goalTags": ["Hydration", "Muscle Cramp Relief"],
      "image": "https://images.unsplash.com/photo-1622483767028-3f66f32aef97?q=80&w=200",
      "desc": "Effervescent electrolyte tabs featuring Sodium, Potassium, Magnesium, and Zinc to maintain peak hydration balance.",
      "dosage": "Dissolve 1 tablet in 500ml water. Consume during workout."
    },
    {
      "name": "L-Carnitine Liquid L-Tartrate",
      "brand": "MusclePharm",
      "category": "Performance",
      "price": 1899,
      "rating": 4.5,
      "reviews": 310,
      "servings": "31 Servings",
      "goalTags": ["Fat Loss", "Metabolism Boost"],
      "image": "https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?q=80&w=200",
      "desc": "Helps convert fatty acids into cellular energy, promoting fat oxidation and enhancing endurance performance.",
      "dosage": "1 tablespoon (15ml) empty stomach or pre-workout."
    },
    {
      "name": "Plant Protein Organic Blend",
      "brand": "Cosmix",
      "category": "Protein",
      "price": 2899,
      "rating": 4.7,
      "reviews": 210,
      "servings": "30 Servings",
      "goalTags": ["Muscle Gain", "Fat Loss", "Vegan"],
      "image": "https://images.unsplash.com/photo-1579758629938-03607ccdbaba?q=80&w=200",
      "desc": "Vegan blend of organic pea, brown rice, and mung bean proteins with added plant enzymes for clean digestion.",
      "dosage": "1 scoop (35g) shaken in 300ml almond or oat milk."
    }
  ].obs;

  // Filtered list getter based on category and search query
  List<Map<String, dynamic>> get filteredSupplements {
    return supplementsList.where((item) {
      // Category filter
      bool matchesCategory = true;
      if (selectedCategory.value != "All") {
        matchesCategory = item["category"] == selectedCategory.value;
      }

      // Search query filter
      bool matchesSearch = true;
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final name = item["name"].toString().toLowerCase();
        final brand = item["brand"].toString().toLowerCase();
        final desc = item["desc"].toString().toLowerCase();
        matchesSearch = name.contains(query) || brand.contains(query) || desc.contains(query);
      }

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Trigger add to cart or checkout dialog simulation
  void purchaseSupplement(String name, int price) {
    Get.snackbar(
      "Cart Added",
      "Successfully added $name (₹$price) to your order checklist.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
