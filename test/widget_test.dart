import 'package:asmrapp/core/theme/app_theme.dart';
import 'package:asmrapp/widgets/common/tag_chip.dart';
import 'package:asmrapp/widgets/pagination_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Yuro light theme renders core controls', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Column(
            children: [
              const TagChip(text: 'ASMR'),
              PaginationControls(
                currentPage: 1,
                totalPages: 8,
                isLoading: false,
                onPageChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('ASMR'), findsOneWidget);
    expect(find.text('1 / 8'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
  });

  testWidgets('Yuro dark theme uses the night surface', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(body: Center(child: Text('夜间声场'))),
      ),
    );

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, isNull);
    expect(Theme.of(tester.element(find.text('夜间声场'))).brightness,
        Brightness.dark);
  });
}
