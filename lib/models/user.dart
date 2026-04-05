class User {
  final int id;
  final String name;
  final String initials;

  String getInitials() {
    final List<String> names = name.split(' ');
    final initials = names[0][0] + names[names.length - 1][0];
    return initials;
  }

  User._(this.id, this.name, this.initials);

  factory User(int id, String name) {
    final List<String> names = name.split(' ');
    final initials = names[0][0] + names[names.length - 1][0];
    return User._(id, name, initials);
  }
}