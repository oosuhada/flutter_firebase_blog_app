import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/ui/pages/detail/detail_page.dart';
import 'package:flutter_firebase_blog_app/ui/pages/home/home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer(builder: (context, ref, child) {
        final state = ref.watch(homeViewModel);
        return ListView.separated(
          itemCount: state.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            return item(state[index]);
          },
        );
      }),
    );
  }

  Widget item(Post post) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return DetailPage(post);
            },
          ));
        },
        child: SizedBox(
          height: 120,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                width: 120,
                height: 120,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      post.imgUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(right: 100),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                // 5. padding 설정
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  // 6. 정렬 조정
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 4. Container 자녀요소 배치
                    Text(
                      post.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    Text(
                      post.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${post.createdAt.year}.${post.createdAt.month}.${post.createdAt.day} ${post.createdAt.hour}:${post.createdAt.minute}',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
