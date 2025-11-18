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
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPage();
        },
      ),
      GoRoute(
        path: '/debug',
        name: 'debug',
        builder: (BuildContext context, GoRouterState state) {
          return const DebugPage();
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/add-contact',
        name: 'add-contact',
        builder: (BuildContext context, GoRouterState state) {
          return const AddContactPage();
        },
      ),
      GoRoute(
        path: '/edit-contact',
        name: 'edit-contact',
        builder: (BuildContext context, GoRouterState state) {
          // VERSION CORRIGÉE AVEC GESTION D'ERREUR
          if (state.extra != null && state.extra is Contact) {
            final contact = state.extra as Contact;
            return EditContactPage(contact: contact);
          } else {
            // Si pas de contact, retour à l'accueil
            return const HomePage();
          }
        },
      ),
    ],
  );
}