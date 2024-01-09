import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/advanced_search_screen.dart';
import 'package:translatorclient/data/http/urls.dart';
import 'package:translatorclient/dropdown_list.dart';
import 'package:translatorclient/model/image_search_response.dart';
import 'package:translatorclient/model/ldropdown_model.dart';
import 'package:translatorclient/not_found_dialog.dart';
import 'package:translatorclient/providers/home_provider.dart';
import 'package:translatorclient/providers/translators_provider.dart';
import 'package:translatorclient/translator_list_item.dart';
import 'package:translatorclient/widgets/product_item.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import 'colors.dart';
import 'main_category_translators_screen.dart';
import 'dart:io';
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? barcode;

  TextEditingController searchController = TextEditingController();

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      Provider.of<TranslatorsProvider>(context, listen: false).initPage();
      Provider.of<TranslatorsProvider>(context, listen: false).initFilterPage();
      Provider.of<TranslatorsProvider>(context, listen: false)
          .getBrandProducts(null, null)
          .then((value) {
        suggestions.addAll(
            Provider.of<TranslatorsProvider>(context, listen: false)
                .categoryTranslators
                .map((e) => e.name!)
                .toList());
      });
      Provider.of<HomeProvider>(context, listen: false)
          .getMainBrands()
          .then((value) {
        setState(() {
          suggestions.addAll(Provider.of<HomeProvider>(context, listen: false)
              .mainCategories
              .map((e) => e.name!)
              .toList());
        });
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Future.delayed(Duration.zero).then((value) {
          Provider.of<TranslatorsProvider>(context, listen: false)
              .getBrandProducts(null, null);
        });
      }
    });
  }

  File? selectedFile;
  ImagePicker imagePicker = ImagePicker();
  pickFile() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () async {
                Navigator.pop(context); // Close the bottom sheet
                final image = await imagePicker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  File file = File(image.path);
                  setState(() {
                    selectedFile = file;
                    searchWithImageRequest();
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () async {
                Navigator.pop(context); // Close the bottom sheet
                final image = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  File file = File(image.path);
                  setState(() {
                    selectedFile = file;
                    searchWithImageRequest();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  bool isLoading = false;
  searchWithImageRequest() async {
    if (selectedFile != null) {
      final bytes = selectedFile!.readAsBytesSync();
      String base64Image = base64Encode(bytes);

      print("img_pan : $base64Image");

      List requests = [
        {
          'image': {'content': base64Image},
          'features': {'type': 'LOGO_DETECTION'}
        }
      ];
      Map json = {'requests': requests};

      print('request is ${json.toString()}');
      setState(() {
        isLoading = true;
      });
      try {
        final response = await Dio().post(
            'https://vision.googleapis.com/v1/images:annotate?key=AIzaSyD9aDiZ0BppjTmoaqSM2GL4W0o9qQRn8WU',
            data: jsonEncode(json));
        final parsedJson = response.data;
        ImageSearchReponse imageSearchResponse =
            ImageSearchReponse.fromJson(parsedJson);
        searchController.text = imageSearchResponse
                .responses!.first.logoAnnotations!.first.description ??
            '';
        setState(() {});

        if (searchController.text.isNotEmpty) {
          await Future.wait([
            Provider.of<TranslatorsProvider>(context, listen: false)
                .getBrandProducts(null, 1, search: searchController.text),
            Provider.of<HomeProvider>(context, listen: false)
                .getMainBrands(search: searchController.text)
          ]);

          setState(() {
            isLoading = false;
          });
          if (Provider.of<HomeProvider>(context, listen: false)
                  .mainCategories
                  .isEmpty &&
              Provider.of<TranslatorsProvider>(context, listen: false)
                  .categoryTranslators
                  .isEmpty) {
            showNotFoundDialog(context);
          }
        }
      } catch (e) {
        showNotFoundDialog(context);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showNotFoundDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            // height: 220,
            child: NotFoundDialog(
              barcode: barcode,
            ),
            margin: EdgeInsets.only(bottom: 50, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  List<String> suggestions = [];

  @override
  Widget build(BuildContext context) {
    // Url.GLOBALSEARCH = true;
    return Consumer<TranslatorsProvider>(
      builder: (context, value, child) => Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: SimpleAutoCompleteTextField(
                      key: key,
                      suggestions: suggestions,
                      textInputAction: TextInputAction.done,
                      textSubmitted: (vv) async {
                        if (searchController.text.isNotEmpty) {
                          await Future.wait([
                            Provider.of<TranslatorsProvider>(context,
                                    listen: false)
                                .getBrandProducts(null, 1,
                                    search: searchController.text),
                            Provider.of<HomeProvider>(context, listen: false)
                                .getMainBrands(search: searchController.text)
                          ]);

                          if (Provider.of<HomeProvider>(context, listen: false)
                                  .mainCategories
                                  .isEmpty &&
                              Provider.of<TranslatorsProvider>(context,
                                      listen: false)
                                  .categoryTranslators
                                  .isEmpty) {
                            showNotFoundDialog(context);
                          }
                        } else {
                          Provider.of<TranslatorsProvider>(context,
                                  listen: false)
                              .getBrandProducts(
                            null,
                            1,
                          );
                          Provider.of<HomeProvider>(context, listen: false)
                              .getMainBrands(search: ' ');
                        }
                      },
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          prefixIcon: Container(
                              padding: EdgeInsets.all(15),
                              child: InkWell(
                                  onTap: () async {
                                    if (searchController.text.isNotEmpty) {
                                      await Future.wait([
                                        Provider.of<TranslatorsProvider>(
                                                context,
                                                listen: false)
                                            .getBrandProducts(null, 1,
                                                search: searchController.text),
                                        Provider.of<HomeProvider>(context,
                                                listen: false)
                                            .getMainBrands(
                                                search: searchController.text)
                                      ]);

                                      if (Provider.of<HomeProvider>(context,
                                                  listen: false)
                                              .mainCategories
                                              .isEmpty &&
                                          Provider.of<TranslatorsProvider>(
                                                  context,
                                                  listen: false)
                                              .categoryTranslators
                                              .isEmpty) {
                                        showNotFoundDialog(context);
                                      }
                                    } else {
                                      Provider.of<TranslatorsProvider>(context,
                                              listen: false)
                                          .getBrandProducts(
                                        null,
                                        1,
                                      );
                                      Provider.of<HomeProvider>(context,
                                              listen: false)
                                          .getMainBrands(search: ' ');
                                    }
                                  },
                                  child: Image.asset(
                                    'assets/images/search.png',
                                    width: 20,
                                    color: kDarkTxtGrey,
                                  ))),
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
                          hintText: 'search_here'.tr(),
                          hintStyle: TextStyle(
                            color: kDarkTxtGrey,
                          ),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () async {
                      var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SimpleBarcodeScannerPage(),
                          ));
                      setState(() async {
                        if (res is String) {
                          if (res == '-1') return;

                          barcode = res;
                          searchController.text = res;

                          /* Provider.of<TranslatorsProvider>(
                          context, listen: false).getBrandProducts(
                          null, 1, search: searchController.text);
                      Provider.of<HomeProvider>(context,listen: false).getMainBrands(search: searchController.text);*/

                          await Future.wait([
                            Provider.of<TranslatorsProvider>(context,
                                    listen: false)
                                .getBrandProducts(null, 1,
                                    search: searchController.text),
                            Provider.of<HomeProvider>(context, listen: false)
                                .getMainBrands(search: searchController.text)
                          ]);

                          if (Provider.of<HomeProvider>(context, listen: false)
                                  .mainCategories
                                  .isEmpty &&
                              Provider.of<TranslatorsProvider>(context,
                                      listen: false)
                                  .categoryTranslators
                                  .isEmpty) {
                            showNotFoundDialog(context);
                          }
                        }
                      });
                      /*Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return AdvancedSearchScreen();
                  },));*/
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      width: 56,
                      height: 56,
                      child: Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                        size: 25,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kPrimaryColor),
                    ),
                  ),
                  SizedBox(width: 5),
                  if (Url.SHOWCAMERA)
                    InkWell(
                      onTap: () {
                        pickFile();
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        width: 56,
                        height: 56,
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                            : Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 25,
                              ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kPrimaryColor),
                      ),
                    )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* SizedBox(
                    height: 20,
                  ),
                  Consumer<HomeProvider>(
                    builder: (context, value, child) => CustomDropdownList(
                      color: kLightGrey,
                      text: 'select_brand'.tr(),
                      title: 'brand'.tr(),
                      list: value.mainCategories
                          .map(
                              (e) => DropdownModel(id: e.id ?? 0, name: e.name ?? ''))
                          .toList(),
                      onSelect: (int bid) {
                        Provider.of<HomeProvider>(context, listen: false)
                            .selectedBrand = bid;
                      },
                    ),
                  ),*/
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Brands'.tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Consumer<HomeProvider>(
                      builder: (context, value, child) => GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 400 ? 3 : 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            // mainAxisExtent: 220,
                          ),
                          itemBuilder: (_, index) {
                            if (index > value.mainCategories.length - 1)
                              return Container();
                            return Container(
                              width: 100,
                              height: 200,
                              margin: EdgeInsets.all(7),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (_) {
                                    return MainCategoryTranslatorsScreen(
                                      category: value.mainCategories[index],
                                    ); //value.mainCategories[index].children!.isEmpty?MainCategoryTranslatorsScreen(category: value.mainCategories[index],): SubcategoriesScreen(category: value.mainCategories[index],);
                                  }));
                                },
                                child: Column(
                                  children: [
                                    Badge(
                                      backgroundColor: value
                                                  .mainCategories[index]
                                                  .isAlternative ==
                                              1
                                          ? kPrimaryColor
                                          : Colors.red,
                                      largeSize: 30,
                                      label: Icon(
                                        value.mainCategories[index]
                                                    .isAlternative ==
                                                1
                                            ? Icons.done
                                            : Icons.do_not_disturb,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: value
                                              .mainCategories[index].image!
                                              .replaceAll(' ', ''),
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'assets/images/icon.png'),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        width: 80,
                                        child: Text(
                                          value.mainCategories[index].name ??
                                              '',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: value.mainCategories[index]
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
                          itemCount:
                              Provider.of<HomeProvider>(context, listen: false)
                                  .grid_count //value.mainCategories.length,
                          ),
                    ),
                  ),
                  if (Provider.of<HomeProvider>(context, listen: false)
                          .grid_count <
                      Provider.of<HomeProvider>(context).mainCategories.length)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Provider.of<HomeProvider>(context, listen: false)
                              .increaseCridCount();
                        },
                        child: Text(
                          'Load more',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      '(${value.categoryTranslators.length}) ${'translators_count'.tr()}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
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
                            item: value.categoryTranslators[index],
                          );
                        },
                        itemCount: value.categoryTranslators.length,
                      ),
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
          ],
        ),
      ),
    );
  }
}
