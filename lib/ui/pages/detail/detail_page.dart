import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/ui/pages/detail/detail_view_model.dart';
import 'package:flutter_firebase_blog_app/ui/pages/write/write_page.dart';
import 'package:flutter_firebase_blog_app/ui/widgets/post_cover.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailPage extends ConsumerWidget {
  const DetailPage(
    this.post, {
    super.key,
    this.previewMode = false,
  });

  final Post post;
  final bool previewMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final livePost = previewMode ? post : ref.watch(detailViewModel(post));

    if (livePost == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Journal entry',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit post',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WritePage(
                    post: livePost,
                    previewMode: previewMode,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          if (!previewMode)
            IconButton(
              tooltip: 'Delete post',
              onPressed: () => _confirmDelete(context, ref),
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 56),
        children: [
          AspectRatio(
            aspectRatio: 1.42,
            child: PostCover(post: livePost),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _CategoryPill(label: livePost.category),
                    if (previewMode) ...[
                      const SizedBox(width: 8),
                      const _PreviewPill(),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  livePost.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1.08,
                        letterSpacing: -1,
                      ),
                ),
                const SizedBox(height: 20),
                _PostMetadata(post: livePost),
                const SizedBox(height: 24),
                Divider(color: Colors.black.withValues(alpha: .08)),
                const SizedBox(height: 22),
                Text(
                  livePost.content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 17,
                        height: 1.72,
                        color: const Color(0xFF2E3035),
                      ),
                ),
                const SizedBox(height: 34),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .035),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    previewMode
                        ? 'Portfolio preview · live posts use the same detail layout with Firestore updates.'
                        : 'Live Firebase post · edits and deletes sync through the repository.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.4,
                          color: Colors.black54,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete this post?'),
            content: const Text('This removes the post from Firestore.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldDelete) return;

    final result = await ref.read(detailViewModel(post).notifier).delete();
    if (result && context.mounted) {
      Navigator.pop(context);
    }
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _PreviewPill extends StatelessWidget {
  const _PreviewPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'PREVIEW',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
            ),
      ),
    );
  }
}

class _PostMetadata extends StatelessWidget {
  const _PostMetadata({required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.black.withValues(alpha: .06),
          child: const Icon(Icons.person_outline_rounded, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.writer,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(
                _date(post.createdAt),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.black45),
              ),
            ],
          ),
        ),
        const Icon(Icons.schedule_rounded, size: 15, color: Colors.black38),
        const SizedBox(width: 5),
        Text(
          '${_readMinutes(post.content)} min read',
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Colors.black45),
        ),
      ],
    );
  }

  String _date(DateTime time) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[time.month - 1]} ${time.day}, ${time.year}';
  }

  int _readMinutes(String content) {
    final words = content.trim().split(RegExp(r'\s+')).length;
    final minutes = (words / 180).ceil();
    return minutes < 1 ? 1 : minutes;
  }
}
