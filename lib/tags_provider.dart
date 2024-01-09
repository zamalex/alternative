import 'package:flutter/cupertino.dart';

class TagsProvider extends ChangeNotifier{

  List tags = [];


  void addTag(String title){
    tags.add(title);

    notifyListeners();
  }

  void removeTag(int index){
    tags.removeAt(index);
    notifyListeners();
  }
}