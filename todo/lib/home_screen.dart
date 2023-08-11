// this is the main app screen after signing up or login

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:circle_list/circle_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:todo/adding_todo_list_from_floating_action_button_screen.dart';
import 'package:todo/pages%20from%20the%20drawer/account_screen.dart';
import 'package:todo/pages%20from%20the%20drawer/change_theme_screen.dart';
import 'package:todo/services/auth.dart';
import 'package:todo/shared_prefrences_functions.dart';
import 'package:todo/todo_list_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  String title = '';
  Color drawerColorChanger = ChangeThemeScreen.isDarkTheme ? Colors.white : Colors.black;
  Color? backgroundColorChanger = ChangeThemeScreen.isDarkTheme ? Colors.grey[700] : Colors.white;
  
  // this is for the floating action button
  bool isExpanded = false;

  // this instance is for the toast message so you can change its appearance
  late FToast fToast;

  // for the sign out
  final AuthService _auth = AuthService();
  // for the height, width, bottom border, shadow animation for the floating action button
  late AnimationController _controller;
  late Animation <double> _width;
  late Animation <double> _height;
  late Animation <double> _border;
  late Animation _shadow;

  // this firebase user instance is to get the current user`s id and use it to get the user`s user name
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  // for getting the stored image
  bool isPath = false;
  File image = File("");
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

  // this dialog pops after clicking on the logout listtile
  Future logoutDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: backgroundColorChanger,
      title: Text("Do you want to log out?",
      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.black),),
      actions: <TextButton>[
        TextButton(onPressed: () async{
          TodoListSharedPrefs.deleteImage();
          await _auth.signOut();
        },
        child: Text("Yes",
        style: TextStyle(fontSize: 12,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.black))
        ),
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
        child: Text("no",
        style: TextStyle(fontSize: 12,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.black)),
        ),
      ],
    ),
    );

  @override
  void initState(){
    // for the image
    getStoredImage();
    super.initState();

    // for the animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this
    );
    _width = Tween<double>(begin: 56,end: 200).animate(_controller);
    _height = Tween<double>(begin: 56,end:100).animate(_controller);
    _border = Tween<double>(begin: 100,end:0).animate(_controller);
    _shadow =  ColorTween(begin: Colors.grey.shade800,end: Colors.transparent).animate(_controller);
    
    
    _controller.addStatusListener((status) { 
      if(status == AnimationStatus.completed){
        setState(() {
          isExpanded = true;
        });
      
      }
      else if (status == AnimationStatus.dismissed){
        setState(() {
          isExpanded = false;
        });
      }
    });
    
    
    // this is for the toeast message
    fToast = FToast();
    fToast.init(context);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChangeThemeScreen.selectedTheme,
      // appBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // i made it like this cuz when i do it without the builder method i cant use the Scaffold.of(context)
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: (){
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu,size: 24,),
            color: Colors.white,
            ),
        ),
        title: const Text("To Do",
        style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400),),
      ),

      // body
      body: Padding(
        padding: EdgeInsets.fromLTRB(0,MediaQuery.of(context).size.height*0.1,0,0),
        child: CarouselSlider.builder(
          // to set the item count
          itemCount: AddingTodoListItem.todoWidgets.length,
          // to build the widgets in the Carousel_slider
          itemBuilder: (context,index,index2){
            // to set the icon for the icon
            
              Icon todoListItemIcon = AddingTodoListItem.todoWidgets[index] == "Sports"? Icon(Icons.run_circle_outlined,color: ChangeThemeScreen.isDarkTheme?Colors.white: Colors.green[300],size: 30,)
            :AddingTodoListItem.todoWidgets[index] == "Read"? Icon(Icons.book,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.red[100],size: 30,)
            :AddingTodoListItem.todoWidgets[index] == "Games"? Icon(Icons.games,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.blue[200],size: 30,)
            :AddingTodoListItem.todoWidgets[index] == "Music"? Icon(Icons.music_note,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.brown[200],size: 30,)
            :Icon(Icons.cases_sharp,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.blueGrey[400],size: 30,);
            
            // to set the color for the item
            Color? todoListItemColor = (AddingTodoListItem.todoWidgets[index] == "Sports"? Colors.green[300]
            :AddingTodoListItem.todoWidgets[index] == "Read"? Colors.red[100]
            :AddingTodoListItem.todoWidgets[index] == "Games"? Colors.blue[200]
            :AddingTodoListItem.todoWidgets[index] == "Music"? Colors.brown[200]
            :Colors.blueGrey[400]) as Color;


            late List<String> todoItems = AddingTodoListItem.todoWidgets[index] == "Sports"? AddingTodoListItem.sports
            :AddingTodoListItem.todoWidgets[index] == "Read"? AddingTodoListItem.read
            :AddingTodoListItem.todoWidgets[index] == "Games"? AddingTodoListItem.games
            :AddingTodoListItem.todoWidgets[index] == "Music"? AddingTodoListItem.music
            :AddingTodoListItem.work;


                    
            late List<bool> checkboxValue = AddingTodoListItem.todoWidgets[index] == "Sports"? AddingTodoListItem.sportsCheckboxValue
                    :AddingTodoListItem.todoWidgets[index] == "Read"? AddingTodoListItem.readCheckboxValue
                    :AddingTodoListItem.todoWidgets[index] == "Games"? AddingTodoListItem.gamesCheckboxValue
                    :AddingTodoListItem.todoWidgets[index] == "Music"? AddingTodoListItem.musicCheckboxValue
                    :AddingTodoListItem.workCheckboxValue;
                    
                    
            int checkedItems = 0;
            for(int i = 0; i<checkboxValue.length;i++){
              if(checkboxValue[i] == true){
                checkedItems++;
                }
              }

            // returning hero because of the animation
            return Hero(
              tag: "oneTodoList$index",
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TodoListDetalis(index)));
                },
                // this widget is for sliding the widget and get a delete option
                child: Slidable(
                  closeOnScroll: true,
                  direction: Axis.vertical,
                  endActionPane: ActionPane(
                    motion: const BehindMotion(), 
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete,color: Colors.white,size: 24,),
                      onPressed: () {
                        setState(() {
                          AddingTodoListItem.todoWidgets.removeAt(index);
                          todoItems.clear();
                          
                          });
                          fToast.showToast(
                            toastDuration: const Duration(seconds: 2),
                            child: Container(
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ChangeThemeScreen.isDarkTheme ? Colors.grey[700] : Colors.white,
                              ),
                              child: Text("Deleted..",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14,
                              color: ChangeThemeScreen.isDarkTheme ? Colors.white : Colors.black,),),
                            ),
                            
                            );
                      },
                    ),
                  ),
                     
                    ],
                  ),
                child: Container(
              decoration: BoxDecoration(
                color: backgroundColorChanger,
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width*0.75,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      // here must be a change on the color depends on the selected task icon
                      border: Border.all(color: ChangeThemeScreen.isDarkTheme?Colors.white : todoListItemColor,style: BorderStyle.solid,width: 1),
                    ),
                    child: todoListItemIcon,
                  ),
                  PopupMenuButton(
                    padding: const EdgeInsets.all(2),
                    enabled: true,
                    icon: Icon(Icons.more_vert,color: ChangeThemeScreen.isDarkTheme?Colors.white : todoListItemColor,size: 26,),
                    color: ChangeThemeScreen.isDarkTheme ? Colors.grey[700] : Colors.white,
                    itemBuilder: (context){
              return [
                PopupMenuItem(
                  child: MenuItemButton(
                    leadingIcon: Icon(Icons.info,color: ChangeThemeScreen.isDarkTheme?Colors.white : todoListItemColor,size: 26,),
                    child: Text("Info",
                     style: TextStyle(fontSize: 12,color: ChangeThemeScreen.isDarkTheme?Colors.white:Colors.black),),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TodoListDetalis(index)));
                    },
                    ),
                  ),
                PopupMenuItem(
                  child: MenuItemButton(
                    leadingIcon: Icon(Icons.delete,color: ChangeThemeScreen.isDarkTheme?Colors.white : todoListItemColor,size: 26,),
                    child: Text("Delete",
                    style: TextStyle(fontSize: 12,color: ChangeThemeScreen.isDarkTheme?Colors.white:Colors.black),),
                    onPressed: () {
                      setState(() {
                        AddingTodoListItem.todoWidgets.removeAt(index);
                        todoItems.clear();
                      });
                      fToast.showToast(
                            toastDuration: const Duration(seconds: 2),
                            child: Container(
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ChangeThemeScreen.isDarkTheme ? Colors.grey[700] : Colors.white,
                              ),
                              child: Text("Deleted..",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14,
                              color: ChangeThemeScreen.isDarkTheme ? Colors.white : Colors.black,),),
                            ),
                            
                            );
                    },
                    )
                ),
              ];
            }
          ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AddingTodoListItem.todoWidgets[index],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 32,color: drawerColorChanger),),
                      Text('${todoItems.length} items',style: TextStyle(color: ChangeThemeScreen.isDarkTheme?Colors.white.withOpacity(0.7) :Colors.grey.withOpacity(0.7),fontSize: 16),),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Text('${((checkedItems/todoItems.length)*100).toStringAsFixed(0)}%',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: drawerColorChanger),),
                      LinearPercentIndicator(
                        barRadius: const Radius.circular(10),
                        percent: checkedItems/todoItems.length,
                        animation: true,
                        alignment: MainAxisAlignment.start,
                        width: MediaQuery.of(context).size.width*0.65,
                        lineHeight: 15,
                        progressColor: ChangeThemeScreen.isDarkTheme?Colors.white : todoListItemColor,
                        backgroundColor: Colors.grey.withOpacity(0.4),
                      ),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                ],
              ),
              ),
              
            ),
                ),
              ),
              );
            
          },
          // this parameter can set the height, and other options in the Carousel... like the autoplay for example
          options: CarouselOptions(height: 300,
          autoPlay: false,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          ),
          ),
      ),


      //  drawer
      drawer: Drawer(
        backgroundColor: backgroundColorChanger,
        child: ListView(
          children: <Widget>[
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.doc("userNames/${_currentUser!.uid}").snapshots(),
              builder: (context,snapshot){
                final userName = snapshot.data;
                if(!snapshot.hasData){
                  return const UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.transparent),
                  accountName: Text("Loading..",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.transparent),),
                  accountEmail: Text(""), 
                  );
                }
                
                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  currentAccountPicture: CircleAvatar(
                    radius: 40,
                    backgroundImage: isPath? Image.file(image).image : const AssetImage("asset/default.png"),
                  ),
                  accountName: Text(userName!['userName'],
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: drawerColorChanger),),
                  accountEmail: const Text(""),
                  // currentAccountPicture: Image.network("https://images.app.goo.gl/N7KTtKsjgJrdee887"),
                  );
              }
              ),
            
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const AccountDetails()));
              },
              child: ListTile(
                leading: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: const Icon(Icons.person,color: Colors.white,size: 26,),
                ),
                title: Text("My Account",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: drawerColorChanger),),
                trailing: const Icon(Icons.arrow_forward_ios,size: 20,color: Colors.grey,),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=>ChangeThemeScreen()));
              },
              child: ListTile(
                leading: const Icon(Icons.color_lens,color: Colors.grey,),
                title: Text("Change Theme",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: drawerColorChanger),),
                trailing: const Icon(Icons.arrow_forward_ios,size: 20,color: Colors.grey,),
              ),
            ),
            GestureDetector(
              onTap: () {
                logoutDialog();
              },
              child: ListTile(
                leading: const Icon(Icons.logout,color: Colors.grey,size: 26,),
                title: Text("Log out",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: drawerColorChanger),),
                trailing: const Icon(Icons.arrow_forward_ios,size: 20,color: Colors.grey,),
              ),
            ),
          ],
        ),
      ),


      // the action button
      // here to set the position of the floating action button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          isExpanded? CircleList(
          innerCircleColor: backgroundColorChanger,
          outerCircleColor: backgroundColorChanger,
          rotateMode: RotateMode.onlyChildrenRotate,
          showInitialAnimation: true,
          children: [
            IconButton(
            icon: Icon(Icons.run_circle_outlined,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.green[300],size: 50,),
            onPressed: () {
              title = "Sports";
              Navigator.push(context,
              MaterialPageRoute(builder: (context)=>AddingTodoListItem(title)));
            
            },
          ),
          IconButton(
            icon: Icon(Icons.book,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.red[100],size: 50,),
            onPressed: () {
              title = "Read";
              Navigator.push(context,
              MaterialPageRoute(builder: (context)=>AddingTodoListItem(title)));
              
            },
          ),
          IconButton(
            icon: Icon(Icons.games,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.blue[200],size: 50,),
            onPressed: () {
              title = "Games";
              Navigator.push(context,
              MaterialPageRoute(builder: (context)=>AddingTodoListItem(title)));
              
            },
          ),
          IconButton(
            icon: Icon(Icons.music_note,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.brown[200],size: 50,),
            onPressed: () {
              title = "Music";
              Navigator.push(context,
              MaterialPageRoute(builder: (context)=>AddingTodoListItem(title)));
            },
          ),
          IconButton(
            icon: Icon(Icons.cases_sharp,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.blueGrey[400],size: 50,),
            onPressed: () {
              title = "Work";
              Navigator.push(context,
              MaterialPageRoute(builder: (context)=>AddingTodoListItem(title)));
              
            },
          ),
          ]
          // here i wanted to return null but it gave me an eror so i returned this material widget
      ): const Material(),
      
      // animating the container
      AnimatedBuilder(
      animation: _controller, 
      builder: (context,child){
        return Container(
        width: _width.value,
        height: _height.value,
        decoration: BoxDecoration(
          boxShadow:<BoxShadow>[
            BoxShadow(
              blurRadius: 30,
              spreadRadius: -10,
              color: _shadow.value,
              offset: const Offset(0, 20),
            ),
          ],
          color: ChangeThemeScreen.isDarkTheme ?Colors.grey[700]: ChangeThemeScreen.selectedTheme,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topRight: const Radius.circular(100),
            topLeft: const Radius.circular(100),
            bottomLeft: Radius.circular(_border.value),
            bottomRight: Radius.circular(_border.value),
          ),
        ),
            child: IconButton(
              onPressed: (){
                if(isExpanded){
                  setState(() {
                    _controller.reverse();
                  });
                }
                else{
                  setState(() {
                    _controller.forward();
                  });
                }
              
            },
            // for the animation
              icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, anim) => RotationTransition(
                turns: child.key == const Key('icon1')
                    ? Tween<double>(begin: 1, end: 0).animate(anim)
                    : Tween<double>(begin: 0, end: 1).animate(anim),
                child: ScaleTransition(scale: anim, child: child),
              ),
          child: isExpanded
              ? const Icon(Icons.keyboard_arrow_down,color: Colors.white,size: 24, key: Key('icon1'))
              : const Icon(Icons.add,color: Colors.white,size: 24,
                  key: Key('icon2'),
                )),
            ),
            
          );
      }
      ),
        ],
      ),
    );
  }
}