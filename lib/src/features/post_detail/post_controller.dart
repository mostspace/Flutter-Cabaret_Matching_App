import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/features/post_detail/post_repository.dart';
import 'package:datingapp/src/features/post_detail/post_data.dart';
class PostController extends StateNotifier<AsyncValue<PostList>> {
  PostController({required this.notifRepo}) : super(const AsyncData([]));

  final PostRepository notifRepo;

  Future<void> doParentData(String article_id) async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doParentData(article_id));
    if (mounted) {
      state = newState;
    }
    return;
  }
}

final postDataProvider = StateNotifierProvider.autoDispose<PostController,
    AsyncValue<PostList>>((ref) {
  return PostController(notifRepo: ref.watch(PostProvider));
});
