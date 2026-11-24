import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/main.dart';

void main() {
  testWidgets('ProjectsSection renders Orca Media Player', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: ProjectsSection())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Orca Media Player'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('Android'), findsOneWidget);
    expect(find.byType(FlutterMonochromeIcon), findsOneWidget);
    expect(find.text('ZebPay'), findsOneWidget);
  });
}
