class Post {
  Post({
    required this.id,
    required this.writer,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.imgUrl,
  });

  final String id;
  final String writer;
  final String title;
  final String content;
  final DateTime createdAt;
  final String imgUrl;

  Post.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          writer: json['writer'],
          title: json['title'],
          content: json['content'],
          createdAt: DateTime.parse(json['createdAt']),
          imgUrl: json['imgUrl'],
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'writer': writer,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        imgUrl: imgUrl,
      };
}
