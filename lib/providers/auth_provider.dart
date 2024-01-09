import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:translatorclient/data/repository/auth_repo.dart';
import 'package:translatorclient/data/service_locator.dart';
import 'package:translatorclient/model/my_documents_response.dart';

import '../model/notifications_model.dart';


class AuthProvider extends ChangeNotifier{

  bool isLoading=false;



  List<MyFiles> myDocuments= [];


  Future<Map> login(String phone,String password,String type)async{
    isLoading = true;
    notifyListeners();

    Map response= await sl<AuthRepository>().login(phone,password,type);

    isLoading = false;
    notifyListeners();

    return response;
  }



  Future<Map> register(Map<String,String> body)async{
    isLoading = true;
    notifyListeners();

    Map response= await sl<AuthRepository>().register(body);

    isLoading = false;
    notifyListeners();

    return response;
  }

  Future<Map> updateProfile(Map<String,String> body)async{
    isLoading = true;
    notifyListeners();

    Map response= await sl<AuthRepository>().updateProfile(body);

    isLoading = false;
    notifyListeners();

    return response;
  }

  Future<Map> updateAvatar(File image)async{
    isLoading = true;
    notifyListeners();

    Map response= await sl<AuthRepository>().updateUserAvatar(image);

    isLoading = false;
    notifyListeners();

    return response;
  }

  Future<Map> getProfile()async{
    isLoading = true;
    notifyListeners();

    Map response= await sl<AuthRepository>().getProfile();

    isLoading = false;
    notifyListeners();

    return response;
  }

  String terms='';

  List<NotificationData> notifications=[];
  int page=1;
  int total=-1;

  Future<Map> getTerms()async{
    isLoading = true;
    notifyListeners();

    Map response= await sl<AuthRepository>().getTerms();

    terms = response['data'];
    isLoading = false;
    notifyListeners();

    return response;
  }


  Future<Map> getMyDocuments()async{
    isLoading = true;
    notifyListeners();

    Map response= await sl<AuthRepository>().getMyDocuments();

    isLoading = false;

    myDocuments = response['data'];
    notifyListeners();

    return response;
  }




  Future getNotifications(bool init)async{

    if(total==notifications.length)
      return;
    if(init)
    {
      page=1;
      total=-1;
      notifications.clear();
    }
    else{
      page++;
    }
    isLoading = true;
    notifyListeners();


    Map response= await sl<AuthRepository>().getNotifications(page);

    notifications.addAll(response['data'] as List<NotificationData>);
    isLoading = false;



    notifyListeners();

  }



}