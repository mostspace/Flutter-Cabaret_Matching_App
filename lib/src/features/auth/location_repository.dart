import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:datingapp/src/features/auth/location_list.dart';
import 'package:datingapp/src/model/dio_client.dart';
import 'package:datingapp/src/features/auth/auth_repository.dart';
import 'package:datingapp/src/widgets/dialogs.dart';

class LocationRepository {
  LocationRepository({required this.authRepo});

  final AuthRepository authRepo;
  LocationList _location = []; //InMemoryStore<NotifList>([]);

  Future<LocationList> doLocationData() async {
    dynamic data = await DioClient.doLocationData();

    final result = data['result'];

    if (result is List) {
      _location = result.map((data) => Locations.fromMap(data)).toList();
      return _location;
    } else {
      return _location;
    }
  }
}

final LocationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepository(authRepo: ref.watch(authRepositoryProvider));
});
