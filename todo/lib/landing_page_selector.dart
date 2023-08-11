// this widget determines which is the landing screen either the home screen or the login screen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/authenticate_screen_switcher.dart';
import 'package:todo/home_screen.dart';

class SelectorWidget extends StatelessWidget {
  const SelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // the provider keeps track of the user auth is the user signs in or out
    final user = Provider.of<User?>(context);
    if(user == null){
      return const AuthSwitcher();
    }
    else{
      return const HomeScreen();
    }
  }
}