import 'package:flutter_test/flutter_test.dart';
import 'package:jameya/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const JameyaApp());
  });
}
