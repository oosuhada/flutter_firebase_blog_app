import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';

class PostCover extends StatelessWidget {
  const PostCover({
    super.key,
    required this.post,
    this.compact = false,
    this.imageUrlOverride,
  });

  final Post post;
  final bool compact;
  final String? imageUrlOverride;

  @override
  Widget build(BuildContext context) {
    final imageUrl = imageUrlOverride ?? post.imgUrl;
    if (imageUrl.trim().isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _LocalCover(post: post, compact: compact),
      );
    }

    return _LocalCover(post: post, compact: compact);
  }
}

class _LocalCover extends StatelessWidget {
  const _LocalCover({required this.post, required this.compact});

  final Post post;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final variant = _coverVariant(post);
    final scheme = Theme.of(context).colorScheme;
    final icon = switch (variant) {
      0 => Icons.layers_rounded,
      1 => Icons.auto_awesome_mosaic_rounded,
      _ => Icons.terminal_rounded,
    };
    final coverColors = switch (variant) {
      0 => const [Color(0xFFD9DFFF), Color(0xFFF0EEFF)],
      1 => const [Color(0xFFCFEFE3), Color(0xFFEAF8F1)],
      _ => const [Color(0xFFFFDCC8), Color(0xFFFFF0E5)],
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: coverColors,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                right: compact ? -24 : -32,
                top: compact ? -18 : -42,
                child: Container(
                  width: compact ? 92 : 170,
                  height: compact ? 92 : 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.surface.withValues(alpha: .38),
                  ),
                ),
              ),
              Positioned(
                left: compact ? -34 : -54,
                bottom: compact ? -44 : -76,
                child: Transform.rotate(
                  angle: .25,
                  child: Container(
                    width: compact ? 96 : 190,
                    height: compact ? 96 : 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(compact ? 26 : 52),
                      border: Border.all(
                        color: scheme.onPrimaryContainer.withValues(alpha: .12),
                        width: compact ? 10 : 18,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(compact ? 14 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(compact ? 7 : 10),
                      decoration: BoxDecoration(
                        color: scheme.surface.withValues(alpha: .72),
                        borderRadius: BorderRadius.circular(compact ? 10 : 14),
                      ),
                      child: Icon(
                        icon,
                        size: compact ? 18 : 28,
                        color: scheme.onSurface,
                      ),
                    ),
                    if (!compact)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.category.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'DEV JOURNAL',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -.7,
                                ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _coverVariant(Post value) {
    if (value.id.endsWith('1')) return 0;
    if (value.id.endsWith('2')) return 1;
    if (value.id.endsWith('3')) return 2;
    return value.title.codeUnits.fold<int>(0, (sum, unit) => sum + unit) % 3;
  }
}
