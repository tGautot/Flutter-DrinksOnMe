import 'drink_widget.dart';
import 'add_drink_widget.dart';
import 'drink.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_admob/firebase_admob.dart';

class HomeWidget extends StatefulWidget{

  @override
  State createState() {
    return HomeWidgetState();
  }
}

class HomeWidgetState extends State<HomeWidget> with WidgetsBindingObserver{

  static final String DRINKS_JSON_KEY = 'DRINKS_JSON_KEY';

  bool isLoading = false;
  bool adsReady = false;

  List<DrinkWidget> allDrinkWidgets;

  String searchText = '';

  BannerAd bannerAd;
  int bannerAdSizeHeight;

  @override
  void initState() {
    allDrinkWidgets = List();
    loadData();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Calling function to retrieve data about drinks and handling
  /// state
  void loadData() async{
    await loadDrinksData();
    loadAds();
    setState(() {
      isLoading = false;
    });
  }

  void loadAds() async{

    print('loadAds started');

    await FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-4219242809085337~8104554253');

    print('Got instance');

    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['drinks', 'group', 'party'],
      childDirected: false,// or MobileAdGender.female, MobileAdGender.unknown
    );

    print('Got target info');

    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-4219242809085337/2556235171',
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );

    print('Got bannerAd');

    bannerAdSizeHeight = AdSize.banner.height;

    bannerAd..load()..show(
      anchorOffset: 0,
      anchorType: AnchorType.bottom,
    );

    print('loadAds finished');

  }

  /// Observer to check for applifecycle changes,
  /// If the app is paused, saves the current drink in local storage
  /// Otherwise does nothing
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.paused:
        saveDrinksData();
        break;
    }
  }

  /// Handles the insertion of a new drink in the list
  /// Schedules a new screen to be drawn
  void onNewDrink(Drink newDrink){
    bool alreadyExists = false;

    DrinkWidget drinkWidget;
    for(int i = 0; i < allDrinkWidgets.length; i++){
      drinkWidget = allDrinkWidgets[i];
      if(drinkWidget.drinkName == newDrink.name){
        alreadyExists = true;
        Fluttertoast.showToast(
            msg: 'You already have a drink named ${newDrink.name}');
        break;
      }
    }

    if(!alreadyExists){
      allDrinkWidgets.add(DrinkWidget.fromDrink(newDrink));
      saveDrinksData(); // Let it run async
      setState(() {});
    }

  }

  /// Handles the saving to local storage of drinks data as JSON file
  void saveDrinksData() async{
    SharedPreferences _sp = await SharedPreferences.getInstance();

    String drinksJson = generateDrinksJson();

    await _sp.setString(DRINKS_JSON_KEY, drinksJson);
  }

  /// Generates the JSON file representing the data
  /// for the current drinks
  String generateDrinksJson(){

    String output = '{"drinks":[';
    DrinkWidget drinkWidget;
    for(int i = 0; i < allDrinkWidgets.length; i++){
      if(i != 0){
        output += ','; // Different items in list must be separated by comas
        // Not the last one though
      }
      drinkWidget = allDrinkWidgets[i];
      output += drinkWidget.getDrink().toJson();
    }

    output += ']}';

    return output;
  }

  /// Retrieves drinks data from local storage, creates all widgets
  /// an sorts them
  Future<void> loadDrinksData() async{
    SharedPreferences _sp = await SharedPreferences.getInstance();
    String drinksJson = _sp.getString(DRINKS_JSON_KEY);


    List<Drink> drinks = List();

    if(drinksJson == null || drinksJson.trim() == "") {
      Drink baseDrink = Drink('Water', 'water_256.png', 1);
      drinksJson = '{"drinks":[${baseDrink.toJson()}]}';
    }

    Map<String, dynamic> drinksData = json.decode(drinksJson);

    List<dynamic> drinksUnconverted = drinksData['drinks'];

    for(int i = 0; i < drinksUnconverted.length; i++){
      String name = drinksUnconverted[i]['name'];
      String iconPath = drinksUnconverted[i]['iconPath'];
      int count = drinksUnconverted[i]['count'];

      drinks.add(Drink(name, iconPath, count));
    }

    for(int i = 0; i < drinks.length; i++){
      Drink drink = drinks[i];
      allDrinkWidgets.add(DrinkWidget.fromDrink(drink));
    }
  }

  /// Creates and returns all the drink widgets that should be shown to
  /// the screen for the current state in the right order (ordered by name)
  List<Widget> getDrinkWidgetsList() {
    List<DrinkWidget> shownDrinkWidgets = List();
    DrinkWidget drinkWidget;
    for(int i = 0; i < allDrinkWidgets.length; i++){
      drinkWidget = allDrinkWidgets[i];
      print('drink widget $i has lowercased name: ${drinkWidget.drinkName.toLowerCase()}, searchtext is ${searchText.toLowerCase()}');
      if(searchText == '' ||
          drinkWidget.drinkName.toLowerCase().contains(searchText.toLowerCase())){
        shownDrinkWidgets.add(drinkWidget);
      }
    }

    shownDrinkWidgets.sort((a,b) => a.drinkName.compareTo(b.drinkName));

    List<Widget> out = List();

    for(int i = 0; i < shownDrinkWidgets.length; i++){
      out.add(
        AnimatedContainer(
          key: ValueKey(shownDrinkWidgets[i].drinkName),
          duration: Duration(seconds: 1),
          child: shownDrinkWidgets[i],
        )
      );
    }

    out.add(AddDrinkWidget(onNewDrink, searchText));

    return out ;
  }

  /// If the user enters a some search text, the variable will be set here
  /// and a new state is scheduled
  void handleSearchStringChange(String s) {
    setState(() {
      searchText = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth, screenHeight;
    screenWidth  = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Drinks'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: screenWidth,
            height: screenHeight,
            padding: EdgeInsets.only(top: 50),
            child: GridView.count(
              crossAxisCount: 2,
              children: getDrinkWidgetsList(),
            ),
          ),
          isLoading
          ? Center(
            child: Container(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
              ),
            ),
          )
          : Container(),
          Container(
            padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
            alignment: Alignment.topCenter,
            width: screenWidth,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                prefixIcon: Icon(
                  Icons.search,
                ),
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              onChanged: (s){
                handleSearchStringChange(s);
              },
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ],
      )
    );
  }

}