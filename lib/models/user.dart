class User {
  final int id;
  final String name;
  final String initials;

  String getInitials() {
    final List<String> names = name.split(' ');
    final initials = names[0][0] + names[names.length - 1][0];
    return initials;
  }

  User({
    required this.id,
    required this.name,
    required this.initials
  });

  factory User.fromMap(Map<String, dynamic> map) {
    final List<String> names = map['name'].split(' ');
    final initials = names[0][0] + names[names.length - 1][0];
    return User(
        id: map['id'],
        name: map['name'],
        initials: initials
    );
  }
}