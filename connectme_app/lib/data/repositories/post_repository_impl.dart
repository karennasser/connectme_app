import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../models/post_model.dart';

/// Repository implementation delegates storage details to the selected data source.
class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this.dataSource);
  final dynamic dataSource;

  @override
  Stream<List<Post>> watchPosts() => dataSource.watchPosts();

  @override
  Future<void> createPost(Post post) {
    return dataSource.createPost(PostModel(
      id: post.id,
      authorId: post.authorId,
      authorName: post.authorName,
      content: post.content,
      createdAt: post.createdAt,
    ));
  }
}
