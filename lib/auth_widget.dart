import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/bottom_navigation_screen.dart';
import 'package:translatorclient/providers/auth_provider.dart';
import 'package:translatorclient/providers/home_provider.dart';

import 'colors.dart';
import 'data/countries.dart';
import 'data/preferences.dart';
import 'data/service_locator.dart';
import 'forgotpassword/forgot_password_screen.dart';
import 'model/auth_response.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  int selectedTab = 0;
  String type = "email";

  //TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController registerPhoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();

  onCountrySelected(Country country) {
    setState(() {});
  }

  String selectedOption = 'individual';
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 250,
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  if (selectedTab != 0) {
                    setState(() {
                      selectedTab = 0;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: selectedTab == 0 ? Colors.white : kLightGrey,
                    borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(10)),
                  ),
                  child: Text(
                    'sign_in'.tr(),
                    style: TextStyle(
                        color: selectedTab == 0 ? kPrimaryColor : kDarkGrey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (selectedTab != 1) {
                    setState(() {
                      selectedTab = 1;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: selectedTab == 1 ? Colors.white : kLightGrey,
                    borderRadius: BorderRadiusDirectional.only(
                        topEnd: Radius.circular(10)),
                  ),
                  child: Text(
                    'create_account'.tr(),
                    style: TextStyle(
                        color: selectedTab == 1 ? kPrimaryColor : kDarkGrey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(10),
                    bottomStart: Radius.circular(10),
                    bottomEnd: Radius.circular(10)),
              ),
              child: selectedTab == 0
                  ? ListView(
                      children: [
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  type.tr(),
                                  style: TextStyle(
                                      color: kDarkGrey,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        type == 'email'
                            ? BasicTextField(
                                isEmail: true,
                                controller: mailController,
                              )
                            : Container(),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'password'.tr(),
                                  style: TextStyle(
                                      color: kDarkGrey,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        PasswordTextField(controller: passwordController),
                        /*SizedBox(height: 15,),
                Row(
                  children: [
                    InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => ForgotPasswordScreen()),
                          );
                        },
                        child: Container(margin:EdgeInsets.symmetric(horizontal: 15),child: Text('forgot_password_q'.tr(),style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),))),
                  ],
                ),*/
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 30),
                          width: MediaQuery.of(context).size.width,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              String error = '';

                              if (mailController.text.isEmpty &&
                                  type == 'email') {
                                error += 'valid_email'.tr();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(error),
                                        backgroundColor: Colors.red));
                                return;
                              }
                              if (passwordController.text.length < 6) {
                                error += 'valid_password'.tr();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(error),
                                        backgroundColor: Colors.red));
                                return;
                              }

                              Provider.of<AuthProvider>(context, listen: false)
                                  .login(
                                      type == 'email'
                                          ? mailController.text.trim()
                                          : '',
                                      passwordController.text,
                                      type)
                                  .then((value) {
                                if (value['data'] != null) {
                                  sl<PreferenceUtils>().saveUser(
                                      (value['data'] as AuthResponse));
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              BottomNavigationScreen()),
                                      (Route<dynamic> route) => false);
                                }
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(value['message']),
                                  backgroundColor: value['data'] == null
                                      ? Colors.red
                                      : Colors.green,
                                ));
                              });
                            },
                            child: Provider.of<AuthProvider>(
                              context,
                            ).isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text('sign_in'.tr()),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all(kPrimaryColor)),
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      padding: EdgeInsets.only(top: 5),
                      children: [
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'full_name'.tr(),
                                  style: TextStyle(
                                      color: kDarkGrey,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        BasicTextField(
                          controller: nameController,
                          isEmail: false,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'email'.tr(),
                                  style: TextStyle(
                                      color: kDarkGrey,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        BasicTextField(
                          isEmail: true,
                          controller: mailController,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'password'.tr(),
                                  style: TextStyle(
                                      color: kDarkGrey,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        PasswordTextField(controller: passwordController),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RadioListTile(
                                title: Text('individual'.tr()),
                                value: 'individual',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value.toString();
                                  });
                                },
                              ),
                              RadioListTile(
                                title: Text('organization'.tr()),
                                value: 'organization',
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value.toString();
                                  });
                                },
                              ),
                            ]),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 30),
                          width: MediaQuery.of(context).size.width,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              String error = '';
                              if (nameController.text.isEmpty) {
                                error += 'valid_name'.tr();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(error),
                                        backgroundColor: Colors.red));
                                return;
                              }
                              if (mailController.text.isEmpty) {
                                error += 'valid_email'.tr();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(error),
                                        backgroundColor: Colors.red));
                                return;
                              }
                              if (passwordController.text.length < 6) {
                                error += 'valid_password'.tr();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(error),
                                        backgroundColor: Colors.red));
                                return;
                              }

                              Map<String, String> body = {
                                'name': nameController.text,
                                'user_biography': nameController.text,
                                'country': 'Egypt',
                                'email': mailController.text,
                                'user_type': selectedOption,
                                //'phone':selectedCountry.dialCode+phoneController.text,
                                'password': passwordController.text,
                                'password_confirmation':
                                    passwordController.text,
                              };

                              Provider.of<AuthProvider>(context, listen: false)
                                  .register(body)
                                  .then((value) {
                                if (value['data']) {
                                  setState(() {
                                    selectedTab = 0;
                                  });
                                }
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(value['message']),
                                  backgroundColor: value['data'] == null
                                      ? Colors.red
                                      : Colors.green,
                                ));
                              });
                            },
                            child: Provider.of<AuthProvider>(
                              context,
                            ).isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text('create_new_account'.tr()),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all(kPrimaryColor)),
                          ),
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class PhoneTextField extends StatelessWidget {
  TextEditingController? controller;
  Color color;
  bool readOnly;
  Country? selectedCountry;
  Function? selectCountry;
  PhoneTextField(
      {Key? key,
      this.controller,
      this.color = kLightGrey,
      this.readOnly = false,
      this.selectCountry,
      this.selectedCountry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: 56,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                showCountriesDialog(context, (country) {
                  selectCountry!(country);
                  Navigator.pop(context);
                });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  height: 56,
                  decoration: BoxDecoration(
                    color: kPrimaryLight,
                    borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(10),
                        bottomStart: Radius.circular(10)),
                  ),
                  child: Text(
                    '+' + selectedCountry!.dialCode,
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Expanded(
                child: TextField(
              readOnly: readOnly,
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration.collapsed(
                hintText: '',
              ),
            )),
            SizedBox(
              width: 5,
            )
          ],
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  TextEditingController? controller;
  Color color;
  PasswordTextField({Key? key, this.controller, this.color = kLightGrey})
      : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
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
        color: widget.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
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
              hintStyle: TextStyle(
                color: kDarkGrey,
              ),
              focusColor: kLightGrey,
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: kPrimaryColor,
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

class BasicTextField extends StatelessWidget {
  TextEditingController? controller;
  bool isEmail;
  Color color;
  bool readOnly;
  double margin = 15;
  BasicTextField(
      {this.margin = 15,
      this.readOnly = false,
      Key? key,
      this.controller,
      this.isEmail = false,
      this.color = kLightGrey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      height: 56,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: TextField(
            readOnly: readOnly,
            keyboardType:
                isEmail ? TextInputType.emailAddress : TextInputType.text,
            controller: controller,
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
              hintStyle: TextStyle(
                color: kDarkGrey,
              ),
              focusColor: kLightGrey,
            ),
          ))
        ],
      ),
    );
  }
}
