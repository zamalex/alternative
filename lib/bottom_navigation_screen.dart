
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/auth_screen.dart';
import 'package:translatorclient/colors.dart';
import 'package:translatorclient/data/service_locator.dart';
import 'package:translatorclient/home_screen.dart';
import 'package:translatorclient/navigation_provider.dart';
import 'package:translatorclient/search_screen.dart';
import 'package:translatorclient/settings_screen.dart';

import 'account_screen.dart';
import 'data/repository/auth_repo.dart';
import 'model/auth_response.dart';

class BottomNavigationScreen extends StatefulWidget {
   BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  final List<Widget> screens = [
    //HomeScreen(),
    SearchScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldGrey,
      appBar: AppBar(
        elevation: .5,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Consumer<NavigationProvider>(builder: (context, value, child) {
        return Text(value.title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),);
      },),),

      body: Column(children: [
        Expanded(child: screens[Provider.of<NavigationProvider>(context, listen: true).selectedTab]),
        Container(

          margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.black),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //NavigationItem(index: /*0*/,title: 'home'.tr(),image: 'assets/images/homme.png',),
            NavigationItem(index:0 /*1*/,title: 'home'.tr(),image: 'assets/images/homme.png',),
            NavigationItem(index: 1/*2*/,title: 'my_account'.tr(),image: 'assets/images/profile.png',),

          ],
        ),
        )
      ],),
    );
  }
}
class NavigationItem extends StatelessWidget {
  NavigationItem({Key? key,this.index=0,this.title='',this.image=''}) : super(key: key);
  int index;
  String title;
  String image;
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: (){
            if(index==1&&!sl.isRegistered<AuthResponse>()){

              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => AuthScreen()),
              );
              return;
            }
            Provider.of<NavigationProvider>(context, listen: false).selectTab(index, title);
          },
          child: Container(child:
          Column(children: [
            Image.asset(image,color: value.selectedTab==index?kPrimaryColor:Colors.white,width: 20,),
            SizedBox(height: 2,),
            Visibility(
                visible: index==value.selectedTab,
                child: CircleAvatar(radius: 3,backgroundColor: kPrimaryColor,))
          ],)
            ,),
        );
      },
    );
  }
}
