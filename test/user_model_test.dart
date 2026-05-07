import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_dev/models/user.dart';

void main() {
  test('User.fromMap creates valid User object', () {
    final map = {
      'id': 1,
      'name': 'Abdullahi Jaafar',
    };

    final user = User.fromMap(map);

    expect(user.id, 1);
    expect(user.name, 'Abdullahi Jaafar');
    expect(user.initials, 'AJ');
  });
}