// this screen for creating a new account

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:todo/loading.dart';
import 'package:todo/services/auth.dart';

class SignUpScreen extends StatefulWidget {
  final Function switcher;
  const SignUpScreen({super.key,required this.switcher});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // this variable is used to indicate the flare animation (background flare)
  // it has three animations
  // 1- move when u enter the page this animation will happen it brings the flare componentes to the screen
  // 2- rotate after the move animation
  // 3- move_out it clears the page from the flare components
  String screenAnimation = 'move';
  // the input fields controllers
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confrimPasswordController = TextEditingController();

  // this key is used for tracking the state of the form
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  // this is error message that appears if the users enters an invalid email
  String error = '';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading? const Loading() : Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.red[100],
          onPressed: () {
            setState(() {
              screenAnimation = 'move_out';
            });
          },
        ),
        title: Text(
          "SignUp",
          style: TextStyle(
              color: Colors.red[100],
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: <Widget>[
          FlareActor(
            'flares/login_bg.flr',
            fit: BoxFit.cover,
            animation: screenAnimation,
            callback: (animation) {
              if (animation == 'move') {
                setState(() {
                  screenAnimation = 'rotate';
                });
              }
              // i made the pop here so it does the animation first then pop the screen
              else if (animation == 'move_out') {
                widget.switcher();
              }
            },
          ),
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 50, 10),
                      child: TextFormField(
                        controller: userNameController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter a user name";
                          } else if (value[0] == " ") {
                            return "User name cant start with a space";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          labelText: "USERNAME",
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          suffix: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                userNameController.text = '';
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 50, 10),
                      child: TextFormField(
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          RegExp regex = RegExp(
                              "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9+_.-]+.[a-zA-Z0-9+_.-]");
                          if (value!.isEmpty) {
                            return "Enter an email";
                          } else if (!regex.hasMatch(value)) {
                            return "Enter a valid email";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail),
                          labelText: "EMAIL",
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          suffix: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                emailController.text = '';
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 50, 10),
                      child: TextFormField(
                        controller: passwordController,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return "Enter a password";
                          } else if (!regex.hasMatch(value)) {
                            return "Please enter a valid password (Min. 6 characters)";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: "PASSWORD",
                          labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 50, 10),
                      child: TextFormField(
                        controller: confrimPasswordController,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        validator: (value) {
                          if (value != passwordController.text) {
                            return "Passwords don`t match";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: "CONFIRM PASSWORD",
                          labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                      child: MaterialButton(
                        color: Colors.red[100],
                        minWidth: MediaQuery.of(context).size.width,
                        height: 70,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading  = true;
                            });
                            dynamic result = await _auth.registerWithEmailAndPassword(emailController.text, passwordController.text,userNameController.text);
                            if(result == null){
                              setState(() {
                                error = "Enter a valid email";
                                loading = false;
                              });
                            }    
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 18,
                      child: Text(error,
                      style: const TextStyle(fontSize: 12,color: Colors.red),),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
