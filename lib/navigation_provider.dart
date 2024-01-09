import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';

class NavigationProvider extends ChangeNotifier{

  int selectedTab = 0;
  String title = 'home'.tr();

  void selectTab(int index,String title){
      selectedTab = index;
      this.title = title;

      notifyListeners();
  }

}