import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/features/search/search_repository.dart';
import 'package:datingapp/src/features/search/search_data.dart';
class SearchController extends StateNotifier<AsyncValue<SearchList>> {
  SearchController({required this.notifRepo}) : super(const AsyncData([]));

  final SearchRepository notifRepo;

  Future<void> doFetchNotifs() async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doFetchNotifs());
    if (mounted) {
      state = newState;
    }
    return;
  }
}

final searchDataProvider = StateNotifierProvider.autoDispose<SearchController,
    AsyncValue<SearchList>>((ref) {
  return SearchController(notifRepo: ref.watch(SearchProvider));
});
