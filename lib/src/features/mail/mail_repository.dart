import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/features/mail/mail_data.dart';
import 'package:datingapp/src/model/dio_client.dart';
import 'package:datingapp/src/features/auth/auth_repository.dart';
import 'package:datingapp/src/widgets/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MailRepository {
  MailRepository({required this.authRepo});

  final AuthRepository authRepo;
  MailList _datas = []; //InMemoryStore<NotifList>([]);

  Future<MailList> doFetchNotifs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = await prefs.getString("login_id");
    dynamic data = await DioClient.getMailData(user_id!);
    
    final result = data['result'];
    if (result is List) {
      _datas = result.map((data) => MailData.fromMap(data)).toList();
      return _datas;
    } else {
      return _datas;
    }
  }
}

final MailProvider = Provider<MailRepository>((ref) {
  return MailRepository(authRepo: ref.watch(authRepositoryProvider));
});
