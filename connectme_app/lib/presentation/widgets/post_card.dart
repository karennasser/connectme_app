import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/post.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const CircleAvatar(child: Icon(Icons.person)),
              const SizedBox(width: 10),
              Expanded(child: Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold))),
              Text(DateFormat('MMM d, h:mm a').format(post.createdAt),
                  style: Theme.of(context).textTheme.bodySmall),
            ]),
            const SizedBox(height: 14),
            Text(post.content, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
