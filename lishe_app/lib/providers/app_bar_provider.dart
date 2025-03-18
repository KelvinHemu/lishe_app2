import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarState {
  final int notificationCount;

  AppBarState({this.notificationCount = 0});

  AppBarState copyWith({int? notificationCount}) {
    return AppBarState(
      notificationCount: notificationCount ?? this.notificationCount,
    );
  }
}

class AppBarNotifier extends StateNotifier<AppBarState> {
  AppBarNotifier() : super(AppBarState());

  void setNotificationCount(int count) {
    state = state.copyWith(notificationCount: count);
  }
}

final appBarProvider = StateNotifierProvider<AppBarNotifier, AppBarState>((
  ref,
) {
  return AppBarNotifier();
});
