import 'package:get/get.dart';

class BookingController extends GetxController {
  // Active expert ID or index (default 0 = Rohit Sharma)
  final selectedExpertIndex = 0.obs;

  // Active section tab: "About", "Services", "Reviews", "Gallery"
  final activeTab = "About".obs;

  // Active booking date index (default 0 = Today)
  final selectedDateIndex = 0.obs;

  // Active time slot index (default 0 = 10:00 AM)
  final selectedTimeSlotIndex = 0.obs;

  // Search Query
  final searchQuery = "".obs;

  // Experts database mock
  final experts = <Map<String, dynamic>>[
    {
      "name": "Rakesh Bharti",
      "role": "Nutrition Coach",
      "image": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200",
      "rating": 4.9,
      "reviewsCount": 320,
      "experience": "8+ Years",
      "clients": "1.2K+",
      "location": "Mumbai, India",
      "bio": "I help individuals build sustainable eating habits and achieve their fitness goals through personalized nutrition plans.",
      "tags": ["Fat Loss", "Muscle Gain", "PCOS/PCOD", "Weight Management"],
      "aboutText": "Certified Nutrition Coach with 8+ years of experience in helping people achieve their fitness and health goals with practical and sustainable nutrition strategies.",
      "credentials": [
        "ISSA Certified Nutritionist",
        "Specialization in Sports Nutrition",
        "Precision Nutrition Level 1"
      ],
      "services": [
        {"title": "Video Consultation", "duration": "45 mins", "price": 999, "type": "video"},
        {"title": "Chat Consultation", "duration": "7 Days Support", "price": 1499, "type": "chat"},
        {"title": "Personalized Plan", "duration": "Diet + Workout Plan", "price": 2499, "type": "plan"}
      ],
      "reviews": [
        {
          "name": "Priya S.",
          "rating": 5,
          "comment": "Rakesh's guidance transformed my eating habits completely. Lost 8 kgs in 2 months without compromising on nutrition!",
          "image": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150"
        },
        {
          "name": "Aman Verma",
          "rating": 5,
          "comment": "The personalized plans are very easy to follow and highly sustainable. Highly recommended coach!",
          "image": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150"
        }
      ]
    }
  ].obs;

  final dates = <Map<String, String>>[
    {"day": "Today", "date": "15 May", "slots": "10 Slots"},
    {"day": "Thu", "date": "16 May", "slots": "8 Slots"},
    {"day": "Fri", "date": "17 May", "slots": "10 Slots"},
    {"day": "Sat", "date": "18 May", "slots": "6 Slots"},
    {"day": "Sun", "date": "19 May", "slots": "8 Slots"},
    {"day": "Mon", "date": "20 May", "slots": "10 Slots"},
    {"day": "Tue", "date": "21 May", "slots": "7 Slots"},
  ];

  final timeSlots = <String>[
    "10:00 AM",
    "12:00 PM",
    "02:00 PM",
    "04:00 PM",
    "06:00 PM"
  ];

  Map<String, dynamic> get currentExpert => experts[selectedExpertIndex.value];

  void bookSession() {
    Get.snackbar(
      "Booking Success",
      "Successfully booked session with ${currentExpert['name']} for ${dates[selectedDateIndex.value]['date']} at ${timeSlots[selectedTimeSlotIndex.value]}.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
