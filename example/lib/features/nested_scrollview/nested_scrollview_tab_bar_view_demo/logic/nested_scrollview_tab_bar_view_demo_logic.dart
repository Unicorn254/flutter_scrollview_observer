/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/fluttercandies/flutter_scrollview_observer
 * @Date: 2026-02-23 22:19:39
 */

import 'package:get/get.dart';
import 'package:scrollview_observer_example/features/nested_scrollview/nested_scrollview_tab_bar_view_demo/logic/nested_scrollview_tab_bar_view_demo_logic_tab_bar.dart';
import 'package:scrollview_observer_example/features/nested_scrollview/nested_scrollview_tab_bar_view_demo/state/nested_scrollview_tab_bar_view_demo_state.dart';

class NestedScrollViewTabBarViewDemoLogic extends GetxController
    with GetTickerProviderStateMixin {
  final NestedScrollViewTabBarViewDemoState state =
      NestedScrollViewTabBarViewDemoState();

  @override
  void onInit() async {
    super.onInit();

    onInitForTabBar();
  }

  void onDispose() {
    onDisposeForTabBar();
    state.outerScrollController.dispose();
  }
}
