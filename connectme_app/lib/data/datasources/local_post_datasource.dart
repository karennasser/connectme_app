import '../models/post_model.dart';

class LocalPostDataSource {
  final List<PostModel> _posts = [];

  Stream<List<PostModel>> watchPosts() async* {
    yield List.unmodifiable(_posts);
  }

  Future<void> createPost(PostModel post) async {
    _posts.insert(0, post);
  }
}
