import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:translatorclient/data/repository/auth_repo.dart';
import 'package:translatorclient/data/service_locator.dart';
import 'package:translatorclient/forgotpassword/reset_password_screen.dart';
import 'package:translatorclient/logo_widget.dart';


import '../colors.dart';
import '../show_scaffold.dart';


class VerifyPhoneScreen extends StatefulWidget {
  VerifyPhoneScreen({Key? key,required this.phone}) : super(key: key);

  final String phone;
  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final controller = TextEditingController();

  bool isLoading = false;
  String otp='';
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
              SizedBox(height: 20,)
              ,Text('enter_code'.tr(),),
              SizedBox(height: 15,),
              PinCodeTextField(
                keyboardType: TextInputType.number,
                length: 4,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(

                  selectedFillColor: kLightGrey,
                  selectedColor: kLightGrey,
                  disabledColor: kLightGrey,
                  inactiveFillColor: kLightGrey,
                  inactiveColor: kLightGrey,
                  activeColor: kLightGrey,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 64,
                  fieldWidth: 64,
                  activeFillColor: Colors.white,
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                //errorAnimationController: errorController,
                controller: controller,
                onCompleted: (v) {
                  otp=v;
                  print("Completed");
                },
                onChanged: (value) {
                  print(value);

                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                }, appContext: context,
              ),

              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                width: MediaQuery.of(context).size.width,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if(otp.length<4){
                      showErrorMessage(context, 'enter 4 digits');
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                    sl<AuthRepository>().verify(widget.phone,otp).then((value){
                      setState(() {
                        isLoading=false;
                      });

                      if(value['data']){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetPasswordScreen(phone: widget.phone, code:otp),));

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

