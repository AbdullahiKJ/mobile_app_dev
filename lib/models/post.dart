class Post {
  final int id;
  final String content;
  final String imagePaths;
  final DateTime date;
  final int userId;

  Post({
    required this.id,
    required this.content,
    required this.imagePaths,
    required this.date,
    required this.userId
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      content: map['content'],
      imagePaths: map['imagePaths'],
      date: DateTime.parse(map['date']),
      userId: map['userId'],
    );
  }

  // Convert the post to a string/dynamic map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'imagePaths': imagePaths,
      'date': date,
      'userId': userId,
    };
  }
}