import 'dart:developer' as developer;

class ProfileList {
  ProfileList({
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
    required this.user_email,
    required this.user_photo,
    required this.add_location,
    required this.gender,
    required this.birthday,
    required this.residence,
    required this.following_count,
    required this.article_count,
    required this.age,
    required this.ischeckFollow,
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
  final String residence;
  final String following_count;
  final String article_count;
  final String age;
  final String ischeckFollow;
  final String user_email;

  factory ProfileList.fromMap(Map<String, dynamic> data) {
    final result = data['result'];
    final ischeck = data['follow'];
    return ProfileList(
      article_id: result['id'].toString() ?? "",
      user_id: result['user_id'].toString() ?? "",
      content: result['content'].toString() ?? "",
      photo1: "http://43.207.77.181/uploads/post_image/" + result['photo1'].toString() ?? "",
      photo2: "http://43.207.77.181/uploads/post_image/" + result['photo2'].toString() ?? "",
      photo3: "http://43.207.77.181/uploads/post_image/" + result['photo3'].toString() ?? "",
      photo4: "http://43.207.77.181/uploads/post_image/" + result['photo4'].toString() ?? "",
      photo5: "http://43.207.77.181/uploads/post_image/" + result['photo5'].toString() ?? "",
      photo6: "http://43.207.77.181/uploads/post_image/" + result['photo6'].toString() ?? "",
      user_name: result['user_name'].toString() ?? "",
      user_email: result['user_email'].toString() ?? "",
      user_photo: result['user_photo'].toString() ?? "",
      add_location: result['add_location'].toString() ?? "",
      gender: result['gender'].toString() ?? "",
      birthday: result['birthday'].toString() ?? "",
      residence: result['residence'].toString() ?? "",
      following_count: result['following_count'].toString() ?? "",
      article_count: result['article_count'].toString() ?? "",
      age: result['age'].toString() ?? "",
      ischeckFollow: ischeck.toString() ?? "",
    );
  }

  @override
  String toString() => 'ArticleData(article_id: $article_id, user_id: $user_id, content: $content, photo1: $photo1, photo2: $photo2, photo3: $photo3, photo4: $photo4, photo5: $photo5, photo6: $photo6, user_name: $user_name, user_photo: $user_photo, add_location: $add_location, gender: $gender, birthday: $birthday, residence: $residence, following_count: $following_count, age: $age, ischeckFollow:$ischeckFollow)';

}
