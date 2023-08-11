import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:todo/adding_todo_list_from_floating_action_button_screen.dart';
import 'package:todo/landing_page_selector.dart';
import 'package:todo/pages%20from%20the%20drawer/change_theme_screen.dart';

// ignore: must_be_immutable
class TodoListDetalis extends StatefulWidget {
  late int index;
  TodoListDetalis(this.index, {super.key});

  @override
  State<TodoListDetalis> createState() => _TodoListDetalisState();
}

class _TodoListDetalisState extends State<TodoListDetalis> with SingleTickerProviderStateMixin{
  late Icon todoListItemIcon = AddingTodoListItem.todoWidgets[widget.index] == "Sports"? Icon(Icons.run_circle_outlined,color: ChangeThemeScreen.isDarkTheme?Colors.white: Colors.green[300],size: 30,)
            :AddingTodoListItem.todoWidgets[widget.index] == "Read"? Icon(Icons.book,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.red[100],size: 30,)
            :AddingTodoListItem.todoWidgets[widget.index] == "Games"? Icon(Icons.games,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.blue[200],size: 30,)
            :AddingTodoListItem.todoWidgets[widget.index] == "Music"? Icon(Icons.music_note,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.brown[200],size: 30,)
            :Icon(Icons.cases_sharp,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.blueGrey[400],size: 30,);

            
            // to set the color for the item
            late Color todoListItemColor = (AddingTodoListItem.todoWidgets[widget.index] == "Sports"? Colors.green[300]
            :AddingTodoListItem.todoWidgets[widget.index] == "Read"? Colors.red[100]
            :AddingTodoListItem.todoWidgets[widget.index] == "Games"? Colors.blue[200]
            :AddingTodoListItem.todoWidgets[widget.index] == "Music"? Colors.brown[200]
            :Colors.blueGrey[400]) as Color;
    Color textColor = ChangeThemeScreen.isDarkTheme? Colors.white:Colors.black;


    // to get the right todo list item 
    late List itemsDetailsList = AddingTodoListItem.todoWidgets[widget.index] == "Sports"? AddingTodoListItem.sports
                    :AddingTodoListItem.todoWidgets[widget.index] == "Read"? AddingTodoListItem.read
                    :AddingTodoListItem.todoWidgets[widget.index] == "Games"? AddingTodoListItem.games
                    :AddingTodoListItem.todoWidgets[widget.index] == "Music"? AddingTodoListItem.music
                    :AddingTodoListItem.work;




    late List<bool> checkboxValue = AddingTodoListItem.todoWidgets[widget.index] == "Sports"? AddingTodoListItem.sportsCheckboxValue
                    :AddingTodoListItem.todoWidgets[widget.index] == "Read"? AddingTodoListItem.readCheckboxValue
                    :AddingTodoListItem.todoWidgets[widget.index] == "Games"? AddingTodoListItem.gamesCheckboxValue
                    :AddingTodoListItem.todoWidgets[widget.index] == "Music"? AddingTodoListItem.musicCheckboxValue
                    :AddingTodoListItem.workCheckboxValue;

    // this variable depends on the checkboxValue that is used in the chackbox
    int checkedItems = 0;
    void getCheckedItmes(){
      for(int i = 0; i<checkboxValue.length;i++){
        if(checkboxValue[i] == true){
          checkedItems++;
          }
        }
    }
    @override
  void initState() {
    getCheckedItmes();

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChangeThemeScreen.isDarkTheme?Colors.grey[900]: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: ChangeThemeScreen.isDarkTheme?Colors.grey[900]: Colors.white,
        leading: IconButton(
          onPressed: (){
            // i used pushAndRemoveUntil instead of just pop is because of the value of the chaecked items get recalculated because i couldnt use the setState method
            // it gave me an error
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SelectorWidget()), (route) => false);
            
          },
          icon: Icon(Icons.arrow_back_ios,size: 24,
          color: ChangeThemeScreen.isDarkTheme?Colors.white : todoListItemColor,
          ),
        ),
      ),
      body: Hero(
        tag: "oneTodoList${widget.index}", 
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Material(
                    color: ChangeThemeScreen.isDarkTheme?Colors.grey[900]: Colors.white,
                    child:SizedBox(
                      height: 220,
                      child: ListView.builder(
                        physics: const RangeMaintainingScrollPhysics(),
                    itemCount: itemsDetailsList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      // this is because of the animation
                      return TweenAnimationBuilder(
                        // here this value begin from 0 to 100 in the duration
                        tween: Tween<double>(begin: 100,end: 0),
                        curve: Curves.easeInBack,
                        duration: Duration(milliseconds: index*400),
                        builder: (context,value,listTile){
                          return Padding(
                            padding: EdgeInsets.only(left: value),
                            // this child is the list tile child that is wrapped in the tween animation
                            child: listTile,
                          );
                        },
                        child: ListTile(
                        leading: Checkbox(
                          activeColor: ChangeThemeScreen.isDarkTheme?Colors.white : todoListItemColor,
                          checkColor: ChangeThemeScreen.isDarkTheme?Colors.black : Colors.white,
                          onChanged: (value) {
                            if(value == true){
                              setState(() {
                                checkboxValue[index] = value!;
                                checkedItems++;
                              });
                            }
                          else{
                            setState(() {
                              checkboxValue[index] = value!;
                              checkedItems--;
                            });
                          }
                        },
                        value: checkboxValue[index],
                        ),
                        title: Text(itemsDetailsList[index],
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: ChangeThemeScreen.isDarkTheme?Colors.white : Colors.black),),
                      ),
                      );
                      
                    }
                    ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AddingTodoListItem.todoWidgets[widget.index],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 32,color: textColor),),
                      Text('${itemsDetailsList.length} items',style: TextStyle(color: ChangeThemeScreen.isDarkTheme?Colors.white.withOpacity(0.7) :Colors.grey.withOpacity(0.7),fontSize: 16),),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Text('${((checkedItems/itemsDetailsList.length)*100).toStringAsFixed(0)} %',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: textColor),),
                      LinearPercentIndicator(
                        barRadius: const Radius.circular(10),
                        percent: checkedItems/itemsDetailsList.length,
                        animation: true,
                        alignment: MainAxisAlignment.start,
                        width: MediaQuery.of(context).size.width*0.9,
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
    );
  }
}