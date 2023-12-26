import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/features/home/home_repository.dart';
import 'package:datingapp/src/features/home/article_data.dart';
class HomeGoodController extends StateNotifier<AsyncValue<ArticleList>> {
  HomeGoodController({required this.notifRepo}) : super(const AsyncData([]));

  final HomeRepository notifRepo;

  Future<void> doFetchNotifs() async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doFetchNotifs());
    if (mounted) {
      state = newState;
    }
    return;
  }
}

final homeDataProvider = StateNotifierProvider.autoDispose<HomeGoodController,
    AsyncValue<ArticleList>>((ref) {
  return HomeGoodController(notifRepo: ref.watch(HomeProvider));
});
