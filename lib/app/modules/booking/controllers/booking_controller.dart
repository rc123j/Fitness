import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import '../../../services/api_client.dart';

class BookingController extends GetxController {
  final _apiClient = Get.find<ApiClient>();

  // UI state variables
  final selectedExpertIndex = 0.obs;
  final activeTab = "About".obs;
  final selectedDateIndex = 0.obs;
  final selectedTimeSlotIndex = 0.obs;
  final searchQuery = "".obs;

  // Real data state lists
  final experts = <Map<String, dynamic>>[].obs;
  final allAvailableSlots = <Map<String, dynamic>>[].obs;
  final clientAppointments = <Map<String, dynamic>>[].obs;

  // Consultant portal data state lists
  final expertAppointments = <Map<String, dynamic>>[].obs;
  final expertSlots = <Map<String, dynamic>>[].obs;
  // Messenger-style inbox: one entry per client, each with its last
  // message + unread count, instead of hunting through each booking.
  final consultantConversations = <Map<String, dynamic>>[].obs;

  // Loading states
  final isLoadingExperts = false.obs;
  final isLoadingSlots = false.obs;
  final isLoadingAppointments = false.obs;
  final isLoadingConversations = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial data
    fetchExperts();
    fetchAvailableSlots();
    fetchClientAppointments();
  }

  // --- API FETCH METHODS ---

  Future<void> fetchExperts() async {
    isLoadingExperts.value = true;
    try {
      final response = await _apiClient.get('/api/bookings/experts');
      final list = List<dynamic>.from(response.data);
      _populateExperts(list);
    } catch (e) {
      debugPrint("Error fetching experts: $e");
    } finally {
      isLoadingExperts.value = false;
    }
  }

  Future<void> fetchAvailableSlots() async {
    isLoadingSlots.value = true;
    try {
      final response = await _apiClient.get('/api/bookings/slots');
      final list = List<dynamic>.from(response.data);
      allAvailableSlots.value = list
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      debugPrint("Error fetching slots: $e");
    } finally {
      isLoadingSlots.value = false;
    }
  }

  Future<void> fetchClientAppointments() async {
    isLoadingAppointments.value = true;
    try {
      final response = await _apiClient.get('/api/bookings/my-appointments');
      final list = List<dynamic>.from(response.data);
      clientAppointments.value = list
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      debugPrint("Error fetching client appointments: $e");
    } finally {
      isLoadingAppointments.value = false;
    }
  }

  Future<void> fetchExpertAppointments() async {
    isLoadingAppointments.value = true;
    try {
      final response = await _apiClient.get(
        '/api/bookings/consultant/my-appointments',
      );
      final list = List<dynamic>.from(response.data);
      expertAppointments.value = list
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      debugPrint("Error fetching expert appointments: $e");
    } finally {
      isLoadingAppointments.value = false;
    }
  }

  Future<void> fetchExpertSlots() async {
    isLoadingSlots.value = true;
    try {
      final response = await _apiClient.get('/api/bookings/consultant/slots');
      final list = List<dynamic>.from(response.data);
      expertSlots.value = list
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      debugPrint("Error fetching expert slots: $e");
    } finally {
      isLoadingSlots.value = false;
    }
  }

  Future<void> fetchConsultantConversations() async {
    isLoadingConversations.value = true;
    try {
      final response = await _apiClient.get(
        '/api/bookings/consultant/conversations',
      );
      final list = List<dynamic>.from(response.data);
      consultantConversations.value = list
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      debugPrint("Error fetching conversations: $e");
    } finally {
      isLoadingConversations.value = false;
    }
  }

  // --- ACTIONS ---

  /// Returns true on success so the calling screen only navigates away
  /// (e.g. to My Sessions) when the booking actually went through, instead
  /// of always navigating regardless of a failed/rejected request.
  Future<bool> bookSession([String notes = '']) async {
    final daySlots = currentDateTimeSlots;
    if (daySlots.isEmpty || selectedTimeSlotIndex.value >= daySlots.length) {
      Get.snackbar(
        "Error",
        "No slot selected.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    final slotId = daySlots[selectedTimeSlotIndex.value]['id'];

    try {
      await _apiClient.post(
        '/api/bookings/reserve',
        data: {'slot_id': slotId, 'notes': notes},
      );

      Get.snackbar(
        "Booking Success",
        "Successfully booked session with ${currentExpert['name']}.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff00FF87).withOpacity(0.2),
        colorText: Colors.white,
      );

      // Refresh data
      fetchAvailableSlots();
      fetchClientAppointments();
      return true;
    } catch (e) {
      Get.snackbar(
        "Booking Failed",
        _extractErrorMessage(e),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// Pulls the backend's clean `message` field out of a failed request
  /// instead of surfacing a raw "DioException [bad response]: ..." string.
  String _extractErrorMessage(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
    }
    return "Something went wrong. Please try again.";
  }

  Future<void> cancelAppointment(int appointmentId) async {
    try {
      await _apiClient.put('/api/bookings/appointments/$appointmentId/cancel');

      Get.snackbar(
        "Cancelled",
        "Your booking has been cancelled successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFF00E5).withOpacity(0.2),
        colorText: Colors.white,
      );

      // Refresh data
      fetchAvailableSlots();
      fetchClientAppointments();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to cancel booking: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> addAvailabilitySlot(DateTime start, DateTime end) async {
    isLoadingSlots.value = true;
    try {
      await _apiClient.post(
        '/api/bookings/slots',
        data: {
          'start_time': start.toUtc().toIso8601String(),
          'end_time': end.toUtc().toIso8601String(),
        },
      );
      Get.snackbar(
        "Slot Saved",
        "Availability slot added successfully.",
        snackPosition: SnackPosition.BOTTOM,
      );
      fetchExpertSlots();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to save slot: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingSlots.value = false;
    }
  }

  Future<void> deleteAvailabilitySlot(int slotId) async {
    try {
      await _apiClient.delete('/api/bookings/slots/$slotId');
      Get.snackbar(
        "Slot Deleted",
        "Availability slot removed successfully.",
        snackPosition: SnackPosition.BOTTOM,
      );
      fetchExpertSlots();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete slot: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> respondToAppointment(int appointmentId, String status) async {
    try {
      await _apiClient.post(
        '/api/bookings/$appointmentId/approve',
        data: {'status': status},
      );
      Get.snackbar(
        "Success",
        "Appointment $status successfully.",
        snackPosition: SnackPosition.BOTTOM,
      );
      fetchExpertAppointments();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to respond: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> rescheduleAppointment(int appointmentId, int newSlotId) async {
    try {
      await _apiClient.post(
        '/api/bookings/$appointmentId/reschedule',
        data: {'new_slot_id': newSlotId},
      );
      Get.snackbar(
        "Rescheduled",
        "Appointment rescheduled successfully.",
        snackPosition: SnackPosition.BOTTOM,
      );
      fetchClientAppointments();
      fetchExpertAppointments();
      fetchAvailableSlots();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to reschedule: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> completeAppointment(
    int appointmentId,
    String expertNotes,
  ) async {
    try {
      await _apiClient.post(
        '/api/bookings/$appointmentId/complete',
        data: {'expert_notes': expertNotes},
      );
      Get.snackbar(
        "Completed",
        "Consultation completed successfully.",
        snackPosition: SnackPosition.BOTTOM,
      );
      fetchExpertAppointments();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to complete: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // --- DYNAMIC GETTERS FOR CLIENT BOOKING VIEW ---

  Map<String, dynamic> get currentExpert {
    if (experts.isEmpty || selectedExpertIndex.value >= experts.length) {
      return {};
    }
    return experts[selectedExpertIndex.value];
  }

  /// The member's own PENDING or APPROVED appointment with the currently
  /// viewed expert, if any — used to show "View Booked Session" instead of
  /// silently letting the member queue up duplicate bookings with the same
  /// expert (the backend also rejects this, but the UI should make it
  /// obvious upfront rather than only failing after they try).
  Map<String, dynamic>? get activeBookingWithCurrentExpert {
    final expertId = currentExpert['id'];
    if (expertId == null) return null;
    for (final apt in clientAppointments) {
      final status = apt['status'];
      if (apt['consultant']?['id'] == expertId &&
          (status == 'PENDING' || status == 'APPROVED')) {
        final slot = apt['slot'] ?? {};
        final endStr = (slot['end_time'] ?? slot['start_time'])?.toString();
        if (endStr != null) {
          final endTime = DateTime.tryParse(endStr)?.toLocal();
          if (endTime != null && DateTime.now().isAfter(endTime)) {
            continue; // Ignore expired session
          }
        }
        return apt;
      }
    }
    return null;
  }

  List<Map<String, dynamic>> get currentExpertSlots {
    if (experts.isEmpty || selectedExpertIndex.value >= experts.length)
      return [];
    final expertId = currentExpert['id'];
    return allAvailableSlots
        .where((s) => s['consultant_id'] == expertId)
        .toList();
  }

  List<Map<String, String>> get dates {
    final slots = currentExpertSlots;
    if (slots.isEmpty) return [];

    final Map<String, DateTime> uniqueDates = {};
    for (final s in slots) {
      if (s['start_time'] == null) continue;
      final dt = DateTime.parse(s['start_time']).toLocal();
      final key = DateFormat('yyyy-MM-dd').format(dt);
      if (!uniqueDates.containsKey(key)) {
        uniqueDates[key] = dt;
      }
    }

    final sortedKeys = uniqueDates.keys.toList()..sort();
    return sortedKeys.map((key) {
      final dt = uniqueDates[key]!;
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 1));

      String dayLabel = DateFormat('E').format(dt);
      if (isSameDay(dt, today)) {
        dayLabel = "Today";
      } else if (isSameDay(dt, tomorrow)) {
        dayLabel = "Tomorrow";
      }

      final dateLabel = DateFormat('dd MMM').format(dt);
      final count = slots
          .where(
            (s) =>
                DateFormat(
                  'yyyy-MM-dd',
                ).format(DateTime.parse(s['start_time']).toLocal()) ==
                key,
          )
          .length;

      return {
        "day": dayLabel,
        "date": dateLabel,
        "rawDate": key,
        "slots": "$count Slots",
      };
    }).toList();
  }

  List<Map<String, dynamic>> get currentDateTimeSlots {
    final slots = currentExpertSlots;
    final dateList = dates;
    if (slots.isEmpty ||
        dateList.isEmpty ||
        selectedDateIndex.value < 0 ||
        selectedDateIndex.value >= dateList.length)
      return [];

    final selectedRawDate = dateList[selectedDateIndex.value]['rawDate'];
    final daySlots = slots.where((s) {
      final dt = DateTime.parse(s['start_time']).toLocal();
      return DateFormat('yyyy-MM-dd').format(dt) == selectedRawDate;
    }).toList();

    daySlots.sort(
      (a, b) => DateTime.parse(
        a['start_time'],
      ).compareTo(DateTime.parse(b['start_time'])),
    );
    return daySlots;
  }

  List<String> get timeSlots {
    return currentDateTimeSlots.map((s) {
      final dt = DateTime.parse(s['start_time']).toLocal();
      return DateFormat('hh:mm a').format(dt);
    }).toList();
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // --- HELPERS ---

  void _populateExperts(List<dynamic> backendList) {
    if (backendList.isEmpty) {
      experts.clear();
      return;
    }

    experts.value = backendList.map((e) {
      final firstName = e['first_name'] ?? 'Coach';
      final lastName = e['last_name'] ?? '';
      final expertId = e['id'] ?? 0;

      return {
        "id": expertId,
        "name": "$firstName $lastName",
        "role": "Nutrition Coach",
        "image":
            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200",
        "rating": 4.9,
        "reviewsCount": 120 + expertId * 10,
        "experience": "5+ Years",
        "clients": "500+",
        "location": "India",
        "bio":
            "Certified Nutrition Coach dedicated to helping individuals build sustainable eating habits.",
        "tags": ["Fat Loss", "Muscle Gain", "Weight Management"],
        "aboutText":
            "Certified Nutrition Coach with extensive experience in customized diet designs and lifestyle strategies.",
        "credentials": [
          "ISSA Certified Nutritionist",
          "Specialization in Weight Management",
        ],
        "services": [
          {
            "title": "Video Consultation",
            "duration": "30 mins",
            "price": 499,
            "type": "video",
          },
        ],
        "reviews": [
          {
            "name": "Amit K.",
            "rating": 5,
            "comment":
                "Excellent guidance! The plan was simple and highly practical to follow.",
            "image":
                "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150",
          },
        ],
      };
    }).toList();
  }
}
