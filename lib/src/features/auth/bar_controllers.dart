import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/features/auth/bar_repository.dart';
import 'package:datingapp/src/features/auth/bar_list.dart';

class BarController extends StateNotifier<AsyncValue<BarList>> {
  BarController({required this.notifRepo}) : super(const AsyncData([]));

  final BarRepository notifRepo;

  Future<void> doBarData() async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doBarData());
    if (mounted) {
      state = newState;
    }
    return;
  }
}

final BarProvider = StateNotifierProvider.autoDispose<BarController,
    AsyncValue<BarList>>((ref) {
  return BarController(notifRepo: ref.watch(BarRepositoryProvider));
});