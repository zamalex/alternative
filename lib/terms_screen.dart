import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/providers/auth_provider.dart';

import 'colors.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value){
      Provider.of<AuthProvider>(context,listen: false).getTerms();

    });
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
          'terms'.tr(),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(padding: EdgeInsets.all(15),child:Consumer<AuthProvider>(builder: (context, value, child) =>Container(width:double.infinity,child: Text(value.terms,textAlign: TextAlign.start,)))
        ,),
    );
  }
}
