import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/post_cubit.dart';
import '../widgets/post_card.dart';
import '../../services/biometric_service.dart';
import '../../injection.dart';
import 'profile_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<PostCubit>().loadPosts());
  }

  Future<void> _openProfile(AppUser? user) async {
    final allowed = await getIt<BiometricService>().authenticate();
    if (!mounted) return;
    if (!allowed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric authentication was not successful.')),
      );
      return;
    }
    if (user != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(user: user)));
    }
  }

  void _showCreatePost(AppUser? user) {
    if (user == null) return;
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create a post'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'What would you like to share?'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final content = controller.text.trim();
              if (content.isNotEmpty) {
                context.read<PostCubit>().addPost(
                  authorId: user.id, authorName: user.fullName, content: content,
                );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthCubit, AppUser?>((cubit) => cubit.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConnectMe'),
        actions: [
          IconButton(tooltip: 'Community map', onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const MapScreen())),
            icon: const Icon(Icons.map_outlined)),
          IconButton(tooltip: 'Profile', onPressed: () => _openProfile(user),
            icon: const Icon(Icons.account_circle_outlined)),
          IconButton(tooltip: 'Log out', onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout)),
        ],
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state.status == PostStatus.loading || state.status == PostStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == PostStatus.failure && state.posts.isEmpty) {
            return Center(child: Text(state.message ?? 'Something went wrong'));
          }
          if (state.posts.isEmpty) {
            return const Center(child: Text('No posts yet. Be the first to share!'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.posts.length,
            itemBuilder: (context, index) => PostCard(post: state.posts[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePost(user),
        icon: const Icon(Icons.add),
        label: const Text('Create post'),
      ),
    );
  }
}
