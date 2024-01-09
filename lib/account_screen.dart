import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/data/service_locator.dart';
import 'package:translatorclient/providers/auth_provider.dart';

import 'auth_widget.dart';
import 'colors.dart';
import 'model/auth_response.dart';

class AccountScreen extends StatefulWidget {
   AccountScreen({Key? key,this.edit=false}) : super(key: key);
  bool edit;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  TextEditingController emailController = TextEditingController(text: sl<AuthResponse>().user!.email??'');

  TextEditingController nameController = TextEditingController(text: sl<AuthResponse>().user!.name??'');

  File? selectedFile;

   pickFile()async{
    /* FilePickerResult? result = await FilePicker.platform.pickFiles(
       allowMultiple: false,
       type: FileType.image,
       //allowedExtensions: ['jpg', 'png'],
     );
     if (result != null) {
       File file = File(result.files.single.path!);
       setState(() {
         selectedFile=file;
       });
     } else {
       // User canceled the picker
     }*/
   }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldGrey,
      appBar: AppBar(
        elevation: .5,

        actions: [
          widget.edit?Container():Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
                onTap: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){
                    return AccountScreen(edit: true,);
                  }));
                },
                child: Image.asset('assets/images/edit.png',width: 20,)),
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'account'.tr(),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(15),
        child: Column(children: [
        InkWell(
          onTap: (){
            if(widget.edit){
              pickFile();
            }
          },
          child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
            child:selectedFile!=null?Image.file(selectedFile!,width: 150,height: 150,fit: BoxFit.cover,): CachedNetworkImage(
              imageUrl: sl<AuthResponse>().user!.name??'',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.asset('assets/images/icon.png'),
            ),
          ),
        ),
          SizedBox(height: 20,),
          Row(
            children: [
              Container(margin:EdgeInsets.symmetric(horizontal: 15),child: Text('full_name'.tr(),style: TextStyle(color: kDarkGrey,fontWeight: FontWeight.bold),)),
            ],
          ),
          BasicTextField(controller: nameController,isEmail: false,color: Colors.white,readOnly: !widget.edit,),

          SizedBox(height: 15,),
          Row(
            children: [
              Container(margin:EdgeInsets.symmetric(horizontal: 15),child: Text('email'.tr(),style: TextStyle(color: kDarkGrey,fontWeight: FontWeight.bold),)),
            ],
          ),
          BasicTextField(isEmail: true,controller: emailController,color: Colors.white,readOnly: !widget.edit,),

          SizedBox(height: 15,),
          Row(
            children: [
              Container(margin:EdgeInsets.symmetric(horizontal: 15),child: Text('phone'.tr(),style: TextStyle(color: kDarkGrey,fontWeight: FontWeight.bold),)),
            ],
          ),


          SizedBox(height: 15,),
          if(widget.edit)Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            width: MediaQuery.of(context).size.width,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                String error='';
                if(nameController.text.isEmpty){
                  error+='valid_name'.tr();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error),backgroundColor: Colors.red));
                  return;
                }
                if(emailController.text.isEmpty){
                  error+='valid_email'.tr();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error),backgroundColor: Colors.red));
                  return;
                }


                Map<String,String> body={
                  'name':nameController.text,
                  'email':emailController.text,


                };

                Provider.of<AuthProvider>(context,listen: false).updateProfile(body).then((value){
                  if(value['data']){
                      if(selectedFile!=null){
                          Provider.of<AuthProvider>(context, listen: false).updateAvatar(selectedFile!).then((imgRes){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(imgRes['message']),backgroundColor: !imgRes['data']?Colors.red:Colors.green,));

                          });
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['message']),backgroundColor: !value['data']?Colors.red:Colors.green,));

                      }
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value['message']),backgroundColor: !value['data']?Colors.red:Colors.green,));

                  }


                });
              },
              child: Provider.of<AuthProvider>(context,).isLoading?Center(child: CircularProgressIndicator(color: Colors.white,),):Text('save'.tr()),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),

                      )),
                  backgroundColor:
                  MaterialStateProperty.all(kPrimaryColor)),
            ),
          ),
        ],),
        ),
      ),
    );
  }
}
