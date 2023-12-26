import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/features/home/article_data.dart';
import 'package:datingapp/src/model/dio_client.dart';
import 'package:datingapp/src/features/auth/auth_repository.dart';
import 'package:datingapp/src/widgets/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepository {
  HomeRepository({required this.authRepo});

  final AuthRepository authRepo;
  ArticleList _datas = []; //InMemoryStore<NotifList>([]);

  Future<ArticleList> doFetchNotifs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = await prefs.getString("login_id");
    dynamic data = await DioClient.doFetchNotifs(user_id!);
    
    final result = data['result'];
    if (result is List) {
      _datas = result.map((data) => ArticleData.fromMap(data)).toList();

      return _datas;
    } else {
      return _datas;
    }
  }
}

final HomeProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(authRepo: ref.watch(authRepositoryProvider));
});
