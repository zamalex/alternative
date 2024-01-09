import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:translatorclient/data/repository/auth_repo.dart';
import 'package:translatorclient/data/service_locator.dart';
import 'package:translatorclient/forgotpassword/verify_phone_screen.dart';


import '../auth_widget.dart';
import '../colors.dart';
import '../logo_widget.dart';
import '../show_scaffold.dart';



class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final phoneController = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),

        backgroundColor: kPrimaryColor,),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              LogoWidget(unit: 40,),
              SizedBox(height: 20,),
              SizedBox(height: 15,),
              Row(
                children: [
                  Container(margin:EdgeInsets.symmetric(horizontal: 15),child: Text('email'.tr(),style: TextStyle(color: kDarkGrey,fontWeight: FontWeight.bold),)),
                ],
              ),
              BasicTextField(isEmail: true,controller: phoneController,color: Colors.white,),

              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                width: MediaQuery.of(context).size.width,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if(phoneController.text.isEmpty){
                      showErrorMessage(context, 'enterphone'.tr());
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                   sl<AuthRepository>().forgotPassword(phoneController.text).then((value){
                     setState(() {
                       isLoading=false;
                     });

                     if(value['data']){
                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifyPhoneScreen(phone: phoneController.text),));

                     }else{
                       showErrorMessage(context, value['message']);
                     }
                   });
                  },
                  child: isLoading?CircularProgressIndicator(color: Colors.white,):Text('confirm'.tr()),
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(kPrimaryColor)),
                ),
              ),
         
            ],
          ),
        ),
      ),
    );
  }
}


