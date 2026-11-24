import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPosts {
  GetPosts(this.repository);
  final PostRepository repository;

  Stream<List<Post>> call() => repository.watchPosts();
}
