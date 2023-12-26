import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:datingapp/src/exceptions/app_exception.dart';
import 'package:datingapp/src/model/dio_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:datingapp/src/widgets/dialogs.dart';

import '../user_profile/profile.dart';

class AuthRepository {
  String? _uid; // AuthRepository will not use data model.
  String? get uid => _uid;

  set setUid(String str) {
    this._uid = str;
  }

  Future<bool> doLogIn(String email, String password) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = await DioClient.postLogin(email, password);
  
    var result = data['result'];
    var id = data['id'].toString();
    var user_email = data['user_email'].toString();
    var user_name = data['user_name'].toString();
    var user_photo = data['user_photo'].toString(); 
    if (result == 'success') {
      _uid = id;
      await prefs.setString("login_id", id);
      await prefs.setBool('isLogin', true);
      await prefs.setString("login_email", user_email);
      await prefs.setString("login_name", user_name);
      await prefs.setString("login_photo", user_photo);
      return true;
    } else if (result == 'empty_info') {
      Fluttertoast.showToast(
        msg: "入力した電子メール情報はありません。",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 40.sp,
      );
      return false;
    } else if (result == 'pass_wrong') {
      Fluttertoast.showToast(
        msg: "秘密のパスワードが正しくありません。",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 40.sp,
      );
      return false;
    }
    return false;
  }

  Future<bool> doEmailCompare(String email) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = await DioClient.doEmailCompare(email);
  
    var result = data['result'];
    if (result == 'success') {
      return true;
    } 
    return false;
  }

  Future<bool> doNameCompare(String name) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final data = await DioClient.doNameCompare(name);
  
    var result = data['result'];
    if (result == 'success') {
      return true;
    } 
    return false;
  }

  Future<bool> doUploadfile(String avaImg, String baseimage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = await prefs.getString("email");
    var password = await prefs.getString("password");
    var bar_id = await prefs.getString("bar_id");
    var birthday = await prefs.getString("birthday");
    var name = await prefs.getString("username");
    var location = await prefs.getString("location");
    var add_location = await prefs.getString("add_location");
    var gender = await prefs.getString("gender");
    final data = await DioClient.postUpload(avaImg, baseimage, email!, password!, bar_id!, birthday!, name!, location!, add_location!, gender!);
    var result = data['result'];
    var id = data['id'].toString();
    var user_email = data['user_email'].toString();
    var user_name = data['user_name'].toString();
    var user_photo = data['user_photo'].toString(); 
    if (result == 'Successfully') {
      await prefs.setString("login_id", id);
      await prefs.setBool('isLogin', true);
      await prefs.setString("login_email", user_email);
      await prefs.setString("login_name", user_name);
      await prefs.setString("login_photo", user_photo);
      showToastMessage("Successfully");
      return true;
    } else if (result == 'No Internet') {
      showToastMessage("No Internet");
      return false;
    }
    return false;
  }

  Future<bool> doAddData(String avaImg1, String avaImg2, String avaImg3, String avaImg4, String avaImg5, String avaImg6, String baseimage1, String baseimage2, String baseimage3, String baseimage4, String baseimage5, String baseimage6, String content) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uId = await prefs.getString("login_id");
    final data = await DioClient.postAddData(avaImg1, avaImg2, avaImg3, avaImg4, avaImg5, avaImg6, baseimage1, baseimage2, baseimage3, baseimage4, baseimage5, baseimage6, content, uId!);
    var result = data['result'];
    if (result == 'success') {
      showToastMessage("Successfully");
      return true;
    } else if (result == 'No Internet') {
      showToastMessage("No Internet");
      return false;
    }
    return false;
  }

  Future<bool> doSearchFollowData(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uId = await prefs.getString("login_id");
    final data = await DioClient.postSearchFollowData(userId, uId!);
    var result = data['result'];
    if (result == 'success') {
      showToastMessage("Successfully");
      return true;
    } else if (result == 'No Internet') {
      showToastMessage("No Internet");
      return false;
    }
    return false;
  }

  Future<bool> doArticleAllData(String articleId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uId = await prefs.getString("login_id");
    final data = await DioClient.postArticleAllData(articleId);
    var result = data['result'];
    if (result == 'success') {
      showToastMessage("Successfully");
      return true;
    } else if (result == 'error') {
      showToastMessage("error");
      return false;
    }
    return false;
  }

  Future<bool> doParentArticleData(String parentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uId = await prefs.getString("login_id");
    final data = await DioClient.postParentArticleData(parentId);
    var result = data['result'];
    if (result == 'success') {
      showToastMessage("Successfully");
      return true;
    } else if (result == 'error') {
      showToastMessage("error");
      return false;
    }
    return false;
  }

  Future<bool> doResArticleData(String articleId, String msg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uId = await prefs.getString("login_id");
    final data = await DioClient.postResArticleData(articleId, msg, uId!);
    var result = data['result'];
    if (result == 'success') {
      showToastMessage("Successfully");
      return true;
    } else if (result == 'error') {
      showToastMessage("error");
      return false;
    }
    return false;
  }

  Future<bool> doLogout() async {
    // clear profile and uid, later we may need to notify server...
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('login_id', 'not');
    prefs.setBool('isLogin', false);

    return true;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
