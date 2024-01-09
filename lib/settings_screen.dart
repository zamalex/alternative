import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/account_screen.dart';
import 'package:translatorclient/documents_screen.dart';
import 'package:translatorclient/logout_dialog.dart';
import 'package:translatorclient/notifications_screen.dart';
import 'package:translatorclient/providers/auth_provider.dart';
import 'package:translatorclient/terms_screen.dart';
import 'package:translatorclient/widgets/add_brand_screen.dart';
import 'package:translatorclient/widgets/add_product_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bottom_navigation_screen.dart';
import 'change_locale_dialog.dart';
import 'colors.dart';
import 'data/preferences.dart';
import 'data/repository/auth_repo.dart';
import 'data/service_locator.dart';
import 'model/auth_response.dart';
import 'navigation_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void showDialog(BuildContext context) {
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
            child: LogoutDialog(),
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

  void showDeleteDialog(BuildContext context) {
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
            child: DeleteDialog(),
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

  void showLocaleDialog(BuildContext context) {
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
            child: ChangeLocaleDoialog(),
            margin: EdgeInsets.only(bottom: 50, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldGrey,
      body: Column(
        children: [
          InkWell(
            onTap: () {
              /*  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AccountScreen();
            },));*/
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  )),
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
              child: Consumer<AuthProvider>(
                builder: (context, value, child) => Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Card(
                        child: CachedNetworkImage(
                          imageUrl: sl<AuthResponse>().user!.name ?? '',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/images/icon.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      sl<AuthResponse>().user!.name ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      sl<AuthResponse>().user!.email ?? '',
                      style: TextStyle(color: kDarkTxtGrey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                SettingsItem(
                  icon: Icons.add,
                  title: 'add_brand'.tr(),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return AddBrandScreen();
                      },
                    ));
                  },
                  image: 'assets/images/folder.png',
                ),
                SettingsItem(
                  icon: Icons.add,
                  title: 'add_product'.tr(),
                  badge: -1,
                  image: 'assets/images/folder.png',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return AddProductScreen();
                      },
                    ));
                  },
                ),
                SettingsItem(
                  icon: Icons.change_circle,
                  title: 'change_language'.tr(),
                  trailing: context.locale.languageCode.tr(),
                  image: 'assets/images/language.png',
                  onTap: () {
                    showLocaleDialog(context);
                  },
                ),
                SettingsItem(
                  icon: Icons.star,
                  title: 'rate_app'.tr(),
                  image: 'assets/images/star.png',
                  onTap: () {
                    if (Platform.isAndroid) {
                      launch("https://play.google.com/store/apps/details?id=" +
                          'com.sahla.boycott');
                    } else if (Platform.isIOS) {
                      launch("market://details?id=" + 'com.sahla.boycott');
                    }
                  },
                ),
                /*SettingsItem(title: 'terms'.tr(),image: 'assets/images/danger.png',onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return TermsScreen();
              },));
            },),*/
                if (Platform.isIOS)
                  SettingsItem(
                      icon: Icons.delete,
                      title: 'del-user'.tr(),
                      onTap: () {
                        showDeleteDialog(context);
                      },
                      image: 'assets/images/danger.png'),
                SettingsItem(
                    icon: Icons.logout,
                    title: 'logout'.tr(),
                    onTap: () {
                      showDialog(context);
                    },
                    image: 'assets/images/logout.png'),
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  SettingsItem(
      {this.icon,
      this.image = '',
      this.onTap = null,
      Key? key,
      this.title = '',
      this.badge = -1,
      this.trailing = ''})
      : super(key: key);
  String title;
  IconData? icon;
  int badge;
  String trailing;
  VoidCallback? onTap;
  String image;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 48,
        height: 48,
        padding:
            image.contains('language') ? EdgeInsets.all(6) : EdgeInsets.all(12),
        child: Container(
            // color: Colors.red,
            child: Icon(
          icon,
          size: 25,
          color: kPrimaryColor,
        ) /*Image.asset(
          image,
          width: 20,
          color: kPrimaryColor,
        )*/
            ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          badge > -1
              ? CircleAvatar(
                  backgroundColor: kPrimaryColor,
                  radius: 12,
                  child: Text(
                    badge.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : trailing.isNotEmpty
                  ? Text(
                      trailing,
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  : Container(),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({Key? key}) : super(key: key);

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
            Image.asset(
              'assets/images/danger.png',
              width: 66,
              color: Colors.red,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'you_sure_delete'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          await sl<AuthRepository>()
                              .deleteAccount(sl<AuthResponse>().user!.id!);
                          sl<PreferenceUtils>().logout();
                          Provider.of<NavigationProvider>(context,
                                  listen: false)
                              .selectTab(0, 'home');

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BottomNavigationScreen()),
                              (Route<dynamic> route) => false);
                        },
                        child: Text(
                          'yes'.tr(),
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: kPrimaryColor))),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Container(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('cancel'.tr()),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor)),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
