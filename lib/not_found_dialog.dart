import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/auth_screen.dart';
import 'package:translatorclient/bottom_navigation_screen.dart';
import 'package:translatorclient/data/preferences.dart';
import 'package:translatorclient/data/service_locator.dart';
import 'package:translatorclient/providers/home_provider.dart';
import 'package:translatorclient/providers/translators_provider.dart';
import 'package:translatorclient/widgets/add_brand_screen.dart';
import 'package:translatorclient/widgets/add_product_screen.dart';

import 'colors.dart';
import 'navigation_provider.dart';



class NotFoundDialog extends StatelessWidget {
   NotFoundDialog({Key? key,this.barcode}) : super(key: key);
String? barcode;

callFunctions(BuildContext context){
  Provider.of<TranslatorsProvider>(context,listen: false).initPage();
  Provider.of<TranslatorsProvider>(context,listen: false).getBrandProducts(null,null);
  Provider.of<HomeProvider>(context,listen: false).getMainBrands();
}
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
            Icon(Icons.error,size: 60,color:Colors.red),
            SizedBox(
              height: 15,
            ),
            Text(
              'no_available_results'.tr(),
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
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => AddProductScreen(barcode:barcode)),
                        );
                       // callFunctions(context);
                      },
                      child: Text('add_product'.tr(),style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),),
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
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => AddBrandScreen()),
                      );
                     // callFunctions(context);

                    },
                    child: Text('add_brand'.tr()),
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
