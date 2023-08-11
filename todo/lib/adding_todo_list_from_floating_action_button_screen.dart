import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/landing_page_selector.dart';
import 'package:todo/pages%20from%20the%20drawer/change_theme_screen.dart';

// ignore: must_be_immutable
class AddingTodoListItem extends StatefulWidget {
  late String title;
  static  List<String> sports = [];
  static List<String> read = [];
  static List<String> games = [];
  static List<String> music = [];
  static List<String> work = [];

  static List<bool> sportsCheckboxValue = [];
  static List<bool> readCheckboxValue = [];
  static List<bool> gamesCheckboxValue = [];
  static List<bool> musicCheckboxValue = [];
  static List<bool> workCheckboxValue = [];
  
  // this list is used for the Carousel_slider builder to build the correct todo list item and the number of them 
  static List<String> todoWidgets = [];
  AddingTodoListItem(this.title,{super.key});

  @override
  State<AddingTodoListItem> createState() => _AddingTodoListItemState();
}

class _AddingTodoListItemState extends State<AddingTodoListItem> {
  // this controller is for th textField to add an item in the item variable
  TextEditingController todoItemController = TextEditingController();
  // this list is to add an item in the listView builder
  late List<String> items = widget.title == "Sports" ? AddingTodoListItem.sports
            :widget.title == "Read"? AddingTodoListItem.read
            :widget.title == "Games"? AddingTodoListItem.games
            :widget.title == "Music"? AddingTodoListItem.music
            :AddingTodoListItem.work;
  
  // to set a color for the page same as the color of the selected item
  late Color itemColor = (widget.title == "Sports" ? Colors.green[300]
            :widget.title == "Read"? Colors.red[100]
            :widget.title == "Games"? Colors.blue[200]
            :widget.title == "Music"? Colors.brown[200]
            :Colors.blueGrey[400]) as Color;
  // to set an icon for the page same as the icon of the selected item
  late Icon itemIcon = widget.title == "Sports" ? Icon(Icons.run_circle_outlined,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.green[300],size: 30,)
            :widget.title == "Read"? Icon(Icons.book,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.red[100],size: 30,)
            :widget.title == "Games"? Icon(Icons.games,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.blue[200],size: 30,)
            :widget.title == "Music"? Icon(Icons.music_note,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.brown[200],size: 30,)
            :Icon(Icons.cases_sharp,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.blueGrey[400],size: 30,);

  // list of bool values for the checkbox in details screen

  late List<bool> checkedValues = widget.title == "Sports" ? AddingTodoListItem.sportsCheckboxValue
            :widget.title == "Read"? AddingTodoListItem.readCheckboxValue
            :widget.title == "Games"? AddingTodoListItem.gamesCheckboxValue
            :widget.title == "Music"? AddingTodoListItem.musicCheckboxValue
            :AddingTodoListItem.workCheckboxValue;

