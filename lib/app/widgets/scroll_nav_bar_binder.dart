import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../modules/main_navigation/controllers/main_navigation_controller.dart';

/// Owns a [ScrollController] local to wherever it's built and uses it to
/// hide/show the shared bottom nav bar as the wrapped scroll view moves —
/// hidden while scrolling further into content, shown again near the top.
///
/// Creating the controller here (rather than storing it on a singleton
/// GetX controller) keeps it private to this widget instance, so pushing
/// a second copy of the same screen on top of an already-mounted tab
/// never attaches one controller to two scroll views at once.
class ScrollNavBarBinder extends StatefulWidget {
  const ScrollNavBarBinder({required this.builder, super.key});

  final Widget Function(BuildContext context, ScrollController controller)
  builder;

  @override
  State<ScrollNavBarBinder> createState() => _ScrollNavBarBinderState();
}

class _ScrollNavBarBinderState extends State<ScrollNavBarBinder> {
  final ScrollController _scrollController = ScrollController();
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final double offset = _scrollController.offset;
    final navController = Get.find<MainNavigationController>();

    final double delta = offset - _lastScrollOffset;
    if (delta.abs() > 4) {
      if (delta > 0 && offset > 20) {
        navController.isNavBarVisible.value = false;
      } else if (delta < 0) {
        navController.isNavBarVisible.value = true;
      }
      _lastScrollOffset = offset;
    }

    if (offset <= 0) {
      navController.isNavBarVisible.value = true;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _scrollController);
}
