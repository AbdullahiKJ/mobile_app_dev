class Post {
  final int id;
  final String content;
  final String imagePath;
  final DateTime date;
  final int userId;

  Post({
    required this.id,
    required this.content,
    required this.imagePath,
    required this.date,
    required this.userId
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      content: map['content'],
      imagePath: map['imagePath'],
      date: DateTime.parse(map['date']),
      userId: map['userId'],
    );
  }

  // Convert the post to a string/dynamic map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'imagePath': imagePath,
      'date': date,
      'userId': userId,
    };
  }
}