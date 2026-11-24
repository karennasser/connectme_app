import '../entities/post.dart';
import '../repositories/post_repository.dart';

class CreatePost {
  CreatePost(this.repository);
  final PostRepository repository;

  Future<void> call(Post post) => repository.createPost(post);
}
