// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'package:datingapp/src/model/dio_exception.dart';

class DioClient {
  static final _baseOptions = BaseOptions(
    // baseUrl: 'http://mobileapp.swaconnect.net/api',
    baseUrl: 'http://43.207.77.181/api',
    //connectTimeout: 10000, receiveTimeout: 10000,
    headers: {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie':
          'XSRF-TOKEN=eyJpdiI6Inc1YW0wQ29WVlJaUUF3V2RkUXRVaVE9PSIsInZhbHVlIjoibDkrMmRmSFFNQkxZbENybFFscXo1d3hHUXAySFVBWE1XbEthRFoybStRT0ZETk9BcXlLRXkrQmZYSnRzODZ6aHRjamtNZ1RyK2VKbmFlS3BNTGtSS1g1NnhjNjJ0RHVReUVjTFpBMzhlaytCc3hVWDBJZWxNOTVUYURrakRud3YiLCJtYWMiOiIzYzNmOTU1NDA0ODkxZTU3NWQzMDQyMmMzZThmMDU2OWQ3ODkzYTY2ZGI1ZWViNmU0M2VmMmMwZDBhYjg1YzlmIn0%3D; laravel_session=eyJpdiI6IndwREYyUnNob3B2aUtiam5JdEE0ckE9PSIsInZhbHVlIjoiL1FUejBJbUEwcG9lWnl5NmtXVlQzQ1VRVzZZWEhZZDIwbnpnNFBuSTBuclpESjBKTkhPaFdhdlFTQWFuNUh4MWErOGdSTVdkVkZyYnEvOEJ1RVhTWUEvRlA0TlRPZC9jL0NVZlRRWkRCaUZXUHlEYWNqVTIzV2hwZnBPZzhVVjEiLCJtYWMiOiIzZDczOWM1Y2ViZDE0OTE2N2M5ODYyNDdkMmRlYzMyOGUwNjU2MmY0NTcxZGU2NGI4MTM1ZTEwZWE2MGY5ZWVmIn0%3D',
    },
  );

  // * keep token for future usage.
  static String _token = '';

  // * GET: '/token'
  static Future<String> _getToken() async {
    final random = Random.secure();
    var values = List<int>.generate(8, (i) => random.nextInt(256));
    _token = base64Url.encode(values);
    return _token;
  }

  String createToken() {
    final random = Random.secure();
    var values = List<int>.generate(8, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  // * POST: '/login'
  static Future<dynamic> postLogin(String email, String password) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    print(email + password);
    try {
      final response = await dio.post('/login_action',
          data: {'email': email, 'password': password});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * POST: '/email compare'
  static Future<dynamic> doEmailCompare(String email) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio.post('/compare_email',
          data: {'email': email});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> doNameCompare(String name) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio.post('/compare_name',
          data: {'name': name});
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * Get: '/Get Bar list data'
  static Future<dynamic> doBarData() async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_bars_list',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * Get: '/Get residence list data'
  static Future<dynamic> doLocationData() async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_location_data',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> postUpload(String avaImg, String baseimage, String email, String password, String bar_id, String birthday, String name, String location, String add_location, String gender) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio.post('/upload_image', data: {
        'image_name': avaImg,
        'image': baseimage,
        'email' : email,
        'password': password,
        'bar_id' : bar_id,
        'birthday': birthday,
        'user_name' : name,
        'location' : location,
        'add_location' : add_location,
        'gender' : gender,
      });
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> postAddData(String avaImg1, String avaImg2, String avaImg3, String avaImg4, String avaImg5, String avaImg6, String baseimage1, String baseimage2, String baseimage3, String baseimage4, String baseimage5, String baseimage6, String content, String uId) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio.post('/add_data', data: {
        'user_id': uId,
        'image_name1': avaImg1,
        'image_name2': avaImg2,
        'image_name3': avaImg3,
        'image_name4': avaImg4,
        'image_name5': avaImg5,
        'image_name6': avaImg6,
        'image1': baseimage1,
        'image2': baseimage2,
        'image3': baseimage3,
        'image4': baseimage4,
        'image5': baseimage5,
        'image6': baseimage6,
        'content' : content
      });
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  // * Get: '/Get HomeData list data'
  static Future<dynamic> doFetchNotifs(String user_id) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_home_data/$user_id',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> getUserProfileData(String articleId, String userId) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_user_profile_data/$articleId/$userId',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> getSearchData(String userId) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_search_data/$userId',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> postSearchFollowData(String userId, String followId) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    print(userId);
    try {
      final response = await dio.post('/add_search_follow', data: {
        'user_id': userId,
        'follow_id': followId,
      });
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> getMailData(String userId) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_mail_data/$userId',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> doParentData(String articleId) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    try {
      final response = await dio.get('/get_post_detail/$articleId',
          options: Options(headers: {'X-CSRF-TOKEN': token}));
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> postArticleAllData(String articleId) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio.post('/remove_all_article_data', data: {
        'articleId': articleId,
      });
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> postParentArticleData(String parentId) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio.post('/remove_parent_article_data', data: {
        'parentId': parentId,
      });
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<dynamic> postResArticleData(String articleId, String msg, String uId) async {
    final token = await _getToken();
    var dio = Dio(_baseOptions);
    dio.options.headers['X-CSRF-TOKEN'] = token;
    try {
      final response = await dio.post('/add_res_article_data', data: {
        'articleId': articleId,
        'msg': msg,
        'uId': uId,
      });
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}
