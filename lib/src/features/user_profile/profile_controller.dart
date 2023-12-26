import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/features/user_profile/profile.dart';
import 'package:datingapp/src/features/user_profile/profile_repository.dart';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

// * ---------------------------------------------------------------------------
// * HomeAccountController
// * ---------------------------------------------------------------------------

class UserProfileController extends StateNotifier<AsyncValue<ProfileList?>> {
  UserProfileController({required this.profileRepo})
      : super(const AsyncData(null));

  final UserProfileRepository profileRepo;
  ProfileList? get currProfile => profileRepo.currProfile;

  Future<void> deUserProfileInfoData(String articleId) async {
    // state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => profileRepo.doGetProfile(articleId));
    if (mounted) {
      state = newState;
    }
  }

}

final profileProvider = StateNotifierProvider.autoDispose<
    UserProfileController, AsyncValue<ProfileList?>>((ref) {
  return UserProfileController(
      profileRepo: ref.watch(profileRepositoryProvider));
});


