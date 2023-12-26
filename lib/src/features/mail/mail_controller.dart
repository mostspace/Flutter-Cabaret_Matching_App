import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/features/mail/mail_repository.dart';
import 'package:datingapp/src/features/mail/mail_data.dart';
class MailController extends StateNotifier<AsyncValue<MailList>> {
  MailController({required this.notifRepo}) : super(const AsyncData([]));

  final MailRepository notifRepo;

  Future<void> doFetchNotifs() async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doFetchNotifs());
    if (mounted) {
      state = newState;
    }
    return;
  }
}

final mailDataProvider = StateNotifierProvider.autoDispose<MailController,
    AsyncValue<MailList>>((ref) {
  return MailController(notifRepo: ref.watch(MailProvider));
});
