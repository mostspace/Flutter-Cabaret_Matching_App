import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/features/auth/bar_list.dart';
import 'package:datingapp/src/model/dio_client.dart';
import 'package:datingapp/src/features/auth/auth_repository.dart';
import 'package:datingapp/src/widgets/dialogs.dart';

class BarRepository {
  BarRepository({required this.authRepo});

  final AuthRepository authRepo;
  BarList _bars = []; //InMemoryStore<NotifList>([]);

  Future<BarList> doBarData() async {
    dynamic data = await DioClient.doBarData();

    final result = data['result'];

    if (result is List) {
      _bars = result.map((data) => Bars.fromMap(data)).toList();
      return _bars;
    } else {
      return _bars;
    }
  }
}

final BarRepositoryProvider = Provider<BarRepository>((ref) {
  return BarRepository(authRepo: ref.watch(authRepositoryProvider));
});
