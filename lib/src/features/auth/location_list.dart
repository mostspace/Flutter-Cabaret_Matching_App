import 'package:intl/intl.dart';

import 'package:datingapp/src/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Inventory Model
// * ---------------------------------------------------------------------------

class Locations {
  const Locations({
    required this.id,
    required this.residence,
  });

  final String id;
  final String residence;

  factory Locations.fromMap(Map<String, dynamic> data) {
    return Locations(
      id: data['id'].toString(),
      residence: data['residence'].toString(),
    );
  }

  @override
  String toString() => 'LocationData(id: $id, residence: $residence)';
}

typedef LocationList = List<Locations>;
