import 'package:intl/intl.dart';

import 'package:datingapp/src/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Inventory Model
// * ---------------------------------------------------------------------------

class Bars {
  const Bars({
    required this.id,
    required this.barName,
    required this.residence,
  });

  final String id;
  final String barName;
  final String residence;

  factory Bars.fromMap(Map<String, dynamic> data) {
    return Bars(
      id: data['id'].toString(),
      barName: data['bar_name'].toString(),
      residence: data['residence'].toString(),
    );
  }

  @override
  String toString() => 'BarsData(id: $id, barName: $barName, residence: $residence)';
}

typedef BarList = List<Bars>;
