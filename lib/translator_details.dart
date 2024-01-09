import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/model/auth_response.dart';
import 'package:translatorclient/model/translators_model.dart';
import 'package:translatorclient/providers/translators_provider.dart';
import 'package:translatorclient/widgets/add_product_screen.dart';
import 'package:translatorclient/widgets/home_product_item.dart';
import 'package:url_launcher/url_launcher.dart';

import 'auth_screen.dart';
import 'colors.dart';
import 'data/service_locator.dart';
import 'hire_translator_screen.dart';

class TranslatorDetailsScreen extends StatefulWidget {
  TranslatorDetailsScreen({Key? key, required this.translator})
      : super(key: key);

  Product translator;

  @override
  State<TranslatorDetailsScreen> createState() =>
      _TranslatorDetailsScreenState();
}

class _TranslatorDetailsScreenState extends State<TranslatorDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<TranslatorsProvider>(context, listen: false)
          .getAlternativeProductsByID(widget.translator.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldGrey,
      appBar: AppBar(
        elevation: .5,
        actions: [
          /*Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
                onTap: (){
                  if(translator.mobile!.isNotEmpty)
                  launch("tel://${translator.mobile}");
                },
                child: Image.asset('assets/images/call.png',width: 20,)),
          )*/
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          widget.translator.name ?? '',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Badge(
                  backgroundColor: widget.translator.isAlternative == 1
                      ? kPrimaryColor
                      : Colors.red,
                  label: Text(
                    widget.translator.isAlternative == 1
                        ? 'Alternative'.tr()
                        : 'Product'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  largeSize: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.translator.image!,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/icon.png',
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.contain,
                          )),
                    ),
                  ),
                ),
              ),
              /*  ListTile(

                visualDensity: VisualDensity(vertical: 4),
                //isThreeLine: true,
                leading:  ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: widget.translator.image!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/images/icon.png',width: 80,height: 80,)),
                  ),
                ),
                title: Text(
                  widget.translator.name??'',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  widget.translator.speciality??'',
                  style: TextStyle(color: kDarkGrey),
                ),
              ),*/
              /* SizedBox(height: 20,),
              Row(children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.star,color: Colors.yellow,),
                        Text(widget.translator!.translator_rate.toString(),style: TextStyle(fontWeight: FontWeight.bold),)
                      ],),
                      SizedBox(height: 5,),
                      Text('rating'.tr(),style: TextStyle(color: kDarkTxtGrey),),
                    ],),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
                  child: Column(children: [ Text(widget.translator.certificate??'',maxLines: 1,style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5,),
                    Text('qualification'.tr(),style: TextStyle(color: kDarkTxtGrey),),],),
                ) ,)
               ,SizedBox(width:10),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
                    child: Column(children: [Text('${widget.translator.experience??'0'} ${'years'.tr()}',maxLines: 1,style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5,),
                      Text('experience'.tr(),style: TextStyle(color: kDarkTxtGrey),),],),
                  ),
                ),

              ],),*/

              /*SizedBox(
                height: 20,
              ),
              Text(
                'translator_keywords'.tr(),
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),

              MultiSelectContainer(
                maxSelectableCount: 0,
                  textStyles: const MultiSelectTextStyles(
                      textStyle: TextStyle(
                          color: kDarkTxtGrey)),
                  itemsDecoration: MultiSelectDecorations(
                    decoration: BoxDecoration(
                      color: kLightGrey,
                        borderRadius: BorderRadius.circular(10)),
                    selectedDecoration: BoxDecoration(
                        color: kLightGrey,
                        borderRadius: BorderRadius.circular(10)),
                    disabledDecoration: BoxDecoration(
                        color: kLightGrey,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  items: widget.translator.tags!.map((e) => MultiSelectCard(value: e.text,label: e.text)).toList(), onChange: (allSelectedItems, selectedItem) {}),
             */
              SizedBox(
                height: 20,
              ),
              Text(
                'details'.tr(),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Text(
                    widget.translator.details ?? '',
                    style: TextStyle(color: kDarkTxtGrey),
                  )),
              SizedBox(
                height: 20,
              ),
              Text(
                'Alternatives'.tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Consumer<TranslatorsProvider>(
                builder: (context, value, child) => Container(
                  height: 220,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      width: 10,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return HomeProductItem(
                        product: value.alternativeProducts[index],
                      );
                    },
                    itemCount: value.alternativeProducts.length,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    /* Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return PaymentOptionsScreen();
                      },));*/

                    if (!sl.isRegistered<AuthResponse>()) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return AuthScreen();
                        },
                      ));

                      return;
                    }

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          AddProductScreen(parent: widget.translator.id),
                    ));
                  },
                  child: Text('add_alternative'.tr()),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(kPrimaryColor)),
                ),
              ),
              /*Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                   /* if(!sl.isRegistered<UserModel>()){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return AuthScreen();
                      },));

                      return;
                    }*/

                    Navigator.of(context).push(MaterialPageRoute(builder: (_){
                      return HireTranslatorScreen(translator: widget.translator!,);
                    }));
                  },
                  child: Text('hire_me'.tr()),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),

                          )),
                      backgroundColor:
                      MaterialStateProperty.all(kPrimaryColor)),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
