import 'package:intl/intl.dart';

import 'package:datingapp/src/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Inventory Model
// * ---------------------------------------------------------------------------

class MailData {
  const MailData({
    required this.user_id,
    required this.user_name,
    required this.user_email,
    required this.user_photo,
    required this.add_location,
    required this.gender,
    required this.birthday,
    required this.residence,
    required this.msg,
    required this.last_time,
  });

  final String user_id;
  final String user_name;
  final String user_email;
  final String user_photo;
  final String add_location;
  final String gender;
  final String birthday;
  final String residence;
  final String msg;
  final String last_time;
  
  factory MailData.fromMap(Map<String, dynamic> data) {
    return MailData(
      user_id: data['id'].toString() ?? "",
      user_name: data['user_name'].toString() ?? "",
      user_email: data['user_email'].toString() ?? "",
      user_photo: data['user_photo'].toString() ?? "",
      add_location: data['add_location'].toString() ?? "",
      gender: data['gender'].toString() ?? "",
      birthday: data['birthday'].toString() ?? "",
      residence: data['residence'].toString() ?? "",
      msg: data['msg'].toString() ?? "",
      last_time: data['last_time'].toString() ?? "",
    );
  }

  @override
  String toString() => 'MailData(user_id: $user_id, user_name: $user_name)';
}

typedef MailList = List<MailData>;
