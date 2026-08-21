import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/ui/pages/home/widgets/home_list_view.dart';
import 'package:flutter_firebase_blog_app/ui/pages/home/home_view_model.dart';
import 'package:flutter_firebase_blog_app/ui/pages/write/write_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_firebase_blog_app/v2/v2_glass.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModel);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        title: const _BrandMark(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
                child: AppGlassAction(
                    onTap: () {},
                    child: _DataModeBadge(isSample: state.isSample))),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 112),
          children: [
            _HeroIntro(
              isSample: state.isSample,
              onWrite: () => _openWrite(context, state.isSample),
            ),
            const SizedBox(height: 30),
            const HomeListView(),
          ],
        ),
      ),
    );
  }

  void _openWrite(BuildContext context, bool previewMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WritePage(post: null, previewMode: previewMode),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Text(
            'D/',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'DEV JOURNAL',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1.1),
        ),
      ],
    );
  }
}

class _DataModeBadge extends StatelessWidget {
  const _DataModeBadge({required this.isSample});

  final bool isSample;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .045),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSample ? Colors.orange.shade700 : Colors.green.shade600,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isSample ? 'Preview' : 'Live',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _HeroIntro extends StatelessWidget {
  const _HeroIntro({required this.isSample, required this.onWrite});

  final bool isSample;
  final VoidCallback onWrite;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111318),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MOBILE DEVELOPER NOTES',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white60,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Build. Break.\nWrite it down.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              height: 1.02,
              letterSpacing: -1.4,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Small field notes on Flutter UI, Firebase architecture, and the decisions behind shipping mobile work.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  height: 1.45,
                ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _DarkTag(label: 'Flutter'),
              _DarkTag(label: 'Firebase'),
              _DarkTag(label: 'Riverpod'),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: AppGlassAction(
                  onTap: onWrite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_rounded, size: 19, color: scheme.primary),
                      const SizedBox(width: 8),
                      const Text('Start a note',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
              if (isSample) ...[
                const SizedBox(width: 12),
                Text(
                  'local preview',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.white54),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DarkTag extends StatelessWidget {
  const _DarkTag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Text(label,
          style: const TextStyle(color: Colors.white70, fontSize: 12)),
    );
  }
}
