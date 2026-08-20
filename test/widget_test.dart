import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/sample/sample_posts.dart';
import 'package:flutter_firebase_blog_app/main.dart';
import 'package:flutter_firebase_blog_app/ui/pages/detail/detail_page.dart';
import 'package:flutter_firebase_blog_app/ui/pages/write/write_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows intentional portfolio preview feed', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pump();

    expect(find.text('DEV JOURNAL'), findsOneWidget);
    expect(find.text('Build. Break.\nWrite it down.'), findsOneWidget);
    expect(find.text('RECENT POSTS'), findsOneWidget);
    expect(find.text('Preview'), findsOneWidget);
    expect(find.text('Designing a calmer Flutter feed'), findsOneWidget);
    expect(find.text('Flutter UI'), findsWidgets);
    expect(
        portfolioSamplePosts.every((post) => post.imgUrl.startsWith('asset:')),
        isTrue);
  });

  testWidgets('sample post opens a complete detail experience', (tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MyAppHarness(
          child: DetailPage(portfolioSamplePosts.first, previewMode: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Journal entry'), findsOneWidget);
    expect(find.text('PREVIEW'), findsOneWidget);
    expect(find.text(portfolioSamplePosts.first.title), findsOneWidget);
    expect(
        find.textContaining('product instead of a CRUD demo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('preview write page is scrollable on a compact screen',
      (tester) async {
    tester.view.physicalSize = const Size(412, 732);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MyAppHarness(
          child: WritePage(post: null, previewMode: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('New note'), findsOneWidget);
    expect(find.text('Choose cover image'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(
      find.text('Publish post'),
      320,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Publish post'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('Android applicationId has a matching Firebase client', () {
    const expectedPackage = 'com.example.app.flutterFirebaseBlogApp';
    final gradle = File('android/app/build.gradle').readAsStringSync();
    final googleServices = jsonDecode(
      File('android/app/google-services.json').readAsStringSync(),
    ) as Map<String, dynamic>;

    expect(gradle, contains('applicationId = "$expectedPackage"'));
    expect(gradle, contains('namespace = "$expectedPackage"'));

    final clients = googleServices['client'] as List<dynamic>;
    final matchingClients = clients.where((client) {
      final info = client as Map<String, dynamic>;
      final clientInfo = info['client_info'] as Map<String, dynamic>;
      final androidInfo =
          clientInfo['android_client_info'] as Map<String, dynamic>;
      return androidInfo['package_name'] == expectedPackage;
    }).toList();

    expect(
      matchingClients,
      isNotEmpty,
      reason: 'google-services.json must contain a client for applicationId',
    );
  });
}

class MyAppHarness extends StatelessWidget {
  const MyAppHarness({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3559E0)),
      ),
      home: child,
    );
  }
}
