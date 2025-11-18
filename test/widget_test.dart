import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_contacts/main.dart';

void main() {
  testWidgets('Login page loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the login page contains key elements
    expect(find.text('Connexion'), findsOneWidget); // Vérifie le titre de la page de connexion
    expect(find.byType(TextField), findsAtLeast(2)); // Email and password fields
    expect(find.byType(ElevatedButton), findsOneWidget); // Login button
  });

  testWidgets('Login form shows validation errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Try to tap the login button without entering any data
    await tester.tap(find.text('Se connecter'));
    await tester.pump();

    // Should remain on login page
    expect(find.text('Connexion'), findsOneWidget);
  });

  testWidgets('App starts with login page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify initial page is login
    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
  });
}