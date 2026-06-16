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
      "name": "Rohit Sharma",
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
          "comment": "Rohit's guidance transformed my eating habits completely. Lost 8 kgs in 2 months without compromising on nutrition!",
          "image": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150"
        },
        {
          "name": "Aman Verma",
          "rating": 5,
          "comment": "The personalized plans are very easy to follow and highly sustainable. Highly recommended coach!",
          "image": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150"
        }
      ]
    },
    {
      "name": "Meera Joshi",
      "role": "Fitness Trainer",
      "image": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=200",
      "rating": 4.8,
      "reviewsCount": 180,
      "experience": "5+ Years",
      "clients": "800+",
      "location": "Pune, India",
      "bio": "Specialized in functional strength training, posture correction, and body recomposition.",
      "tags": ["Strength Training", "Posture", "Body Recomp"],
      "aboutText": "Certified personal trainer dedicated to designing interactive workouts that build core strength and endurance.",
      "credentials": [
        "ACE Certified Personal Trainer",
        "Functional Training Specialist",
        "Cardio-kickboxing Coach"
      ],
      "services": [
        {"title": "1-on-1 Workout Session", "duration": "60 mins", "price": 1200, "type": "video"},
        {"title": "Weekly Custom Routine", "duration": "7 Days", "price": 1800, "type": "plan"}
      ],
      "reviews": [
        {
          "name": "Karan P.",
          "rating": 5,
          "comment": "Meera is fantastic! She pushes you to your limits safely. My posture has improved dramatically.",
          "image": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=150"
        }
      ]
    },
    {
      "name": "Arjun Mehta",
      "role": "Strength Coach",
      "image": "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=200",
      "rating": 5.0,
      "reviewsCount": 410,
      "experience": "10+ Years",
      "clients": "2.1K+",
      "location": "Delhi, India",
      "bio": "Elite strength coach focused on powerlifting, hypertrophy, and athletic performance scaling.",
      "tags": ["Powerlifting", "Hypertrophy", "Athletic Prep"],
      "aboutText": "Coached national level athletes in powerlifting and physical preparation. I focus on heavy lifts and correct biomechanics.",
      "credentials": [
        "CSCS Strength & Conditioning Specialist",
        "USAW Olympic Weightlifting Coach",
        "IPF Powerlifting Referee"
      ],
      "services": [
        {"title": "Form Check Video Call", "duration": "30 mins", "price": 1500, "type": "video"},
        {"title": "12-Week Prep Plan", "duration": "Custom Periodization", "price": 4999, "type": "plan"}
      ],
      "reviews": [
        {
          "name": "Sameer K.",
          "rating": 5,
          "comment": "Arjun helped me add 50kg to my squat. His programming style is next level.",
          "image": "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=150"
        }
      ]
    },
    {
      "name": "Dr. Neha Verma",
      "role": "Dietitian",
      "image": "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=200",
      "rating": 4.7,
      "reviewsCount": 240,
      "experience": "7+ Years",
      "clients": "1.5K+",
      "location": "Mumbai, India",
      "bio": "Registered clinical dietitian managing diabetes, thyroid disorders, and gut health restoration.",
      "tags": ["Clinical Nutrition", "Diabetes", "Gut Health"],
      "aboutText": "Helping you manage clinical issues through scientifically-backed custom dietary protocols and lifestyle tweaks.",
      "credentials": [
        "Registered Dietitian (RD)",
        "M.Sc in Clinical Nutrition",
        "Certified Diabetes Educator"
      ],
      "services": [
        {"title": "Clinical Diet Consultation", "duration": "45 mins", "price": 1100, "type": "video"},
        {"title": "Monthly Clinical Plan", "duration": "30 Days", "price": 2999, "type": "plan"}
      ],
      "reviews": [
        {
          "name": "Reema G.",
          "rating": 5,
          "comment": "Dr. Neha's advice helped me bring my thyroid levels to normal. I feel much more energetic.",
          "image": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150"
        }
      ]
    },
    {
      "name": "Karan Malhotra",
      "role": "Physiotherapist",
      "image": "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?q=80&w=200",
      "rating": 4.9,
      "reviewsCount": 290,
      "experience": "9+ Years",
      "clients": "1.8K+",
      "location": "Bengaluru, India",
      "bio": "Sports physiotherapist specializing in injury rehabilitation, joint mobility, and muscle activation.",
      "tags": ["Injury Rehab", "Mobility", "Dry Needling"],
      "aboutText": "Helping athletes recover from tears, sprains, and chronic back pain using advanced therapy techniques.",
      "credentials": [
        "Master of Physiotherapy (MPT)",
        "Dry Needling Certified Practitioner",
        "Kinesio Taping Therapist"
      ],
      "services": [
        {"title": "Rehab Assessment Call", "duration": "45 mins", "price": 999, "type": "video"},
        {"title": "Weekly Rehab Exercises", "duration": "7 Days Setup", "price": 1499, "type": "plan"}
      ],
      "reviews": [
        {
          "name": "Rohan D.",
          "rating": 5,
          "comment": "Karan cured my shoulder impingement. Extremely knowledgeable physio.",
          "image": "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150"
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
