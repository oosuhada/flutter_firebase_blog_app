import 'dart:async';

import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {
  const HomeState({required this.posts, required this.isSample});

  final List<Post> posts;
  final bool isSample;
}

class HomeViewModel extends Notifier<HomeState> {
  final postRepository = const PostRepository();

  static final List<Post> samplePosts = [
    Post(
      id: 'sample-1',
      writer: 'oosuhada',
      title: 'Flutter와 Firebase로 글 목록 만들기',
      content: 'Firestore stream을 Riverpod 상태와 연결해 최근 글 목록을 갱신하는 학습 기록입니다.',
      createdAt: DateTime(2026, 8, 20, 18, 20),
      imgUrl: '',
    ),
    Post(
      id: 'sample-2',
      writer: 'oosuhada',
      title: '이미지 업로드와 글쓰기 흐름',
      content: 'Firebase Storage 업로드 이후 post document를 작성하는 흐름을 구현했습니다.',
      createdAt: DateTime(2026, 8, 19, 21, 10),
      imgUrl: '',
    ),
    Post(
      id: 'sample-3',
      writer: 'oosuhada',
      title: 'Riverpod으로 상세 화면 상태 관리',
      content: '목록에서 상세 화면으로 이동하고 수정·삭제 상태를 구독하는 예제입니다.',
      createdAt: DateTime(2026, 8, 18, 15, 40),
      imgUrl: '',
    ),
  ];

  @override
  HomeState build() {
    _listenStream();
    return HomeState(posts: samplePosts, isSample: true);
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
          state = HomeState(posts: samplePosts, isSample: true);
        },
      );
    } catch (_) {
      state = HomeState(posts: samplePosts, isSample: true);
    }

    ref.onDispose(() {
      subscription?.cancel();
    });
  }
}

final homeViewModel =
    NotifierProvider<HomeViewModel, HomeState>(() => HomeViewModel());
