import 'AppLocalizations.dart';
import 'Home.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
      ],
      localizationsDelegates: [
        // CLASS THAT WILL BE ADDED LATER
        // Class that gets translation from the json files
        AppLocalizations.delegate,
        // Built-in localization for basic in-app text
        GlobalMaterialLocalizations.delegate,
        // Handles text directions
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales){

        for(var supportedLocale in supportedLocales){
          if(locale.languageCode == supportedLocale.languageCode){
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomeWidget(),
    );
  }
}

