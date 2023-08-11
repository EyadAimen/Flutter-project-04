// this screen when the user signs up and wants to enter the app

import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

import 'package:todo/loading.dart';
import 'package:todo/services/auth.dart';


class LoginScreen extends StatefulWidget {
  final Function switcher;
  const LoginScreen({super.key,required this.switcher});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  final AuthService _auth = AuthService();
  bool loading = false;

  // this variable is used to indicate the flare animation (background flare)
  // it has three animations
  // 1- move when u enter the page this animation will happen it brings the flare componentes to the screen
  // 2- rotate after the move animation
  // 3- move_out it clears the page from the flare components
  String screenAnimation = 'move';
  @override
  Widget build(BuildContext context) {
    return loading? const Loading() : Scaffold(
      appBar: AppBar(
        title: Text('Login',
        style: TextStyle(color: Colors.red[100],fontSize: 20,fontWeight: FontWeight.w500),),
        backgroundColor: Colors.transparent,
      ),
      // using a stack here so the flare can be a like a background image
      body: Stack(
        children: <Widget>[
          FlareActor('flares/login_bg.flr',
          fit: BoxFit.cover,
          animation: screenAnimation,
          callback: (animation){
            if(animation == 'move'){
              setState(() {
                screenAnimation = 'rotate';
              });
            }
            else if(animation == 'move_out'){
              Navigator.of(context).pop();
            }
          },
          ),
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Padding>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50,0,50,10),
                    child: TextFormField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.mail),
                        labelText: "EMAIL",
                        labelStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,),
                        
                        suffix: IconButton(
                          // this icon button to erase the inserted email
                          icon: const Icon(Icons.close),
                          onPressed: (){
                            setState(() {
                              emailController.text = '';
                            });
                          },
                        ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50,0,50,10),
                    child: TextFormField(
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "PASSWORD",
                        labelStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                        // this  will appear when its focused
                        suffix: TextButton(
                          child: const Text("forget"),
                          // this should navigate the user to a screen so that the user will be able to change the password
                          onPressed: (){},),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30,20,30,10),
                      child: MaterialButton(
                        color: Colors.red[100],
                        minWidth: MediaQuery.of(context).size.width,
                        height: 70,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        child: const Text("Log In",
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                      onPressed: () async{
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth.signIn(emailController.text, passwordController.text);
                            if(result == null){
                              setState(() {
                                loading = false;
                                error = "Invalid email or password";
                              });
                              
                            }
                            // else{
                            //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                            // }
                            
                          }
                      },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30,0,30,10),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      color: Colors.red[100]!.withOpacity(0.4),
                      height: 70,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        side: BorderSide(style: BorderStyle.solid,width: 1,color: Colors.red.shade100),
                        ),
                      child: const Text("Don`t have an Account?Sign Up",
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),),
                      onPressed: (){
                        // Navigator.push(context,
                        // MaterialPageRoute(builder: (context)=>const SignUpScreen()));
                        widget.switcher();
                      },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
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