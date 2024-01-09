import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth_screen.dart';
import '../auth_widget.dart';
import '../colors.dart';
import '../data/service_locator.dart';
import '../model/auth_response.dart';
import '../providers/hire_provider.dart';

class AddBrandSheet extends StatefulWidget {
  const AddBrandSheet({Key? key}) : super(key: key);

  @override
  State<AddBrandSheet> createState() => _AddBrandSheetState();
}

class _AddBrandSheetState extends State<AddBrandSheet> {

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(padding:EdgeInsets.all(10),color:Colors.white,child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
        SizedBox(
          height: 20,
        ),
        Text(
          'Add New Brand'.tr(),
          style: TextStyle(color: kPrimaryColor,fontSize: 25,fontWeight: FontWeight.bold),
        ),
        Text(
          'add_attachments'.tr(),
          style: TextStyle(color: kDarkTxtGrey),
        ),
        Row(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: kLightGrey,borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(15),
              child: Text('add_attachments_here'.tr(),),

            ),
          ),
          SizedBox(width: 10,),
          InkWell(
            onTap: (){},
            child: Container(
              width: 56,
              height: 56,
              child:  Provider.of<HireProvider>(context,).uploading?CircularProgressIndicator(color: kPrimaryColor,):Icon(Icons.attach_file,color: Colors.white,),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: kPrimaryLight),
            ),
          )

        ],),
        //Consumer<HireProvider>(builder:(context, value, child) =>DebugView(text:  value.debug,)),
        Column(children: Provider.of<HireProvider>(context,).uploads.map((e) => Text('${'uploaded ${e.name!}'}',style: TextStyle(color: Colors.green),)).toList() ,),
        SizedBox(
          height: 20,
        ),
        Text(
          'name'.tr(),
          style: TextStyle(color: kDarkTxtGrey),
        ),
        BasicTextField(color: kLightGrey,margin: 0,),
        SizedBox(
          height: 20,
        ),

        Text(
          'optional_details'.tr(),
          style: TextStyle(color: kDarkTxtGrey),
        ),
        TextField(
          maxLines: 5,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: kLightGrey)),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: kLightGrey),
              ),
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: kLightGrey),
              ),
              hintText: 'enter_optional_details'.tr(),
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              filled: true,
              fillColor: kLightGrey),
        ),
        SizedBox(height: 10,),
        CheckboxListTile(value: isChecked, onChanged: (v){
          setState(() {
            isChecked = v!;
          });
        },title: Text('Alternative',style: TextStyle(color: kPrimaryColor),),checkColor: Colors.white,activeColor: Colors.red),
        SizedBox(height: 20,),
        Container(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              /* Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return PaymentOptionsScreen();
                      },));*/

              if(!sl.isRegistered<AuthResponse>()){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return AuthScreen();
                },));

                return;
              }

              //sendRequest(context);
            },
            child: Provider.of<HireProvider>(context,).isLoading?Center(child: CircularProgressIndicator(color: Colors.white,),):Text('send_request'.tr()),
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),

                    )),
                backgroundColor:
                MaterialStateProperty.all(kPrimaryColor)),
          ),
        ),
      ],
      )),
    );
  }
}
