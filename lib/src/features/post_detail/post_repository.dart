import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/features/post_detail/post_data.dart';
import 'package:datingapp/src/model/dio_client.dart';
import 'package:datingapp/src/features/auth/auth_repository.dart';
import 'package:datingapp/src/widgets/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostRepository{
  PostRepository({required this.authRepo});

  final AuthRepository authRepo;
  PostList _datas = []; //InMemoryStore<NotifList>([]);

  Future<PostList> doParentData(String article_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = await prefs.getString("login_id");
    dynamic data = await DioClient.doParentData(article_id);
    
    final result = data['result'];
    if (result is List) {
      _datas = result.map((data) => PostData.fromMap(data)).toList();

      return _datas;
    } else {
      return _datas;
    }
  }
}

final PostProvider = Provider<PostRepository>((ref) {
  return PostRepository(authRepo: ref.watch(authRepositoryProvider));
});
