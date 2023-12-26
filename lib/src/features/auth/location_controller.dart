import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/features/auth/location_repository.dart';
import 'package:datingapp/src/features/auth/location_list.dart';

class LocationController extends StateNotifier<AsyncValue<LocationList>> {
  LocationController({required this.notifRepo}) : super(const AsyncData([]));

  final LocationRepository notifRepo;

  Future<void> doLocationData() async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doLocationData());
    if (mounted) {
      state = newState;
    }
    return;
  }
}

final locationProvider = StateNotifierProvider.autoDispose<LocationController,
    AsyncValue<LocationList>>((ref) {
  return LocationController(notifRepo: ref.watch(LocationRepositoryProvider));
});