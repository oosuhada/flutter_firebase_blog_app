import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/ui/pages/detail/detail_page.dart';
import 'package:flutter_firebase_blog_app/ui/pages/home/home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeListView extends ConsumerWidget {
  const HomeListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModel);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              children: [
                Text(
                  '최근 글',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const Spacer(),
                if (state.isSample)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Preview data',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 104),
              itemCount: state.posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => _PostCard(
                post: state.posts[index],
                isSample: state.isSample,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.isSample});

  final Post post;
  final bool isSample;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: isSample
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailPage(post)),
                );
              },
        child: SizedBox(
          height: 156,
          child: Row(
            children: [
              SizedBox(
                width: 136,
                height: double.infinity,
                child: _PostImage(post: post),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${post.writer} · ${_date(post.createdAt)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _date(DateTime time) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${time.year}.${two(time.month)}.${two(time.day)}';
  }
}

class _PostImage extends StatelessWidget {
  const _PostImage({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    if (post.imgUrl.trim().isNotEmpty) {
      return Image.network(
        post.imgUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
      );
    }

    return const _ImagePlaceholder();
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Center(
        child: Icon(
          Icons.article_outlined,
          size: 42,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
