import 'package:flutter_test/flutter_test.dart';
import 'package:jameya/core/services/services_locator.dart';
import 'package:jameya/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await setupServiceLocator();
    await tester.pumpWidget(const JameyaApp());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
