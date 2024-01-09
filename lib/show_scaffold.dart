import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context,String message){
  Future.delayed(Duration.zero).then((value){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),backgroundColor: Colors.red,));
  });
}

void showSuccessMessage(BuildContext context,String message){
  Future.delayed(Duration.zero).then((value){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),backgroundColor: Colors.green,));

  });
}

