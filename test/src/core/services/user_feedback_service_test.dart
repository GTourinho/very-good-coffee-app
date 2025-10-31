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

    testWidgets('showSnackBar displays warning snackbar with orange color',
        (tester) async {
      const message = 'Warning message';

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
                      type: FeedbackType.warning,
                    );
                  },
                  child: const Text('Show Warning Snackbar'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Warning Snackbar'));
      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, equals(Colors.orange));
    });

    testWidgets('showSnackBar with action displays action button',
        (tester) async {
      const message = 'Action message';
      var actionCalled = false;

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
                      action: () => actionCalled = true,
                      actionLabel: 'Undo',
                    );
                  },
                  child: const Text('Show Snackbar with Action'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Snackbar with Action'));
      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
      expect(find.text('Undo'), findsOneWidget);

      await tester.tap(find.text('Undo'));
      expect(actionCalled, isTrue);
    });

    testWidgets(
        'showAlertDialog displays dialog with correct title and message',
        (tester) async {
      const title = 'Alert Title';
      const message = 'Alert message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await UserFeedbackService.showAlertDialog(
                      context,
                      title,
                      message,
                    );
                  },
                  child: const Text('Show Alert'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Alert'));
      await tester.pumpAndSettle();

      expect(find.text(title), findsOneWidget);
      expect(find.text(message), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('showAlertDialog calls onConfirm when OK is tapped',
        (tester) async {
      const title = 'Alert Title';
      const message = 'Alert message';
      var confirmCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await UserFeedbackService.showAlertDialog(
                      context,
                      title,
                      message,
                      onConfirm: () => confirmCalled = true,
                    );
                  },
                  child: const Text('Show Alert'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Alert'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(confirmCalled, isTrue);
    });

    testWidgets('showAlertDialog displays error dialog with red icon',
        (tester) async {
      const title = 'Error';
      const message = 'Error message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await UserFeedbackService.showAlertDialog(
                      context,
                      title,
                      message,
                      type: FeedbackType.error,
                    );
                  },
                  child: const Text('Show Error Alert'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Error Alert'));
      await tester.pumpAndSettle();

      expect(find.text(title), findsOneWidget);
      expect(find.text(message), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('showAlertDialog displays success dialog with green icon',
        (tester) async {
      const title = 'Success';
      const message = 'Success message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await UserFeedbackService.showAlertDialog(
                      context,
                      title,
                      message,
                      type: FeedbackType.success,
                    );
                  },
                  child: const Text('Show Success Alert'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Success Alert'));
      await tester.pumpAndSettle();

      expect(find.text(title), findsOneWidget);
      expect(find.text(message), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('showAlertDialog displays warning dialog with warning icon',
        (tester) async {
      const title = 'Warning';
      const message = 'Warning message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await UserFeedbackService.showAlertDialog(
                      context,
                      title,
                      message,
                      type: FeedbackType.warning,
                    );
                  },
                  child: const Text('Show Warning Alert'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Warning Alert'));
      await tester.pumpAndSettle();

      expect(find.text(title), findsOneWidget);
      expect(find.text(message), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets(
        'showAlertDialog with custom confirmText displays correct button',
        (tester) async {
      const title = 'Confirm';
      const message = 'Are you sure?';
      const confirmText = 'Yes';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await UserFeedbackService.showAlertDialog(
                      context,
                      title,
                      message,
                      confirmText: confirmText,
                    );
                  },
                  child: const Text('Show Alert'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Alert'));
      await tester.pumpAndSettle();

      expect(find.text(confirmText), findsOneWidget);
    });
  });
}
