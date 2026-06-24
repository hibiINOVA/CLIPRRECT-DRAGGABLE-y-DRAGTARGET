import 'package:flutter_test/flutter_test.dart';
import 'package:dragclick/main.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MiAppEducativa());
    expect(find.text('ClipRRect & DragTarget — Explicación'), findsOneWidget);
  });
}
