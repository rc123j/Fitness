import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class IapService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final InAppPurchase _iap = InAppPurchase.instance;

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // Premium state and available plans
  final isPremium = false.obs;
  final premiumExpiry = Rxn<DateTime>();
  final activePlanName = ''.obs;
  final availablePlans = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  Future<IapService> init() async {
    // 1. Listen to native purchase update stream
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onError: (error) {
        print('IAP Stream Error: $error');
      },
    );

    // 2. Fetch initial premium status & plans asynchronously after app mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkPremiumStatus();
      fetchAvailablePlans();
    });

    return this;
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  // Retrieve premium status from our backend
  Future<void> checkPremiumStatus() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.subscriptionStatus);
      if (response.statusCode == 200) {
        final isPrem = response.data['is_premium'] as bool;
        isPremium.value = isPrem;
        
        if (isPrem && response.data['subscription'] != null) {
          final sub = response.data['subscription'];
          activePlanName.value = sub['plan_name'] ?? '';
          if (sub['expires_at'] != null) {
            premiumExpiry.value = DateTime.parse(sub['expires_at']);
          }
        } else {
          activePlanName.value = '';
          premiumExpiry.value = null;
        }
      }
    } catch (e) {
      print('Failed to check premium status: $e');
    }
  }

  // Fetch subscription plans from backend and merge with store details
  Future<void> fetchAvailablePlans() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.get(ApiEndpoints.subscriptionPlans);
      if (response.statusCode != 200) return;

      final List<dynamic> backendPlans = response.data;
      if (backendPlans.isEmpty) {
        availablePlans.clear();
        return;
      }

      // Check if Store billing is available on the device
      final bool isStoreAvailable = await _iap.isAvailable();
      if (!isStoreAvailable) {
        // Fallback for emulators: display plans with database prices (offline testing mode)
        availablePlans.value = backendPlans.map((bp) {
          return {
            'db_id': bp['id'],
            'product_id': Platform.isIOS ? bp['apple_product_id'] : bp['google_product_id'],
            'title': bp['name'],
            'description': '${bp['duration']} subscription plan',
            'price': '₹${bp['price'].toString().replaceAll(RegExp(r'\.00$'), '')}',
            'rawPrice': double.tryParse(bp['price'].toString()) ?? 0.0,
            'duration': bp['duration'],
            'is_recurring': bp['is_recurring'],
            'store_product': null, // No native product link
          };
        }).toList();
        return;
      }

      // Query native prices from App Store / Google Play Console
      final Set<String> productIds = backendPlans
          .map((bp) => (Platform.isIOS ? bp['apple_product_id'] : bp['google_product_id']).toString())
          .toSet();

      final ProductDetailsResponse productResponse = await _iap.queryProductDetails(productIds);
      
      // Merge Store localized prices with database metadata
      final List<Map<String, dynamic>> plans = [];
      for (var bp in backendPlans) {
        final String pid = Platform.isIOS ? bp['apple_product_id'] : bp['google_product_id'];
        
        // Find matching Store Details
        ProductDetails? storeDetails;
        try {
          storeDetails = productResponse.productDetails.firstWhere((element) => element.id == pid);
        } catch (_) {}

        plans.add({
          'db_id': bp['id'],
          'product_id': pid,
          'title': bp['name'],
          'description': storeDetails?.description ?? '${bp['duration']} subscription plan',
          'price': storeDetails?.price ?? '₹${bp['price'].toString().replaceAll(RegExp(r'\.00$'), '')}',
          'rawPrice': storeDetails?.rawPrice ?? (double.tryParse(bp['price'].toString()) ?? 0.0),
          'duration': bp['duration'],
          'is_recurring': bp['is_recurring'],
          'store_product': storeDetails, // Store product details used for purchasing
        });
      }

      availablePlans.value = plans;
    } catch (e) {
      print('Error fetching plans: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Trigger Native Store checkout sheet
  Future<void> buyPlan(Map<String, dynamic> plan) async {
    try {
      isLoading.value = true;
      final ProductDetails? productDetails = plan['store_product'] as ProductDetails?;

      if (productDetails == null) {
        // Developer sandbox fallback: If running on an emulator with no native billing connection, 
        // simulate the purchase validation directly with a mock receipt token
        await _mockVerifyWithBackend(plan);
        return;
      }

      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
      
      if (plan['is_recurring'] == true) {
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        await _iap.buyConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      Get.snackbar('Purchase Error', 'Failed to initialize purchase: $e');
      isLoading.value = false;
    }
  }

  // Restore previous transactions
  Future<void> restorePurchases() async {
    try {
      isLoading.value = true;
      await _iap.restorePurchases();
    } catch (e) {
      Get.snackbar('Restore Error', 'Failed to restore purchases: $e');
      isLoading.value = false;
    }
  }

  // Private listener for purchase stream updates
  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        // Show loading indicator
      } else if (purchase.status == PurchaseStatus.error) {
        print('Purchase Stream Error: ${purchase.error}');
        isLoading.value = false;
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      } else if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        // Send receipt to Backend verification endpoint
        final bool verified = await _verifyReceiptWithBackend(purchase);
        if (verified) {
          isPremium.value = true;
          await checkPremiumStatus();
          Get.snackbar('Success', 'Premium subscription activated!');
        } else {
          Get.snackbar('Verification Failed', 'Unable to verify payment with the server. Please contact support.');
        }
        isLoading.value = false;

        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      }
    }
  }

  // Send raw receipt payload to Node.js backend
  Future<bool> _verifyReceiptWithBackend(PurchaseDetails purchase) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyPurchase,
        data: {
          'productId': purchase.productID,
          'purchaseToken': purchase.verificationData.serverVerificationData,
          'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
          'originalTransactionId': purchase.purchaseID,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return true;
      }
    } catch (e) {
      print('Backend receipt validation error: $e');
    }
    return false;
  }

  // Emulator sandbox fallback verification
  Future<void> _mockVerifyWithBackend(Map<String, dynamic> plan) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyPurchase,
        data: {
          'productId': plan['product_id'],
          'purchaseToken': 'mock_sandbox_token_${DateTime.now().millisecondsSinceEpoch}',
          'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
          'originalTransactionId': 'mock_tx_${DateTime.now().millisecondsSinceEpoch}',
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        isPremium.value = true;
        await checkPremiumStatus();
        Get.snackbar('Mock Success', 'Premium subscription activated via developer mock verification!');
      } else {
        Get.snackbar('Verification Failed', 'Mock purchase validation failed on backend.');
      }
    } catch (e) {
      print('Mock validation error: $e');
      Get.snackbar('Connection Error', 'Failed to reach validation server.');
    } finally {
      isLoading.value = false;
    }
  }
}
