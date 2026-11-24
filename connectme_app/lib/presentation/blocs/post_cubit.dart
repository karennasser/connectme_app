import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/create_post.dart';
import '../../domain/usecases/get_posts.dart';

enum PostStatus { initial, loading, loaded, failure }

class PostState {
  const PostState({
    this.status = PostStatus.initial,
    this.posts = const [],
    this.message,
  });
  final PostStatus status;
  final List<Post> posts;
  final String? message;
}

class PostCubit extends Cubit<PostState> {
  PostCubit(this.getPosts, this.createPost) : super(const PostState());
  final GetPosts getPosts;
  final CreatePost createPost;
  StreamSubscription<List<Post>>? _subscription;

  void loadPosts() {
    emit(const PostState(status: PostStatus.loading));
    _subscription?.cancel();
    _subscription = getPosts().listen(
      (posts) => emit(PostState(status: PostStatus.loaded, posts: posts)),
      onError: (error) => emit(PostState(
        status: PostStatus.failure,
        message: 'Could not load posts. Check your connection and try again.',
      )),
    );
  }

  Future<void> addPost({
    required String authorId,
    required String authorName,
    required String content,
  }) async {
    try {
      await createPost(Post(
        id: '',
        authorId: authorId,
        authorName: authorName,
        content: content.trim(),
        createdAt: DateTime.now(),
      ));
    } catch (_) {
      emit(PostState(
        status: PostStatus.failure,
        posts: state.posts,
        message: 'Your post could not be published. Please try again.',
      ));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
