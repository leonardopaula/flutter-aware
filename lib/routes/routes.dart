import 'package:flutter/widgets.dart';
import 'package:aware/screens/informationPageState.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
      MInformationPage.routeName: (BuildContext context) =>
          new MInformationPage(title: "MInformationPage"),
    };