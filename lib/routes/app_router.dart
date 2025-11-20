import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/debug_page.dart';
import '../pages/home_page.dart';
import '../pages/add_contact_page.dart';
import '../pages/edit_contact_page.dart';
import '../models/contact.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',   // Point d'entrée de l'application
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

        GoRoute(
        path: '/debug',
        name: 'debug',
        builder: (context, state) => const DebugPage(),
      ),

      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      GoRoute(
        path: '/add-contact',
        name: 'add-contact',
        builder: (context, state) => const AddContactPage(),
      ),

      GoRoute(
        path: '/edit-contact',
        name: 'edit-contact',

        // --- IMPORTANT ---
        // secure cast pour éviter les erreurs si state.extra = null
        builder: (context, state) {
          final contact = state.extra;

          if (contact == null || contact is! Contact) {
            return const Scaffold(
              body: Center(
                child: Text(
                  "Erreur : aucun contact reçu pour l'édition.",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          }

          return EditContactPage(contact: contact);
        },
      ),
    ],
  );
}
