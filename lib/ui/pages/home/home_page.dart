import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/ui/pages/home/widgets/home_list_view.dart';
import 'package:flutter_firebase_blog_app/ui/pages/write/write_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DEV JOURNAL'),
        centerTitle: false,
      ),
      backgroundColor: Colors.grey[200],
      body: const SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Build notes, shipped in Flutter',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Firebase · Firestore · Riverpod · Storage',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            HomeListView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const WritePage(post: null);
            },
          ));
        },
        icon: const Icon(Icons.edit_outlined),
        label: const Text('새 글'),
      ),
    );
  }
}
