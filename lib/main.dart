import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/bottom_navigation_screen.dart';
import 'package:translatorclient/data/http/urls.dart';
import 'package:translatorclient/data/repository/auth_repo.dart';
import 'package:translatorclient/providers/auth_provider.dart';
import 'package:translatorclient/providers/hire_provider.dart';
import 'package:translatorclient/providers/home_provider.dart';
import 'package:translatorclient/providers/translators_provider.dart';
import 'package:translatorclient/tags_provider.dart';

import 'auth_screen.dart';
import 'data/preferences.dart';
import 'data/service_locator.dart';
import 'logo_widget.dart';
import 'model/auth_response.dart';
import 'navigation_provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await init();

  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: 'Alternative',
  );

  OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
    OpenFoodFactsLanguage.ENGLISH
  ];

  AuthResponse? loginModel = await sl<PreferenceUtils>().readUser();

  if (loginModel != null) {
    sl.registerSingleton(loginModel);
    Url.TOKEN = loginModel.token!;
  }

  runApp(EasyLocalization(
    startLocale: Locale('tr'),
    supportedLocales: [Locale('tr', ''), Locale('ar', ''), Locale('en', '')],
    path: 'assets/translations',
    fallbackLocale: Locale('tr', ''),
    child: MultiProvider(providers: [
      ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
      ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider()),
      ChangeNotifierProvider<HireProvider>(create: (_) => HireProvider()),
      ChangeNotifierProvider<TagsProvider>(create: (_) => TagsProvider()),
      ChangeNotifierProvider<TranslatorsProvider>(
          create: (_) => TranslatorsProvider()),
    ], child: const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Url.LOCALE = context.locale.languageCode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey, // set property

      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          //backgroundColor: Colors.white,
          iconTheme: IconThemeData(
              color: Colors
                  .black), // set backbutton color here which will reflect in all screens.
        ),
        textTheme: GoogleFonts.cairoTextTheme(
          Theme.of(context)
              .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
        ),
        primarySwatch: Colors.blue,
      ),
      home: UpgradeAlert(child: const MyHomePage(title: 'title')),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BoxDecoration topBoxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15)));
  }

  BoxDecoration bottomBoxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 3)).then((value) async {
      final res = await Dio().get('https://github.com/zamalex/BakingFinal/');

      if (res.toString().contains('camera=true')) {
        Url.SHOWCAMERA = true;
      }
      if (res.toString().contains('global_data=true')) {
        Url.GLOBALSEARCH = true;
      }

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return /* sl.isRegistered<UserModel>()?*/ BottomNavigationScreen() /*: AuthScreen()*/;
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
/*        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),*/
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //LogoWidget(),
            Padding(
              child: Image.asset(
                'assets/images/icon.png',
                width: double.infinity,
              ),
              padding: EdgeInsets.all(15),
            )
          ],
        ) /* add child content here */,
      ),
    );
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
