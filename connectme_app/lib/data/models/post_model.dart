import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    required super.content,
    required super.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json, {String? documentId}) {
    final rawDate = json['createdAt'];
    final date = rawDate is Timestamp
        ? rawDate.toDate()
        : DateTime.tryParse(rawDate?.toString() ?? '') ?? DateTime.now();
    return PostModel(
      id: documentId ?? (json['id'] as String? ?? ''),
      authorId: json['authorId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Community member',
      content: json['content'] as String? ?? '',
      createdAt: date,
    );
  }

  Map<String, dynamic> toJson() => {
        'authorId': authorId,
        'authorName': authorName,
        'content': content,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
