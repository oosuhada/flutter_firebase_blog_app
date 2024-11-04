import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/ui/pages/write/write_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class WritePage extends ConsumerStatefulWidget {
  const WritePage({super.key, required this.post});

  final Post? post;

  @override
  ConsumerState<WritePage> createState() => _WritePageState();
}

class _WritePageState extends ConsumerState<WritePage> {
  // 1. 수정일떈 TextEditingController에 값 할당
  late final writerController =
      TextEditingController(text: widget.post?.writer);
  late final titleController = TextEditingController(text: widget.post?.title);
  late final contentController =
      TextEditingController(text: widget.post?.content);

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    writerController.dispose();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(writeViewModel(widget.post));
    final vm = ref.read(writeViewModel(widget.post).notifier);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('글쓰기'),
          actions: [
            GestureDetector(
              onTap: () async {
                // 수정!
                if (!formKey.currentState!.validate()) {
                  return;
                }
                final result = await vm.insert(
                  writer: writerController.text,
                  title: titleController.text,
                  content: contentController.text,
                );
                if (result && mounted) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  '완료',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8)
          ],
        ),
        // 4. body Form 으로 감싸기
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                TextFormField(
                  controller: writerController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(hintText: '작성자'),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return '작성자를 입력해 주세요';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: titleController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(hintText: '제목'),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return '제목을 입력해 주세요';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 200,
                  child: TextFormField(
                    controller: contentController,
                    maxLines: null,
                    expands: true,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(hintText: '내용'),
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return '컨텐츠를 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                // 7. 사진 업로드 할 위젯
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      final xFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (xFile != null) {
                        vm.uploadImage(xFile);
                      }
                    },
                    child: state.imageUrl == null
                        ? Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey,
                            child: Icon(Icons.image),
                          )
                        : SizedBox(
                            height: 100,
                            child: Image.network(state.imageUrl!),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
