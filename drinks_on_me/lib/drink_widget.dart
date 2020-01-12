import 'drink.dart';

import 'package:flutter/material.dart';

class DrinkWidget extends StatefulWidget{

  String drinkName, drinkIconPath;
  int drinkCount;

  DrinkWidget(this.drinkName, this.drinkIconPath, this.drinkCount);

  DrinkWidget.fromDrink(Drink drink){
    this.drinkName  = drink.name;
    this.drinkIconPath  = drink.iconPath;
    this.drinkCount = drink.count;
  }

  Drink getDrink(){
    return Drink(drinkName, drinkIconPath, drinkCount);
  }

  @override
  State createState() {
    return DrinkWidgetState();
  }
}

class DrinkWidgetState extends State<DrinkWidget>{

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth/2,
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            width: screenWidth/3.5,
            height: screenWidth/3.5,
            padding: EdgeInsets.only(bottom: 10, left: 7),
            child: Image.asset(widget.drinkIconPath),
          ),
          Text(
            widget.drinkName,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.remove,
                  color: Colors.black87,
                ),
                onPressed: (){
                  handlePress(-1);
                },
              ),
              Text(
                widget.drinkCount.toString(),
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.black87,
                ),
                onPressed: (){
                  handlePress(1);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void handlePress(int val){
    if(widget.drinkCount+val < 0) return;
    setState(() {
      widget.drinkCount+=val;
    });
  }
}