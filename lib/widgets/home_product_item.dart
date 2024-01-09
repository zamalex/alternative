import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:translatorclient/widgets/styles.dart';
import 'package:translatorclient/translator_details.dart';

import '../colors.dart';
import '../model/translators_model.dart';

class HomeProductItem extends StatelessWidget {
  const HomeProductItem({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return TranslatorDetailsScreen(
              translator: product,
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
                  FadeInImage(
                    fit: BoxFit.contain,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Image.asset(
                      'assets/images/icons.png',
                      height: 120,
                      fit: BoxFit.contain,
                      width: 160,
                    ),
                    width: 160,
                    height: 120,
                    image: NetworkImage(product.image ?? ''),
                    placeholder: AssetImage(
                      'assets/images/icons.png',
                    ),
                  ),
                  Positioned(
                    child: Container(
                      decoration: borderStyle.copyWith(
                          color: product.isAlternative == 1
                              ? kPrimaryColor
                              : Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      height: 32,
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        product.isAlternative == 1
                            ? Icons.done
                            : Icons.do_not_disturb,
                        textDirection: TextDirection.ltr,
                        color: Colors.white,
                      ),
                    ),
                    top: 120 - 16,
                    left: 10,
                  )
                ],
              ),
            ),

            Container(
              alignment: AlignmentDirectional.centerStart,
              width: 160,
              child: FittedBox(
                child: Text(
                  product.name ?? '',
                  maxLines: 1,
                  style: TextStyle(fontSize: 14),
                ),
                fit: BoxFit.scaleDown,
              ),
            ),
            // Text('${'sar'.tr()}',style: TextStyle(color: kPrimaryColor),)
          ],
        ),
      ),
    );
  }
}
