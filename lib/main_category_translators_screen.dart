import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:translatorclient/auth_screen.dart';
import 'package:translatorclient/auth_widget.dart';
import 'package:translatorclient/colors.dart';
import 'package:translatorclient/data/http/dio_client.dart';
import 'package:translatorclient/data/service_locator.dart';
import 'package:translatorclient/model/auth_response.dart';
import 'package:translatorclient/model/categories_model.dart';
import 'package:translatorclient/providers/home_provider.dart';
import 'package:translatorclient/providers/translators_provider.dart';
import 'package:translatorclient/translator_list_item.dart';
import 'package:translatorclient/widgets/add_brand_screen.dart';
import 'package:translatorclient/widgets/product_item.dart';

class MainCategoryTranslatorsScreen extends StatefulWidget {
  MainCategoryTranslatorsScreen({Key? key, required this.category})
      : super(key: key);
  Category category;

  @override
  State<MainCategoryTranslatorsScreen> createState() =>
      _MainCategoryTranslatorsScreenState();
}

class _MainCategoryTranslatorsScreenState
    extends State<MainCategoryTranslatorsScreen> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<TranslatorsProvider>(context, listen: false).initPage();
      Provider.of<TranslatorsProvider>(context, listen: false).category =
          widget.category.id;
      Provider.of<TranslatorsProvider>(context, listen: false)
          .getThisBrandProductsByBrnadID(widget.category.id);

      Provider.of<HomeProvider>(context, listen: false)
          .getAlternativeBrands(id: widget.category.id);

      getWikiDetails().then((value) {
        setState(() {
          widget.category.brand_description = value;
        });
      });
    });
  }
//https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=Stack%20Overflow

  Future<String> getWikiDetails() async {
    if (widget.category.brand_description != 'Not Available' &&
        widget.category.brand_description != '')
      return widget.category.brand_description ?? '';

    try {
      final response = await Dio().post(
        'https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=${widget.category.name}',
      );
      final parsedJson = response.data;

      String extract = '';
      parsedJson['query']['pages'].forEach((key, value) {
        extract = value['extract'];
      });
      return extract;
    } catch (e) {
      return '';
    }
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
          widget.category.name ?? '',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<TranslatorsProvider>(
          builder: (context, value, child) => ListView(
            children: [
              ListTile(
                  onTap: () {},
                  visualDensity: VisualDensity(vertical: 4),
                  //isThreeLine: true,
                  leading: Badge(
                    backgroundColor: widget.category.isAlternative == 1
                        ? kPrimaryColor
                        : Colors.red,
                    largeSize: 30,
                    label: Icon(
                      widget.category.isAlternative == 1
                          ? Icons.done
                          : Icons.do_not_disturb,
                      color: Colors.white,
                      size: 20,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: widget.category.image!.replaceAll(' ', ''),
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/icons.png',
                              width: 80,
                              height: 80,
                            )),
                      ),
                    ),
                  ),
                  title: Text(
                    widget.category.name ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: ReadMoreText(
                    widget.category.brand_description ?? '',
                    style: TextStyle(color: kDarkGrey),
                    trimLines: 5,
                    colorClickableText: Colors.black,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Text(
                            'Type'.tr(),
                            style: TextStyle(color: kDarkTxtGrey),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              widget.category.isAlternative == 1
                                  ? 'Alternative'.tr()
                                  : 'Product'.tr(),
                              maxLines: 1,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Text(
                            'Founded in'.tr(),
                            style: TextStyle(color: kDarkTxtGrey),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(widget.category.foundation_year ?? '',
                              maxLines: 1,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Text(
                            'Country'.tr(),
                            style: TextStyle(color: kDarkTxtGrey),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('${widget.category.origin_country ?? ''}',
                              maxLines: 1,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              /////////////////////////////////////////////////////////////////////////////////////////////////

              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Alternatives'.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Consumer<HomeProvider>(
                  builder: (context, value, child) => Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        return Container(
                          margin: EdgeInsets.all(7),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return MainCategoryTranslatorsScreen(
                                  category: value.alternativeBrands[index],
                                ); //value.mainCategories[index].children!.isEmpty?MainCategoryTranslatorsScreen(category: value.mainCategories[index],): SubcategoriesScreen(category: value.mainCategories[index],);
                              }));
                            },
                            child: Column(
                              children: [
                                Badge(
                                  backgroundColor: value
                                              .alternativeBrands[index]
                                              .isAlternative ==
                                          1
                                      ? kPrimaryColor
                                      : Colors.red,
                                  largeSize: 30,
                                  label: Icon(
                                    value.alternativeBrands[index]
                                                .isAlternative ==
                                            1
                                        ? Icons.done
                                        : Icons.do_not_disturb,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          value.alternativeBrands[index].image!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Image.asset('assets/images/icon.png'),
                                    ),
                                  ),
                                ),
                                Container(
                                    width: 80,
                                    child: Text(
                                      value.alternativeBrands[index].name ?? '',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: value.alternativeBrands[index]
                                                      .isAlternative ==
                                                  1
                                              ? kPrimaryColor
                                              : Colors.red),
                                      overflow: TextOverflow.ellipsis,
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: value.alternativeBrands.length,
                    ),
                  ),
                ),
              ),
              ////////////////////////////////////////////////////////////////////////////////////////////////
              Text(
                'translators_count'.tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 400 ? 2 : 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      mainAxisExtent: 220),
                  itemBuilder: (context, index) {
                    return ProductItem(
                      item: value.thisBrandProducts[index],
                    );
                  },
                  itemCount: value.thisBrandProducts.length,
                ) /*ListView.builder(controller:_scrollController,itemBuilder: (context, index) {
                  return TranslatorListItem(translator:value.categoryTranslators[index] ,);
                },itemCount: value.categoryTranslators.length,)*/
                ,
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
                          AddBrandScreen(parent: widget.category.id),
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
              !value.isLoading
                  ? Container()
                  : Center(
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator()),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
