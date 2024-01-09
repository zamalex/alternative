import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:translatorclient/colors.dart';
import 'package:translatorclient/data/service_locator.dart';
import 'package:translatorclient/hire_translator_screen.dart';
import 'package:translatorclient/model/translators_model.dart';
import 'package:translatorclient/translator_details.dart';


class TranslatorListItem extends StatelessWidget {
  const TranslatorListItem({Key? key,this.translator}) : super(key: key);

  final Product? translator;

  @override
  Widget build(BuildContext context) {
    return translator==null?Container():Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        ListTile(

          visualDensity: VisualDensity(vertical: 4),
          isThreeLine: true,
          leading:   ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: translator!.image!,
              width: 90,
              height: 180,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.asset('assets/images/icon.png'),
            ),
          ),
        title: Text(translator!.name??'',style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(translator!.speciality??'',style: TextStyle(color: kDarkGrey),),
            Row(children: [Icon(Icons.star,color: Colors.yellow,),
            Text(translator!.translator_rate.toString()??'')
            ],)
          ],),
        ),
        Container(margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return TranslatorDetailsScreen(translator: translator!,);
                    },));
                  },
                  child: Text('details'.tr(),style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),),
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
              child: ElevatedButton.icon(
                icon: Image.asset('assets/images/work.png',width: 20,),
                onPressed: () {

                  Navigator.of(context).push(MaterialPageRoute(builder: (_){
                    return HireTranslatorScreen(translator: translator!,);
                  }));
                },
                label: Text('hire_me'.tr()),
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
      ],),
    );
  }
}
