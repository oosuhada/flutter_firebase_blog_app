import 'package:flutter_firebase_blog_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows portfolio fallback posts', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pump();

    expect(find.text('BLOG'), findsOneWidget);
    expect(find.text('최근 글'), findsOneWidget);
    expect(find.text('Portfolio preview · sample posts'), findsOneWidget);
    expect(find.text('Flutter와 Firebase로 글 목록 만들기'), findsOneWidget);
  });
}
