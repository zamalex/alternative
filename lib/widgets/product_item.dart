import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/data/repository/auth_repo.dart';
import 'package:translatorclient/data/service_locator.dart';
import 'package:translatorclient/model/auth_response.dart';
import 'package:translatorclient/providers/home_provider.dart';
import 'package:translatorclient/widgets/styles.dart';
import 'package:translatorclient/translator_details.dart';

import '../colors.dart';
import '../model/translators_model.dart';

class ProductItem extends StatefulWidget {
  ProductItem({Key? key, this.item}) : super(key: key);

  final Product? item;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  File? selectedFile;

  String? barcode;

  Future<File> convertImageUrlToFile(String imageUrl) async {
    final dio = Dio();
    final response = await dio.get(imageUrl,
        options: Options(responseType: ResponseType.bytes));
    final bytes = response.data;

    // Get the temporary directory using the path_provider package
    final tempDir = await getTemporaryDirectory();

    // Create a new file in the temporary directory
    final file = File('${tempDir.path}/image.jpg');

    // Write the image bytes to the file
    await file.writeAsBytes(bytes);

    return file;
  }

  addProducts(BuildContext context) async {
    String name = widget.item!.name!;
    String desc = widget.item!.details!;
    barcode = widget.item!.product_barcode ?? "";
    if (barcode!.isEmpty) {
      barcode = '123456';
    }
    if (widget.item!.image != null) {
      selectedFile = await convertImageUrlToFile(widget.item!.image!);
      print('selected file ${selectedFile!.path}');
    }
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> params = {};
    params.putIfAbsent('product_name', () => name);
    params.putIfAbsent(
        'brand_id',
        () =>
            597 /*Provider.of<HomeProvider>(context, listen: false).selectedBrand*/);
    params.putIfAbsent('parent_product_id', () => null);
    params.putIfAbsent('product_barcode', () => barcode);
    params.putIfAbsent('product_decription', () => desc);
    params.putIfAbsent('product_additional_notes', () => desc);

    params.putIfAbsent('user_id', () => sl.get<AuthResponse>().user!.id);
    params.putIfAbsent('isAlternative', () => 0);

    await sl
        .get<AuthRepository>()
        .addProducts(selectedFile!, params)
        .then((value) {});

    setState(() {
      isLoading = false;
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return TranslatorDetailsScreen(
              translator: widget.item!,
            );
          },
        ));
      },
      child: Container(
        padding: EdgeInsets.all(5),
        height: 220,
        //width: 170,
        decoration: borderStyle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              child: Stack(
                children: [
                  ClipRRect(
                    child: FadeInImage(
                      fit: BoxFit.contain,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                        'assets/images/icons.png',
                        height: 120,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                      width: double.infinity,
                      height: 120,
                      image: NetworkImage(widget.item!.image ??
                          'https://montagbadil.com/assets/frontend/images/logo-01.png'),
                      placeholder: AssetImage(
                        'assets/images/icons.png',
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  Positioned(
                    child: InkWell(
                      onTap: () {
//                        addProducts(context);
                      },
                      child: Container(
                        decoration: borderStyle.copyWith(
                            color: widget.item!.isAlternative == 1
                                ? kPrimaryColor
                                : Colors.red,
                            borderRadius: BorderRadius.circular(5)),
                        height: 32,
                        padding: EdgeInsets.all(5),
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Icon(
                                widget.item!.isAlternative == 1
                                    ? Icons.done
                                    : Icons.do_not_disturb,
                                textDirection: TextDirection.ltr,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    top: 120 - 16,
                    left: 10,
                  )
                ],
              ),
            ),

            Container(
              child: FittedBox(
                child: Text(
                  widget.item != null ? widget.item!.name! : 'اسم الخدمة',
                  maxLines: 1,
                ),
                fit: BoxFit.scaleDown,
              ),
            ),
            //Text(item.,style: TextStyle(color: kPrimaryColor),)
          ],
        ),
      ),
    );
  }
}
