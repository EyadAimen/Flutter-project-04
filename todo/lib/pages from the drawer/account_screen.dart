// this screen pops up when the user wants to see his account and whether to logout or change the password

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/landing_page_selector.dart';
import 'package:todo/pages%20from%20the%20drawer/change_theme_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/services/database.dart';
import 'package:todo/shared_prefrences_functions.dart';


class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {

  TextEditingController _userNameController = TextEditingController();
  bool save = false;
  Color backgroundColor= ChangeThemeScreen.selectedTheme;
  Color textColor= ChangeThemeScreen.isDarkTheme? Colors.white : Colors.black;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  late final UserName _userName = UserName(_currentUser!.uid);

  late FToast fToast;

  // forr the image upload
  File image = File("");
  bool isPath = false;
  dynamic pickedImage;
  final imagePicker = ImagePicker();
  Future getImageFromPhotos() async{
    pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
     if(pickedImage != null){
      setState(() {
        image = File(pickedImage.path);
        isPath = true;
      });
      await TodoListSharedPrefs.setImage(pickedImage.path);
      await TodoListSharedPrefs.setPath(true);
     }
  }
  Future getImageFromCamera() async{
    pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
     if(pickedImage != null){
      setState(() {
        image = File(pickedImage.path);
        isPath = true;
      });
     }
   await TodoListSharedPrefs.setImage(pickedImage.path);  
  }

  // for getting the stored image
  dynamic imagePath;
  getStoredImage() async{
    imagePath = await TodoListSharedPrefs.getImage()??'';
    if(imagePath == ''){
      setState(() {
        isPath = false;
      });
      
    }
    else{
      setState(() {
        isPath = true;
      });
      
    }
    image = File(imagePath);
  }
  
  @override
  void initState() {
    getStoredImage();
    // this is for the toeast message
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !ChangeThemeScreen.isDarkTheme ? Colors.white: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          onPressed: (){
            if(save){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SelectorWidget()), (route) => false);
            }
            else{
              Navigator.pop(context);
            }
            
          },
          icon: const Icon(Icons.arrow_back_ios,size: 24,
          color: Colors.white,
          ),
        ),
        title: const Text("Account",
        style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400),
        ),
        actions: <IconButton>[
          IconButton(
            onPressed: (){
              _userName.updateUserName(_userNameController.text);
              setState(() {
                save = true;
              });
              fToast.showToast(
                toastDuration: const Duration(seconds: 2),
                child: Container(
                  width: 200,
                  height: 50,
                  padding: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ChangeThemeScreen.isDarkTheme ? Colors.grey[700] : Colors.white,
                  ),
                  child: Text("User name changed..",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14,
                  color: ChangeThemeScreen.isDarkTheme ? Colors.white : Colors.black,),),
               ),
                            
              );
            },
            icon: const Icon(Icons.check,size: 24,
            color:Colors.white,
            ), 
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            // padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width*0.7,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: MaterialButton(
                    shape:const CircleBorder(),
                  
                    onPressed: (){
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10)
                          )
                        ),
                        context: context,
                        builder: (context){
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                child: TextButton(
                                  onPressed: (){
                                    getImageFromCamera();
                                  },
                                  child: Text("Camera",
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,color: textColor),),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(top:BorderSide(width: 1,color: backgroundColor)),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                child: TextButton(
                                  onPressed: (){
                                    getImageFromPhotos();
                                  },
                                  child: Text("Photos",
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,color: textColor),),
                                ),
                              ),
                            ],
                          );
                        }
                        );
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: isPath? Image.file(image).image : const AssetImage("asset/default.png"),
                    ),
                    ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("User name: ",
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: textColor),),
                    Expanded(
                    
                    // i used a stream builder to get the username from the database
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.doc("userNames/${_currentUser!.uid}").snapshots(),
                      builder: (context,snapshot){
                        final name = snapshot.data;
                        if(!snapshot.hasData){
                          return const Text("Loading...");
                        }
                        else{
                          _userNameController.text = name!['userName'];
                          return TextField(
                          controller: _userNameController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(borderSide: BorderSide.none),
                            focusColor: backgroundColor,
                          ),
                          style: TextStyle(color: ChangeThemeScreen.isDarkTheme?Colors.white:Colors.black),
                        );
                        }
                        
                      },
                    ),
                    ),
                  ],
                ),
              ],
            ),
            ),
        ),
      ),
    );
  }
}