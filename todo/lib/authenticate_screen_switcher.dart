// this widget chooses which screen is now used for authentication.. either sign in screen or sign up
// i tried just using the Navigator.push() but it wont work well with the provider because its only associated with the sign in screen
import 'package:flutter/material.dart';
import 'package:todo/login_screen.dart';
import 'package:todo/sign_up_screen.dart';

class AuthSwitcher extends StatefulWidget {
  const AuthSwitcher({super.key});

  @override
  State<AuthSwitcher> createState() => _AuthSwitcherState();
}

class _AuthSwitcherState extends State<AuthSwitcher> {
  bool showSignInScreen  = true;
  void switcher(){
    setState(() {
      showSignInScreen = !showSignInScreen;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showSignInScreen){
      return  LoginScreen(switcher: switcher);
    }
    else{
      return  SignUpScreen(switcher: switcher);
    }
  }
}