import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';

class PostRepository {
  const PostRepository();
  // 2. data List<Post>로 가공
  Future<List<Post>> getAll() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // 컬렉션 레퍼런스 타입의 이름이 기억이 안나요! 혹은 매번 타입 치기 번거로워요! 할땐 final or var!!!
    final collectionRef = firestore.collection('posts');
    final snapshot = await collectionRef.get();
    final documentSnaphots = snapshot.docs;
    // List의 map 을 호출하면 MappedIterable 클래스가 리턴됨
    // list -> MappedIterable : 내가가진 자료를 가공할건데 가공할 방식(함수) 던저줄게 잘 가지고 있어!
    final iterable = documentSnaphots.map((e) {
      final map = {
        'id': e.id, // id는 date에 없기 때문에 직접 가공
        ...e.data(),
      };
      return Post.fromJson(map);
    });

    // MappedIterable야! 내가 주문한 방식으로 리스트 가공해!
    final list = iterable.toList();
    return list;
  }

  // 1. insert 구현하기
  Future<bool> insert({
    required String title,
    required String content,
    required String writer,
    required String imgUrl,
  }) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // 컬렉션 레퍼런스 타입의 이름이 기억이 안나요! 혹은 매번 타입 치기 번거로워요! 할땐 final or var!!!
      final collectionRef = firestore.collection('posts');
      // 새로운 문서를 생성할거니 id 비우고 문서참조 생성!
      final docRef = collectionRef.doc();

      // 생성할 데이터 만들기!
      final map = {
        'title': title,
        'content': content,
        'writer': writer,
        'createdAt': DateTime.now().toIso8601String(),
        'imgUrl': imgUrl,
      };
      // 저장!
      await docRef.set(map);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Post?> getOne(String id) async {
    // data가 null 일경우 catch문 타게.
    // 네트워크 오류일때도 catch문!
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('posts').doc(id).get();
      return Post.fromJson({
        'id': snapshot.id,
        ...snapshot.data()!,
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> delete(String id) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('posts').doc(id);
      await docRef.delete();
      return true;
    } catch (e) {
      print('$e');
      return false;
    }
  }

  Future<bool> update({
    required String id,
    required String writer,
    required String title,
    required String content,
    required String imgUrl,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('posts').doc(id);
      await docRef.update({
        'writer': writer,
        'title': title,
        'content': content,
        'imgUrl': imgUrl,
      });
      return true;
    } catch (e) {
      print('$e');
      return false;
    }
  }

  Stream<List<Post>> postListStream() {
    // 1. 컬렉션 참조를 만들어줍니다!
    final collectionRef = FirebaseFirestore.instance
        .collection('posts')
        // 여기서 리스트 가지고 올 때 정렬 방식도 정할수 있어요!
        // .count 나 .where과 같은 조건으로 가지고 올 수도 있어요!
        .orderBy('createdAt', descending: true);
    // 2. 참조의 스냅샷 메서드는 변경이 일어날 때마다 스트림에 값을 하나씩 넣어주는 역할을 해요!
    final snapshotStream = collectionRef.snapshots();
    // 3. 스트림을 가공해서 다른 List<Post> 타입의 스트림으로 만들게요!
    return snapshotStream.map(
      (event) {
        return event.docs.map(
          (doc) {
            return Post.fromJson({'id': doc.id, ...doc.data()});
          },
        ).toList();
      },
    );
  }

  Stream<Post?> postStream(String id) {
    final snapshot = FirebaseFirestore.instance.collection('posts').doc(id);
    return snapshot.snapshots().map(
      (e) {
        if (e.data() == null) {
          return null;
        }
        return Post.fromJson({'id': e.id, ...e.data()!});
      },
    );
  }
}
