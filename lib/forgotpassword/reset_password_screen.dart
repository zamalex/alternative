import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:translatorclient/data/repository/auth_repo.dart';
import 'package:translatorclient/data/service_locator.dart';


import '../auth_screen.dart';
import '../auth_widget.dart';
import '../colors.dart';
import '../logo_widget.dart';
import '../show_scaffold.dart';



class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({Key? key,required this.phone,required this.code}) : super(key: key);
  String phone;
  String code;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
              Row(
                children: [
                  Container(margin:EdgeInsets.symmetric(horizontal: 15),child: Text('password'.tr(),style: TextStyle(color: kDarkGrey,fontWeight: FontWeight.bold),)),
                ],
              ),
              PasswordTextField(controller: phoneController),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                width: MediaQuery.of(context).size.width,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if(phoneController.text.length<6){
                      showErrorMessage(context, 'enter 6 digits password');
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                    sl<AuthRepository>().resetPassword(widget.phone,widget.code,phoneController.text).then((value){
                      setState(() {
                        isLoading=false;
                      });

                      if(value['data']){
                        showSuccessMessage(context, value['message']);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthScreen(),));

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

class _PasswordTextFieldState extends State<PasswordTextField> {
  var _passwordVisible = false;

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: 56,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: kLightGrey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Image.asset('assets/images/Lock.png')),
          VerticalDivider(
            width: 1,
            color: kDarkGrey,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: TextField(
                controller: widget.controller,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  isCollapsed: true,
                  isDense: true,
                  contentPadding:
                  EdgeInsets.only(bottom: 15, top: 15, left: 10, right: 10),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kLightGrey)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kLightGrey),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: kLightGrey),
                  ),
                  hintText: 'كلمة المرور',
                  hintStyle: TextStyle(
                    color: kDarkGrey,
                  ),
                  focusColor: kLightGrey,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: kDarkGrey,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
