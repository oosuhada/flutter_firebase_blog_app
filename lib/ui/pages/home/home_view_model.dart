import 'dart:async';

import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 상태 클래스 => List<Post> 로 사용
// 2. ViewModel 구현
class HomeViewModel extends Notifier<List<Post>> {
  HomeViewModel();

  @override
  List<Post> build() {
    fetchData();
    return [];
  }

  final postRepository = const PostRepository();

  Future<void> fetchData() async {
    // state = await postRepository.getAll();
    // 1. 스트림을 받아옵니다
    final stream = postRepository.postListStream();
    // 2. 스트림의 변경사항을 구독하고 상태를 업데이트 해줍니다!
    final streamSubscription = stream.listen(
      (newList) {
        state = newList;
      },
    );

    // 2. 이 뷰모델이 없어질 때 구독을 끝내주어야 메모리에서 안전하게 제거가 돼요!
    ref.onDispose(
      () {
        streamSubscription.cancel();
      },
    );
  }
}

// 2. ViewModel 관리자 구현
final homeViewModel =
    NotifierProvider<HomeViewModel, List<Post>>(() => HomeViewModel());
