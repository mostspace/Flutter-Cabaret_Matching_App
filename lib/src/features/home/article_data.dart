import 'package:intl/intl.dart';

import 'package:datingapp/src/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Inventory Model
// * ---------------------------------------------------------------------------

class ArticleData {
  const ArticleData({
    required this.article_id,
    required this.user_id,
    required this.content,
    required this.photo1,
    required this.photo2,
    required this.photo3,
    required this.photo4,
    required this.photo5,
    required this.photo6,
    required this.user_name,
    required this.user_photo,
    required this.add_location,
    required this.gender,
    required this.bar_id,
    required this.birthday,
    required this.residence,
    required this.following_count,
    required this.article_count,
  });

  final String article_id;
  final String user_id;
  final String content;
  final String photo1;
  final String photo2;
  final String photo3;
  final String photo4;
  final String photo5;
  final String photo6;
  final String user_name;
  final String user_photo;
  final String add_location;
  final String gender;
  final String birthday;
  final String bar_id;
  final String residence;
  final String following_count;
  final String article_count;

  factory ArticleData.fromMap(Map<String, dynamic> data) {
    return ArticleData(
      article_id: data['id'].toString() ?? "",
      user_id: data['user_id'].toString() ?? "",
      content: data['content'].toString() ?? "",
      photo1: data['photo1'].toString() ?? "",
      photo2: data['photo2'].toString() ?? "",
      photo3: data['photo3'].toString() ?? "",
      photo4: data['photo4'].toString() ?? "",
      photo5: data['photo5'].toString() ?? "",
      photo6: data['photo6'].toString() ?? "",
      user_name: data['user_name'].toString() ?? "",
      user_photo: data['user_photo'].toString() ?? "",
      add_location: data['add_location'].toString() ?? "",
      gender: data['gender'].toString() ?? "",
      birthday: data['birthday'].toString() ?? "",
      bar_id: data['bar_id'].toString() ?? "",
      residence: data['residence'].toString() ?? "",
      following_count: data['following_count'].toString() ?? "",
      article_count: data['article_count'].toString() ?? "",
    );
  }

  @override
  String toString() => 'ArticleData(article_id: $article_id, user_id: $user_id, content: $content, photo1: $photo1, photo2: $photo2, photo3: $photo3, photo4: $photo4, photo5: $photo5, photo6: $photo6, user_name: $user_name, user_photo: $user_photo, add_location: $add_location, gender: $gender, birthday: $birthday, residence: $residence, following_count: $following_count, article_count: $article_count)';
}

typedef ArticleList = List<ArticleData>;
