import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Global dark-theme shimmer config used across the entire app.
/// Wrap any widget with [AppShimmer] to apply a shimmer while loading.
class AppShimmer extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const AppShimmer({
    super.key,
    required this.enabled,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enabled,
      enableSwitchAnimation: true,
      effect: ShimmerEffect(
        baseColor: const Color(0xff1C1C2E),
        highlightColor: const Color(0xff2E2E45),
        duration: const Duration(milliseconds: 1200),
      ),
      child: child,
    );
  }
}
