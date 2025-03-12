import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../navigation/presentation/screens/main_screen.dart';
import '../pages/login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the snapshot has user data, then they're already signed in
        if (snapshot.hasData) {
          return const MainScreen();
        }
        // Otherwise, they're not signed in
        return const MyHomePage();
      },
    );
  }
} 