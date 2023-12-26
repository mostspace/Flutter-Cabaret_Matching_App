import 'package:intl/intl.dart';

import 'package:datingapp/src/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Inventory Model
// * ---------------------------------------------------------------------------

class PostData {
  const PostData({
    required this.article_id,
    required this.user_id,
    required this.res_content,
    required this.created_at,
    required this.user_name,
    required this.user_photo,
    required this.parent_id,
  });

  final String article_id;
  final String user_id;
  final String res_content;
  final String created_at;
  final String user_name;
  final String user_photo;
  final String parent_id;

  factory PostData.fromMap(Map<String, dynamic> data) {
    return PostData(
      parent_id: data['id'].toString() ?? "",
      article_id: data['article_id'].toString() ?? "",
      user_id: data['res_user_id'].toString() ?? "",
      res_content: data['res_content'].toString() ?? "",
      created_at: data['created_at'].toString() ?? "",
      user_name: data['user_name'].toString() ?? "",
      user_photo: data['user_photo'].toString() ?? "",
    );
  }

  @override
  String toString() => 'PostData(article_id: $article_id, user_id: $user_id, res_content: $res_content, created_at: $created_at, photo2: $user_name, photo3: $user_name, user_photo: $user_photo)';
}

typedef PostList = List<PostData>;
