import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';

import '../model/auth_response.dart';
import 'http/urls.dart';
import 'service_locator.dart';

class PreferenceUtils{

   SharedPreferences? sharedPreferences;


  initPrefs()async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  saveCart(String cart)async{
    if(sharedPreferences==null)
      await initPrefs();


    await sharedPreferences!.setString('cart',cart);
  }

   Future<String?> readCart()async{
     if(sharedPreferences==null)
       await initPrefs();

     String? s = sharedPreferences!.getString('cart');

     if(s==null)
       return null;


     return s;
   }

  saveUser(AuthResponse loginModel)async{
    if(sharedPreferences==null)
      await initPrefs();

    if(sl.isRegistered<AuthResponse>())
      sl.unregister<AuthResponse>();
    sl.registerSingleton(loginModel);

    Url.TOKEN = loginModel.token!;

    await sharedPreferences!.setString('user',jsonEncode(loginModel.toJson()));
  }
  
  Future<AuthResponse?> readUser()async{
    if(sharedPreferences==null)
       await initPrefs();

    String? s = sharedPreferences!.getString('user');

    if(s==null)
      return null;


    return AuthResponse.fromJson(jsonDecode(s));
  }



  logout(){
    if(sl.isRegistered<AuthResponse>())
    sl.unregister<AuthResponse>();
    Url.TOKEN='';
    sharedPreferences!.remove('user');
  }
}