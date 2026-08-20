class Post {
  Post({
    required this.id,
    required this.writer,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.imgUrl,
    this.category = 'Development',
  });

  final String id;
  final String writer;
  final String title;
  final String content;
  final DateTime createdAt;
  final String imgUrl;
  final String category;

  Post.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          writer: json['writer'],
          title: json['title'],
          content: json['content'],
          createdAt: DateTime.parse(json['createdAt']),
          imgUrl: json['imgUrl'],
          category: (json['category'] as String?)?.trim().isNotEmpty == true
              ? json['category'] as String
              : 'Development',
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'writer': writer,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'imgUrl': imgUrl,
        'category': category,
      };
}
