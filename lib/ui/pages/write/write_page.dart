import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/ui/pages/write/write_view_model.dart';
import 'package:flutter_firebase_blog_app/ui/widgets/post_cover.dart';
import 'package:flutter_firebase_blog_app/v2/v2_glass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class WritePage extends ConsumerStatefulWidget {
  const WritePage({
    super.key,
    required this.post,
    this.previewMode = false,
  });

  final Post? post;
  final bool previewMode;

  @override
  ConsumerState<WritePage> createState() => _WritePageState();
}

class _WritePageState extends ConsumerState<WritePage> {
  static const categories = [
    'Flutter UI',
    'Firebase',
    'Build Notes',
    'Architecture',
    'Development',
  ];

  late final TextEditingController writerController;
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late String selectedCategory;
  String? localImagePath;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    writerController =
        TextEditingController(text: widget.post?.writer ?? 'oosuhada');
    titleController = TextEditingController(
      text: widget.post?.title ??
          (widget.previewMode ? 'Refining liquid glass writing surfaces' : ''),
    );
    contentController = TextEditingController(
      text: widget.post?.content ??
          (widget.previewMode
              ? 'A focused pass on title and body surfaces: each field now owns its own translucent layer, backdrop blur, edge highlight, and readable foreground contrast.\n\nThe cover stays photographic while the writing controls form a clear glass hierarchy around it.'
              : ''),
    );
    final initialCategory = widget.post?.category ?? categories.first;
    selectedCategory = categories.contains(initialCategory)
        ? initialCategory
        : categories.last;
  }

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
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final isEditing = widget.post != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            isEditing ? 'Edit note' : 'New note',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          actions: [
            if (widget.previewMode)
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Center(child: _PreviewModeBadge()),
              ),
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(20, 10, 20, keyboardInset + 36),
            children: [
              Text(
                isEditing
                    ? 'Shape the next revision.'
                    : 'Capture what changed while it is fresh.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.5,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.previewMode
                    ? 'Portfolio preview keeps this draft local. Live mode publishes through Firebase Storage and Firestore.'
                    : 'Add a cover, write the note, then publish it to the live Firebase journal.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      height: 1.45,
                    ),
              ),
              const SizedBox(height: 24),
              _SectionLabel(label: 'COVER'),
              const SizedBox(height: 10),
              _GlassFormSection(
                child: Column(
                  children: [
                    _CoverPreview(
                      post: _draftPost(state.imageUrl),
                      localImagePath: localImagePath,
                      imageUrl: state.imageUrl,
                    ),
                    const SizedBox(height: 12),
                    AppGlassPrimaryButton(
                      onPressed: state.isWriting ? null : _pickImage,
                      label: state.isWriting
                          ? 'Uploading cover…'
                          : localImagePath == null &&
                                  (state.imageUrl?.isEmpty ?? true)
                              ? 'Choose cover image'
                              : 'Replace cover image',
                      tint: Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              _SectionLabel(label: 'STORY'),
              const SizedBox(height: 10),
              _GlassWritingField(
                label: 'Title',
                child: TextFormField(
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'What did you learn or ship?',
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                  validator: _required('Add a title'),
                ),
              ),
              const SizedBox(height: 12),
              _GlassWritingField(
                label: 'Body',
                child: TextFormField(
                  controller: contentController,
                  minLines: 8,
                  maxLines: 16,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText:
                        'Context, decisions, tradeoffs, and what you would do next…',
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(fontSize: 15, height: 1.55),
                  validator: _required('Write a few notes first'),
                ),
              ),
              const SizedBox(height: 26),
              _SectionLabel(label: 'PUBLISHING DETAILS'),
              const SizedBox(height: 10),
              _GlassPublishingField(
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1C20),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  items: categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedCategory = value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              _GlassPublishingField(
                child: TextFormField(
                  controller: writerController,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1C20),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Author',
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  validator: _required('Add an author'),
                ),
              ),
              const SizedBox(height: 24),
              AppGlassPrimaryButton(
                onPressed:
                    state.isWriting ? null : () => _submit(state.imageUrl),
                label: isEditing ? 'Update post' : 'Publish post',
              ),
              const SizedBox(height: 10),
              Text(
                widget.previewMode
                    ? 'Preview mode does not write sample content to Firebase.'
                    : 'Live mode writes the cover to Storage and the post document to Firestore.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Colors.black45),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FormFieldValidator<String> _required(String message) {
    return (value) => value?.trim().isEmpty ?? true ? message : null;
  }

  Post _draftPost(String? imageUrl) {
    return Post(
      id: widget.post?.id ?? 'draft-local-cover',
      writer: writerController.text.trim().isEmpty
          ? 'oosuhada'
          : writerController.text.trim(),
      title: titleController.text.trim().isEmpty
          ? 'Untitled field note'
          : titleController.text.trim(),
      content: contentController.text,
      createdAt: widget.post?.createdAt ?? DateTime.now(),
      imgUrl: (imageUrl?.trim().isNotEmpty ?? false)
          ? imageUrl!
          : widget.previewMode
              ? 'asset:assets/images/posts/writing-flow.jpg'
              : '',
      category: selectedCategory,
    );
  }

  Future<void> _pickImage() async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 1800,
    );
    if (xFile == null || !mounted) return;

    setState(() => localImagePath = xFile.path);

    if (!widget.previewMode) {
      await ref.read(writeViewModel(widget.post).notifier).uploadImage(xFile);
    }
  }

  Future<void> _submit(String? imageUrl) async {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return;

    if (widget.previewMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Preview draft looks good. Connect live Firebase data to publish it.'),
        ),
      );
      return;
    }

    if (imageUrl?.trim().isEmpty ?? true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Choose a cover image before publishing.')),
      );
      return;
    }

    final result = await ref.read(writeViewModel(widget.post).notifier).insert(
          writer: writerController.text.trim(),
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          category: selectedCategory,
        );

    if (!mounted) return;
    if (result) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Could not publish. Check the Firebase connection and try again.')),
      );
    }
  }
}

