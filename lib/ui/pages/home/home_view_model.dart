import 'dart:async';

import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/data/repository/post_repository.dart';
import 'package:flutter_firebase_blog_app/data/sample/sample_posts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {
  const HomeState({required this.posts, required this.isSample});

  final List<Post> posts;
  final bool isSample;
}

class HomeViewModel extends Notifier<HomeState> {
  final postRepository = const PostRepository();

  @override
  HomeState build() {
    _listenStream();
    return HomeState(posts: portfolioSamplePosts, isSample: true);
  }

  void _listenStream() {
    StreamSubscription<List<Post>>? subscription;

    try {
      subscription = postRepository.postListStream().listen(
        (posts) {
          if (posts.isNotEmpty) {
            state = HomeState(posts: posts, isSample: false);
          }
        },
        onError: (_) {
          state = HomeState(posts: portfolioSamplePosts, isSample: true);
        },
      );
    } catch (_) {
      state = HomeState(posts: portfolioSamplePosts, isSample: true);
    }

    ref.onDispose(() {
      subscription?.cancel();
    });
  }
}

final homeViewModel =
    NotifierProvider<HomeViewModel, HomeState>(() => HomeViewModel());
