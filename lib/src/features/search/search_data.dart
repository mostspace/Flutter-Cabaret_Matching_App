import 'package:intl/intl.dart';

import 'package:datingapp/src/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Inventory Model
// * ---------------------------------------------------------------------------

class SearchData {
  const SearchData({
    required this.user_id,
    required this.user_name,
    required this.user_email,
    required this.user_photo,
    required this.add_location,
    required this.gender,
    required this.birthday,
    required this.age,
    required this.residence,
    required this.ischeckedFollow,
    required this.following_count,
  });

  final String user_id;
  final String user_name;
  final String user_email;
  final String user_photo;
  final String add_location;
  final String gender;
  final String birthday;
  final String age;
  final String residence;
  final String ischeckedFollow;
  final String following_count;

  factory SearchData.fromMap(Map<String, dynamic> data) {
    return SearchData(
      user_id: data['id'].toString() ?? "",
      user_name: data['user_name'].toString() ?? "",
      user_email: data['user_email'].toString() ?? "",
      user_photo: data['user_photo'].toString() ?? "",
      add_location: data['add_location'].toString() ?? "",
      gender: data['gender'].toString() ?? "",
      birthday: data['birthday'].toString() ?? "",
      age: data['age'].toString() ?? "",
      residence: data['residence'].toString() ?? "",
      ischeckedFollow: data['ischeck'].toString() ?? "",
      following_count: data['following_count'].toString() ?? "",
    );
  }

  @override
  String toString() => 'SearchData(user_id: $user_id, user_name: $user_name)';
}

typedef SearchList = List<SearchData>;
