import '../../services/firestore_service.dart';
import '../models/post_model.dart';

class FirestorePostDataSource {
  FirestorePostDataSource(this.service);
  final FirestoreService service;

  Stream<List<PostModel>> watchPosts() {
    return service.posts.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => PostModel.fromJson(doc.data(), documentId: doc.id))
              .toList(),
        );
  }

  Future<void> createPost(PostModel post) async {
    await service.posts.add(post.toJson());
  }
}
