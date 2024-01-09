import 'dart:math';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/model/ldropdown_model.dart';
import 'package:translatorclient/providers/home_provider.dart';
import 'package:translatorclient/providers/translators_provider.dart';
import 'package:translatorclient/tags_provider.dart';

import 'colors.dart';
import 'dropdown_list.dart';


class AdvancedSearchScreen extends StatefulWidget {
   AdvancedSearchScreen({Key? key}) : super(key: key);

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  TextEditingController controller = TextEditingController();

  late HomeProvider homeProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    Future.delayed(Duration.zero).then((value){
      homeProvider = Provider.of<HomeProvider>(context,listen: false);

      Provider.of<TranslatorsProvider>(context,listen: false).initFilterPage();

      if(homeProvider.mainCategories.isEmpty){
        homeProvider.getMainBrands();
      }
      if(homeProvider.languages.isEmpty){
        homeProvider.getLanguages();
      }

    });


  }
  
  Widget removeTxt(){
    return  Text('X',style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldGrey,
      appBar: AppBar(
        elevation: .5,

        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'filter_search'.tr(),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Consumer<HomeProvider>(
            builder:(context, value, child) =>  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  height: 20,
                ),
                CustomDropdownList(
                  text: 'enter_translation_type'.tr(),
                  title: 'translation_type'.tr(),
                  list: value.mainCategories.map((e) =>DropdownModel(id: e.id??0, name: e.name??'')).toList(),
                  onSelect: Provider.of<TranslatorsProvider>(context,listen: false).setCategory,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'translator_keywords'.tr(),
                  style: TextStyle(color: kDarkTxtGrey),
                ),
                TextField(
                  controller: controller,
                  onSubmitted: (v){
                    Provider.of<TranslatorsProvider>(context, listen: false).addTag(v);
                    controller.clear();
                    },
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintText: 'translator_keywords'.tr(),
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.white),
                ),
                SizedBox(height: 10,),

               Consumer<TranslatorsProvider>(
                 builder: (context, value, child) {
                   print(value.tags.length);
                  return MultiSelectContainer(
                    key: Key(Random().nextInt(1000).toString()),
                        maxSelectableCount: 0,
                      
                      suffix: MultiSelectSuffix(
                          selectedSuffix: removeTxt(),
                          enabledSuffix: removeTxt(),
                          disabledSuffix: removeTxt(),),
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
                      items: List.generate(value.tags.length, (index) => MultiSelectCard(
                          enabled: true,value: value.tags[index],label: value.tags[index])), onChange: (allSelectedItems, selectedItem) {
                          value.removeTag(selectedItem.toString());

                  });
                  /*Tags(
                    key: Key('1'),

                    itemCount: value.tags.length, // required
                    itemBuilder: (int index){


                      return ItemTags(

                        key: Key(index.toString()),
                        index: index, // required
                        title: value.tags[index],
                        //active: true,
                        color: kLightGrey,
                        colorShowDuplicate: kLightGrey,
                        activeColor: kLightGrey,
                        highlightColor: kLightGrey,
                        splashColor: kLightGrey,
                        //textColor: kDarkTxtGrey,
                        elevation: 0,
                        textActiveColor: kDarkTxtGrey,
                        borderRadius: BorderRadius.circular(10),
                        //customData: item.customData,
                        textStyle: TextStyle(color: kDarkTxtGrey,fontSize: 15 ),
                        combine: ItemTagsCombine.withTextBefore,
                        // OR null,
                        removeButton: ItemTagsRemoveButton(
                          color: kPrimaryColor,
                          size: 15,
                          backgroundColor: Colors.transparent,
                          onRemoved: (){
                            value.removeTag(index);

                            return true;
                          },
                        ), // OR null,

                      );

                    },
                  );*/
                 },

               )
,
    SizedBox(height: 20,),
                CustomDropdownList(
                  text: 'select_language'.tr(),
                  title: 'translate_from'.tr(),
                  list: value.languages.map((e) =>DropdownModel(id: e.id??0, name: e.name??'')).toList(),
                    onSelect: Provider.of<TranslatorsProvider>(context,listen: false).setFromLanguage,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomDropdownList(
                  text: 'select_language'.tr(),
                  title: 'translate_to'.tr(),
                  list: value.languages.map((e){
                    return DropdownModel(id: e.id??0, name: e.name??'');
                  }).toList(),
                   onSelect: Provider.of<TranslatorsProvider>(context,listen: false).setToLanguage
                ),

              SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {

                      Provider.of<TranslatorsProvider>(context,listen: false).getBrandProducts(null,1,).then((value) {
                        Navigator.of(context).pop();
                      });
                    },
                    child: Provider.of<TranslatorsProvider>(context,).isLoading?Center(child: CircularProgressIndicator(),):Text('search'.tr()),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),

                            )),
                        backgroundColor:
                        MaterialStateProperty.all(kPrimaryColor)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