class _CoverPreview extends StatelessWidget {
  const _CoverPreview({
    required this.post,
    required this.localImagePath,
    required this.imageUrl,
  });

  final Post post;
  final String? localImagePath;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 190,
        width: double.infinity,
        child: localImagePath != null
            ? Image.file(
                File(localImagePath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => PostCover(post: post),
              )
            : PostCover(
                post: post,
                imageUrlOverride:
                    (imageUrl?.trim().isNotEmpty ?? false) ? imageUrl : null,
              ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
    );
  }
}

class _GlassFormSection extends StatelessWidget {
  const _GlassFormSection({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppGlassSurface(
      borderRadius: BorderRadius.circular(24),
      blurSigma: 16,
      surfaceOpacity: .68,
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}

class _GlassWritingField extends StatefulWidget {
  const _GlassWritingField({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  State<_GlassWritingField> createState() => _GlassWritingFieldState();
}

class _GlassWritingFieldState extends State<_GlassWritingField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Focus(
      onFocusChange: (focused) {
        if (_focused != focused) setState(() => _focused = focused);
      },
      child: AppGlassSurface(
        tint: _focused ? scheme.primaryContainer : const Color(0xFFF8F8FE),
        surfaceOpacity: _focused ? .76 : .66,
        blurSigma: 20,
        borderRadius: BorderRadius.circular(22),
        padding: const EdgeInsets.fromLTRB(16, 13, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: _focused
                        ? scheme.primary
                        : scheme.primary.withValues(alpha: .5),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.25,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            widget.child,
          ],
        ),
      ),
    );
  }
}

class _GlassPublishingField extends StatelessWidget {
  const _GlassPublishingField({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppGlassSurface(
      borderRadius: BorderRadius.circular(20),
      blurSigma: 18,
      surfaceOpacity: .62,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: child,
    );
  }
}

class _PreviewModeBadge extends StatelessWidget {
  const _PreviewModeBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'PREVIEW',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: .7,
            ),
      ),
    );
  }
}
