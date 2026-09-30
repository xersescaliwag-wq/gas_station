import 'package:flutter_test/flutter_test.dart';
import 'package:ArPIpie/app.dart';

void main() {
  testWidgets('VoltexApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VoltexApp());
    expect(find.text('Voltex'), findsOneWidget);
  });
}
