import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/main_category_translators_screen.dart';
import 'package:translatorclient/providers/home_provider.dart';
import 'package:translatorclient/providers/translators_provider.dart';
import 'package:translatorclient/slider.dart';
import 'package:translatorclient/subcategories_screen.dart';
import 'package:translatorclient/widgets/home_product_item.dart';

import 'colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int selectedTab=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value){
      Provider.of<HomeProvider>(context,listen: false).getSliders();
      Provider.of<HomeProvider>(context,listen: false).getMainBrands();
      //Provider.of<HomeProvider>(context,listen: false).getExclusiveCategories();
      //Provider.of<HomeProvider>(context,listen: false).getLanguages();
      Provider.of<TranslatorsProvider>(context,listen: false).getBrandProducts(null,null,type: selectedTab);

    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeSlider(),
            SizedBox(
              height: 20,
            ),
            Row(children: [
              InkWell(
                onTap: (){
                  if(selectedTab!=0) {
                    setState(() {
                      selectedTab=0;
                    });

                    Provider.of<TranslatorsProvider>(context,listen: false).getBrandProducts(null,null,type: selectedTab);

                  }
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(color: selectedTab==0?Colors.white:kLightGrey,borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(10)),),
                  child: Text('Products_and_brands'.tr(),style: TextStyle(color: selectedTab==0?kPrimaryColor:kDarkGrey,fontWeight: FontWeight.bold),),
                ),
              ),
              InkWell(
                onTap: (){
                  if(selectedTab!=1) {
                    setState(() {
                      selectedTab=1;
                    });

                    Provider.of<TranslatorsProvider>(context,listen: false).getBrandProducts(null,null,type: selectedTab);

                  }
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(color: selectedTab==1?Colors.white:kLightGrey,borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(10)),),
                  child: Text('alternatives'.tr(),style: TextStyle(color: selectedTab==1?kPrimaryColor:kDarkGrey,fontWeight: FontWeight.bold),),
                ),
              ),

            ],),

            SizedBox(
              height: 20,
            ),
            Text(
              'boycotted_brands'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Consumer<HomeProvider>(
              builder:(context, value, child) =>  Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return Container(
                      margin: EdgeInsets.all(7),
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_){
                            return MainCategoryTranslatorsScreen(category: value.mainCategories[index],);//value.mainCategories[index].children!.isEmpty?MainCategoryTranslatorsScreen(category: value.mainCategories[index],): SubcategoriesScreen(category: value.mainCategories[index],);
                          }));
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                             borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: value.mainCategories[index].image!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Image.asset('assets/images/icon.png'),
                              ),
                            ),
                            Container(width:80,child: Text(value.mainCategories[index].name??'',textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,))
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: value.mainCategories.length,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'boycotted_products'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Consumer<TranslatorsProvider>(
              builder:(context, value, child) => Container(
                height: 220,
                child:ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      width: 10,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return HomeProductItem(product: value.categoryTranslators[index],);
                    },
                    itemCount: value.categoryTranslators.length,
                  ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
