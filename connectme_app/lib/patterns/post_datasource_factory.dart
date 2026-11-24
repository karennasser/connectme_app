import '../data/datasources/firestore_post_datasource.dart';
import '../data/datasources/local_post_datasource.dart';

abstract interface class PostDataSource {
  Stream watchPosts();
  Future<void> createPost(dynamic post);
}

/// Factory Pattern: returns a local or remote implementation by configuration.
class PostDataSourceFactory {
  static dynamic create({
    required bool useLocal,
    required FirestorePostDataSource remote,
    required LocalPostDataSource local,
  }) {
    return useLocal ? local : remote;
  }
}
