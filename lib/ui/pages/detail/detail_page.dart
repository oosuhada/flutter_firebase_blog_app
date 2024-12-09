import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/ui/pages/detail/detail_view_model.dart';
import 'package:flutter_firebase_blog_app/ui/pages/write/write_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailPage extends StatelessWidget {
  DetailPage(this.post);
  Post post;

  @override
  Widget build(BuildContext context) {
    // Consumer로 감싸주기!

    return Consumer(builder: (context, ref, child) {
      // 상태 변화를 감지하기 위해!
      final state = ref.watch(detailViewModel(post));
      // 삭제된 포스트면 로딩창 나오게!!
      if (state == null) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          actions: [
            button(Icons.delete, () async {
              final result =
                  await ref.read(detailViewModel(post).notifier).delete();
              if (result) {
                Navigator.pop(context);
              }
            }),
            button(Icons.edit, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return WritePage(post: post);
                },
              ));
            }),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.only(bottom: 300),
          children: [
            Image.network(
              state.imgUrl,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // 이미지에는 패딩이 적용되지 않기 때문에 아래 영역만 Padding 위젯
            // 감싸서 패딩 지정!
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    state.writer,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${state.createdAt.year}.${state.createdAt.month}.${state.createdAt.day} ${state.createdAt.hour}:${state.createdAt.minute}',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    state.content,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  GestureDetector button(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Icon 크기가 기본 24 이기 때문에 컨테이너 색상을 지정해주지 않으면
        // 터치 반경 24x24 됨
        color: Colors.transparent,
        width: 50,
        height: 50, // 중요!!! 사람이 터치할때 터치 잘되게 하는 최소 반경이 44 디바이스 픽셀!
        child: Icon(icon),
      ),
    );
  }
}
