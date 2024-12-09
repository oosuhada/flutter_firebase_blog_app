import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// 1. 상태 생성

class WritePageState {
  const WritePageState(
    this.isWriting,
    this.imageUrl,
  );
  final bool isWriting;
  final String? imageUrl;
}

// 2. 뷰모델 생성. Post null이면 생성, 아니면 수정!
class WriteViewModel extends AutoDisposeFamilyNotifier<WritePageState, Post?> {
  final postRepository = const PostRepository();

  @override
  WritePageState build(Post? arg) {
    return WritePageState(false, arg?.imgUrl);
  }

  // insert 성공 값 리턴
  Future<bool> insert({
    required String writer,
    required String title,
    required String content,
  }) async {
    print('WriteViewModel: insert 메서드 시작');

    if (state.imageUrl == null) {
      print('WriteViewModel: 이미지 URL이 없습니다.');
      return false;
    }

    state = WritePageState(true, state.imageUrl);

    try {
      print('WriteViewModel: ${arg == null ? "새 포스트 작성" : "포스트 수정"} 시작');
      final result = arg == null
          ? await postRepository.insert(
              writer: writer,
              title: title,
              content: content,
              imgUrl: state.imageUrl!,
            )
          : await postRepository.update(
              id: arg!.id,
              writer: writer,
              title: title,
              content: content,
              imgUrl: state.imageUrl!,
            );

      print('WriteViewModel: 작업 결과 - $result');
      return result;
    } catch (e) {
      print('WriteViewModel: 에러 발생 - $e');
      return false;
    } finally {
      state = WritePageState(false, state.imageUrl);
      print('WriteViewModel: insert 메서드 종료');
    }
  }

  Future<void> uploadImage(XFile xFile) async {
    try {
      // FirebaseStorage 객체 가지고오기
      FirebaseStorage storage = FirebaseStorage.instance;
      // 스토리지 참조 가지고 오기
      Reference storageRef = storage.ref();
      // 스토리지 참조의 child 메서드를 사용하면 파일 참조 만들어짐
      // 파라미터는 파일 이름!!
      // 중복되면 안되니까 현재시간이랑 기존 파일이름 섞을게요!
      final imageRef = storageRef
          .child('${DateTime.now().microsecondsSinceEpoch}_${xFile.name}');
      // 참조가 만들어졌으니 파일 업로드!!
      await imageRef.putFile(File(xFile.path));
      // 만들어진 파일의 url 가져오기
      final url = await imageRef.getDownloadURL();
      state = WritePageState(false, url);
    } catch (e) {
      print(e);
    }
  }
}

// 3. 뷰모델 관리자 만들기
final writeViewModel = NotifierProvider.autoDispose
    .family<WriteViewModel, WritePageState, Post?>(() {
  return WriteViewModel();
});
