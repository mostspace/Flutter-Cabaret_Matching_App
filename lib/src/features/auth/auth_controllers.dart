import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/features/auth/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
// * ---------------------------------------------------------------------------
// * LoginController
// * ---------------------------------------------------------------------------

class LoginController extends StateNotifier<AsyncValue<bool>> {
  LoginController({required this.authRepo}) : super(const AsyncData(false));

  final AuthRepository authRepo;
  late BuildContext context;

  //bool isAuthenticated() => authRepo.uid

  Future<bool> doLogin(String email, String password) async {
    state = const AsyncValue.loading();

    final newState =
        await AsyncValue.guard(() => authRepo.doLogIn(email, password));
    
    if (mounted) {
      state = newState;
    }
    return newState.value!;
  }

  Future<bool> doEmailCompare(String email) async {
    state = const AsyncValue.loading();

    final newState =
        await AsyncValue.guard(() => authRepo.doEmailCompare(email));
    
    if (mounted) {
      state = newState;
    }
    return newState.value!;
  }

  Future<bool> doNameCompare(String name) async {
    state = const AsyncValue.loading();

    final newState =
        await AsyncValue.guard(() => authRepo.doNameCompare(name));
    
    if (mounted) {
      state = newState;
    }
    return newState.value!;
  }

  Future<bool> doUploadfile(String avaImg, String baseimage) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => authRepo.doUploadfile(avaImg, baseimage));

    if (mounted) {
      state = newState;
    }
    return newState.value!;
  }

  Future<bool> doAddData(String avaImg1, String avaImg2, String avaImg3, String avaImg4, String avaImg5, String avaImg6, String baseimage1, String baseimage2, String baseimage3, String baseimage4, String baseimage5, String baseimage6, String content) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => authRepo.doAddData(avaImg1, avaImg2, avaImg3, avaImg4, avaImg5, avaImg5, baseimage1, baseimage2, baseimage3, baseimage4, baseimage5, baseimage6, content));

    if (mounted) {
      state = newState;
    }
    return newState.value!;
  }

  Future<bool> doSearchFollowData(String userId) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => authRepo.doSearchFollowData(userId));

    if (mounted) {
      state = newState;
    }
    return newState.value!;
  }

  Future<bool> doArticleAllData(String articleId) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => authRepo.doArticleAllData(articleId));

    if (mounted) {
      state = newState;
    }
    return newState.value!;
  }

  Future<bool> doParentArticleData(String parentId) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => authRepo.doParentArticleData(parentId));

    if (mounted) {
      state = newState;
    }
    return newState.value!;
  }

  Future<bool> doResArticleData(String articleId, String msg) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => authRepo.doResArticleData(articleId, msg));

    if (mounted) {
      state = newState;
    }
    return newState.value!;
  }

  Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin') ?? false;
  }

  Future<String> getLoggedInID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = prefs.getString('login_id') ?? 'not';
    authRepo.setUid = str;
    return str;
  }

  Future<void> doLogout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepo.doLogout());
  }
}

final loginControllerProvider =
    StateNotifierProvider.autoDispose<LoginController, AsyncValue<bool>>((ref) {
  return LoginController(authRepo: ref.watch(authRepositoryProvider));
});
