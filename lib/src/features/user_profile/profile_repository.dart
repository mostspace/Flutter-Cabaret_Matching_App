import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/exceptions/app_exception.dart';
import 'package:datingapp/src/features/auth/auth_repository.dart';
import 'package:datingapp/src/features/user_profile/profile.dart';
import 'package:datingapp/src/model/dio_client.dart';
import 'package:datingapp/src/utils/in_memory_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileRepository {
  UserProfileRepository({required this.authRepo});

  final AuthRepository authRepo;
  //Profile? _profile;

  ProfileList? get currProfile => _profileState.value;

  final _profileState = InMemoryStore<ProfileList?>(null);
  Stream<ProfileList?> profileStateChanges() => _profileState.stream;

  // * -------------------------------------------------------------------------

  Future<ProfileList?> doGetProfile(String articleId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = await prefs.getString("login_id");
    final data = await DioClient.getUserProfileData(articleId, user_id!);
    try {
      ProfileList profileData = ProfileList.fromMap(data);
      _profileState.value = profileData; // Assign the value to the _profileState
      return _profileState.value;
    } catch (e) {
      developer.log('doGetProfile222() error=$e');
    }
    
  }
}

final profileRepositoryProvider = StateProvider<UserProfileRepository>((ref) {
  return UserProfileRepository(authRepo: ref.watch(authRepositoryProvider));
});

final profileStateChangesProvider = StreamProvider<ProfileList?>((ref) {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return profileRepo.profileStateChanges();
});