  // this instance is for the toast message so you can change its appearance
  late FToast fToast;
  
    
  @override
  void initState() {
    super.initState();
    // this is for the toast message
    fToast = FToast();
    fToast.init(context);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChangeThemeScreen.isDarkTheme? Colors.grey[900]: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios,size: 24,
          color: ChangeThemeScreen.isDarkTheme?Colors.white : itemColor,
          ),
        ),
        title: Text(widget.title,
        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,
        color: ChangeThemeScreen.isDarkTheme?Colors.white : itemColor,
        ),),
        actions: [
          IconButton(
            onPressed: () async{
              // TodoListSharedPrefs.sharedPref = await SharedPreferences.getInstance();
              if (widget.title == "Sports"){
                if(!AddingTodoListItem.todoWidgets.contains("Sports")){
                  AddingTodoListItem.todoWidgets.add("Sports");
                  // await TodoListSharedPrefs.setTodoWidget("todoWidgets",AddingTodoListItem.todoWidgets);
                  // await TodoListSharedPrefs.setTodoWidget("sports", items);
                }
              }
              else if (widget.title == "Read"){
                
                if(!AddingTodoListItem.todoWidgets.contains("Read")){
                  AddingTodoListItem.todoWidgets.add("Read");
                  // await TodoListSharedPrefs.setTodoWidget("todoWidgets",AddingTodoListItem.todoWidgets);
                  // await TodoListSharedPrefs.setTodoWidget("read", items);
                }
              }
              else if (widget.title == "Games"){
                
                if(!AddingTodoListItem.todoWidgets.contains("Games")){
                  AddingTodoListItem.todoWidgets.add("Games");
                  // await TodoListSharedPrefs.setTodoWidget("todoWidgets",AddingTodoListItem.todoWidgets);
                  // await TodoListSharedPrefs.setTodoWidget("games", items);
                }
              }
              else if (widget.title == "Music"){
                
                if(!AddingTodoListItem.todoWidgets.contains("Music")){
                  AddingTodoListItem.todoWidgets.add("Music");
                // await TodoListSharedPrefs.setTodoWidget("todoWidgets",AddingTodoListItem.todoWidgets);
                  // await TodoListSharedPrefs.setTodoWidget("music", items);
                }
              }
              else{
                
                if(!AddingTodoListItem.todoWidgets.contains("Work")){
                  AddingTodoListItem.todoWidgets.add("Work");
                  // await TodoListSharedPrefs.setTodoWidget("todoWidgets",AddingTodoListItem.todoWidgets);
                  // await TodoListSharedPrefs.setTodoWidget("work", items);
                }
              }
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SelectorWidget()), (route) => false);
            },
            icon: Icon(Icons.check,size: 24,
            color: ChangeThemeScreen.isDarkTheme?Colors.white : itemColor,
            ),
            ),
        ],
      ),

      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // i wrapped it in expanded widget so the textfield in the bottom stays where it is and dont go gown as the list grows
            Expanded(
              child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                if(items.isEmpty){
                  return const Text("add an item");
                }
                else{
                  return Dismissible(
                    key: Key(items[index]),
                    background: Container(
                      color: Colors.red,
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        items.removeAt(index);
                        checkedValues.removeAt(index);
                      });
                      fToast.showToast(
                        gravity: ToastGravity.TOP,
                            toastDuration: const Duration(seconds: 2),
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ChangeThemeScreen.isDarkTheme ? Colors.grey[700] : Colors.white,
                              ),
                              child: Text("Item deleted..",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14,
                              color: ChangeThemeScreen.isDarkTheme ? Colors.white : Colors.black,),),
                            ),
                            
                            );
                    },
                    child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    leading: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: ChangeThemeScreen.isDarkTheme?Colors.white : itemColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  title: Text(items[index],
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.black),),
                )
                    );
                   
                }
              },
            ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(style: BorderStyle.solid,width: 1,color: Colors.grey.withOpacity(0.4)))
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(5,0,5,5),
                  child: TextFormField(
                  controller: todoItemController,
                  autofocus: true,
                  style: TextStyle(color: ChangeThemeScreen.isDarkTheme?Colors.white:Colors.black),
                  // here to shange the value og the text field controller so the button changes its color depending on the text..
                  onChanged: (value) {
                    setState(() {
                      
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: itemIcon,
                  hintText: "add a task",
                  hintStyle: TextStyle(color:ChangeThemeScreen.isDarkTheme?Colors.white.withOpacity(0.4) : Colors.grey),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(5),
                  decoration:BoxDecoration(
                    color: todoItemController.text == ''? Colors.grey.withOpacity(0.4):
                    ChangeThemeScreen.isDarkTheme?Colors.white : itemColor,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: IconButton(
                  icon: Icon(Icons.arrow_upward,color: ChangeThemeScreen.isDarkTheme?Colors.black: Colors.white,size: 20,),
                  onPressed: (){
                    if(todoItemController.text != ''){
                      setState(() {
                      items.add(todoItemController.text);
                      todoItemController.text = '';
                      checkedValues.add(false);
                    });
                    }
                  },
                ),
                ),
                  border: const OutlineInputBorder(borderSide:BorderSide.none),
                  ),
                ),
                ),
              ],
            ),
          ],
      ),
    );
  }
}