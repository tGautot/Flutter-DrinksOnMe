import 'DrinkRadioGroupWidget.dart';
import 'drink.dart';

import 'package:flutter/material.dart';

class AddDrinkWidget extends StatelessWidget{

  Function(Drink drink) onNewDrink;
  final String initialName;

  AddDrinkWidget(this.onNewDrink, this.initialName);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth/2,
      height: screenWidth/2,
      padding: EdgeInsets.only(right: 20, top: screenWidth/8),
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Colors.grey,
              size: 50,
            ),
            onPressed: (){
              print('press recorded');
              openNewDrinkDialog(context);
            },
          )
        ],
      ),
    );
  }

  void openNewDrinkDialog(BuildContext ctx) async{
    int CANCEL = 0;
    int CONTINUE = 1;

    NewDrinkAlertDialogContentWidget drinkAlertDialogContentWidget =
      NewDrinkAlertDialogContentWidget(initialName);

    int val = await showDialog(
      context: ctx,
      builder: (context){
        return AlertDialog(
          title: Text(
            'New Drink',
          ),
          content: Container(
            child: drinkAlertDialogContentWidget,
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop(CANCEL);
              },
            ),
            new FlatButton(
              child: new Text("Continue"),
              onPressed: () {
                Navigator.of(context).pop(CONTINUE);
              },
            ),
          ],
        );
      }
    );

    if(val == CANCEL) return;

    onNewDrink(
      Drink(
        drinkAlertDialogContentWidget.currentName,
        drinkAlertDialogContentWidget.drinkRadioGroupWidget.state.getChosenIconPath(),
        0
      )
    );
  }
}

class NewDrinkAlertDialogContentWidget extends StatelessWidget{
  
  String initialName;
  String currentName;
  TextEditingController nameController;
  DrinkRadioGroupWidget drinkRadioGroupWidget;
  
  NewDrinkAlertDialogContentWidget(this.initialName){
    currentName = initialName;
    nameController = TextEditingController(text: initialName);
    drinkRadioGroupWidget = DrinkRadioGroupWidget(3);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Name',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Drink\'s name',
              hintStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            textCapitalization: TextCapitalization.sentences,
            onChanged: (s){
              currentName = s;
            },
            maxLength: 40,
          ),
          
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              'Icon',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          
          drinkRadioGroupWidget,
          
        ],
      ),
    );
  }
}