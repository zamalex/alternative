import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/auth_screen.dart';
import 'package:translatorclient/bottom_navigation_screen.dart';
import 'package:translatorclient/data/preferences.dart';
import 'package:translatorclient/data/service_locator.dart';

import 'colors.dart';
import 'navigation_provider.dart';



class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),

      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Material(
        color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.logout,color:Colors.red,size: 60,),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'you_sure_logout'.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            sl<PreferenceUtils>().logout();
                            Provider.of<NavigationProvider>(context, listen: false).selectTab(0, 'home');

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (BuildContext context) => BottomNavigationScreen()),
                                    (Route<dynamic> route) => false
                            );
                          },
                          child: Text('yes'.tr(),style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(color: kPrimaryColor)
                                  )),
                              backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(child: Container
                      (
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                            Navigator.of(context).pop();
                        },
                        child: Text('cancel'.tr()),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),

                                )),
                            backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor)),
                      ),
                    )),
                  ],),)
              ],

          ),
        ),

    );
  }
}
