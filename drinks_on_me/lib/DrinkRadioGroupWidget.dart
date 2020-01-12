import 'package:flutter/material.dart';

class DrinkRadioGroupWidget extends StatefulWidget{

  final int crossAxisWidgetCount;
  DrinkRadioGroupWidgetState state;

  DrinkRadioGroupWidget(this.crossAxisWidgetCount);

  @override
  State createState() {
    state = DrinkRadioGroupWidgetState();
    return state;
  }
}

class DrinkRadioGroupWidgetState extends State<DrinkRadioGroupWidget>{

  int radioGroupValue = 0;
  List<String> iconPaths = [
    'img/water_256.png',
    'img/cola_256.png',
    'img/orange_juice_256.png',
    'img/blond_beer_256.png',
    'img/brown_beer_256.png',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: widget.crossAxisWidgetCount,
      children: getRadioIcons(context, widget.crossAxisWidgetCount),

    );
  }

  List<Widget> getRadioIcons(BuildContext ctx, int crossAxisWidgetCount){
    double width = MediaQuery.of(ctx).size.width;

    List<Widget> radioIcons = List();

    print('there are ${iconPaths.length}, icon paths');
    for(int i = 0; i < iconPaths.length; i++){
      print(i);
      radioIcons.add(
          Container(
            padding: EdgeInsets.all(0),
            width: width/crossAxisWidgetCount+1,
            height: width/(2*crossAxisWidgetCount+4),
            child: Row(
              children: <Widget>[
                Container(
                  width: 30,
                  height: 30,
                  child: Radio(
                    value: i,
                    groupValue: radioGroupValue,
                    onChanged: (value) {
                      setState(() { radioGroupValue = value; });
                    },
                  ),
                ),
                Container(
                  width: width/(3*crossAxisWidgetCount),
                  height: width/(3*crossAxisWidgetCount+2),
                  child: FlatButton(
                    onPressed: (){
                      setState(() { radioGroupValue = i; });
                    },
                    child: Image.asset(iconPaths[i]),
                    padding: EdgeInsets.all(0),
                    splashColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          )
      );
    }
    print('build ${radioIcons.length} radion icons');

    return radioIcons;
  }

  String getChosenIconPath(){
    String smallIconPath = iconPaths[radioGroupValue];
    return smallIconPath.replaceAll('256', '512');
  }
}