import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/features/search/search_data.dart';
import 'package:datingapp/src/model/dio_client.dart';
import 'package:datingapp/src/features/auth/auth_repository.dart';
import 'package:datingapp/src/widgets/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchRepository {
  SearchRepository({required this.authRepo});

  final AuthRepository authRepo;
  SearchList _datas = []; //InMemoryStore<NotifList>([]);

  Future<SearchList> doFetchNotifs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = await prefs.getString("login_id");
    dynamic data = await DioClient.getSearchData(user_id!);
    
    final result = data['result'];
    if (result is List) {
      _datas = result.map((data) => SearchData.fromMap(data)).toList();

      return _datas;
    } else {
      return _datas;
    }
  }
}

final SearchProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(authRepo: ref.watch(authRepositoryProvider));
});
