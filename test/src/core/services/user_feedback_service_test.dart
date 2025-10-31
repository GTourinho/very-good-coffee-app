import 'package:coffee_app/src/core/services/user_feedback_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserFeedbackService', () {
    testWidgets('showSnackBar displays snackbar with correct message',
        (tester) async {
      const message = 'Test message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    UserFeedbackService.showSnackBar(
                      context,
                      message,
                    );
                  },
                  child: const Text('Show Snackbar'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Snackbar'));
      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
    });

    testWidgets('showSnackBar displays error snackbar with red color',
        (tester) async {
      const message = 'Error message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    UserFeedbackService.showSnackBar(
                      context,
                      message,
                      type: FeedbackType.error,
                    );
                  },
                  child: const Text('Show Error Snackbar'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Error Snackbar'));
      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
      
      // Check if snackbar has error styling (red background)
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, equals(Colors.red));
    });

    testWidgets('showSnackBar displays success snackbar with green color',
        (tester) async {
      const message = 'Success message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    UserFeedbackService.showSnackBar(
                      context,
                      message,
                      type: FeedbackType.success,
                    );
                  },
                  child: const Text('Show Success Snackbar'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Success Snackbar'));
      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
      
      // Check if snackbar has success styling (green background)
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, equals(Colors.green));
    });

    testWidgets('showSnackBar displays info snackbar with blue color',
        (tester) async {
      const message = 'Info message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    UserFeedbackService.showSnackBar(
                      context,
                      message,
                    );
                  },
                  child: const Text('Show Info Snackbar'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Info Snackbar'));
      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
      
      // Check if snackbar has info styling (blue background)
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, equals(Colors.blue));
    });

    testWidgets('showSnackBar does nothing when context is not mounted',
        (tester) async {
      const message = 'Test message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    // Simulate unmounted context by calling after navigation
                    Navigator.of(context).pop();
                    UserFeedbackService.showSnackBar(
                      context,
                      message,
                    );
                  },
                  child: const Text('Show Snackbar'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Snackbar'));
      await tester.pumpAndSettle();

      // Should not show snackbar since context is not mounted
      expect(find.text(message), findsNothing);
    });
  });
}
