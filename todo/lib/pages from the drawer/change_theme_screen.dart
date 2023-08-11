import 'package:flutter/material.dart';
import 'package:todo/landing_page_selector.dart';

// this screen is for changging the theme of the app
// ignore: must_be_immutable
class ChangeThemeScreen extends StatefulWidget {
  ChangeThemeScreen({super.key});
  // indicator for the dark theme
  static bool isDarkTheme = false;
  // this is a list to indicate which theme is choosen and set a blue border for the selected theme contianer 
  static var selectedThemeList = [true,false,false,false,false,false,false];
  // this is a border to indicate the selected theme
  Border selectedThemeBorder = Border.all(color: Colors.blue,style: BorderStyle.solid,width: 3);
  // this is a list of all the themes
  static var themeColorList = [Colors.red[100],Colors.grey[900],Colors.brown[200],Colors.green[200],Colors.deepPurple[200],Colors.cyan[200],Colors.blueGrey[300]];
  // this is the names of the themes
  var colorsNamesList = ["Pink","Dark","Brown","Green","Purple","Cyan","Blue-gray"];
  static Color selectedTheme = Colors.red[100]!;
  @override
  State<ChangeThemeScreen> createState() => _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends State<ChangeThemeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !ChangeThemeScreen.isDarkTheme ? Colors.white: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: ChangeThemeScreen.selectedTheme,
        leading: IconButton(
          onPressed: (){
            // here i didnt use pop so the color changes when you leave the screen
            // i did a push to the selector because the provider can work and navigate me back to the sign in screen if the user want to log out
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SelectorWidget()), (route) => false);
          },
          icon: const Icon(Icons.arrow_back_ios,size: 24,color: Colors.white,),
          ),
        title: const Text("Change Theme",
        style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400),),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: GridView.builder(
          itemCount: ChangeThemeScreen.themeColorList.length,
          physics: const NeverScrollableScrollPhysics(),
          cacheExtent: 3,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context,index){
            return GestureDetector(
              onTap: () {
                if(widget.colorsNamesList[index]!= "Dark"){
                  setState(() {
                    ChangeThemeScreen.selectedThemeList = List.generate(7, (index) => false);
                    ChangeThemeScreen.selectedThemeList[index] = true;
                    ChangeThemeScreen.isDarkTheme = false;
                    ChangeThemeScreen.selectedTheme = ChangeThemeScreen.themeColorList[ChangeThemeScreen.selectedThemeList.indexOf(true)]!;
                    });
                  }
                  else{
                    setState(() {
                      ChangeThemeScreen.selectedThemeList = List.generate(7, (index) => false);
                      ChangeThemeScreen.selectedThemeList[index] = true;
                      ChangeThemeScreen.isDarkTheme = true;
                      ChangeThemeScreen.selectedTheme = ChangeThemeScreen.themeColorList[ChangeThemeScreen.selectedThemeList.indexOf(true)]!;
                    });
                  }
              },
              child: Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.width*0.04),
              decoration: BoxDecoration(
                color: ChangeThemeScreen.themeColorList[index],
                borderRadius: BorderRadius.circular(10),
                border: ChangeThemeScreen.selectedThemeList[index]? widget.selectedThemeBorder: null,
                ),
                child: Center(
                  child: Text(widget.colorsNamesList[index],
                  style: const TextStyle(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.white),),
                ),
              ),
            );
          }
          ),
        ),
    );
  }
}