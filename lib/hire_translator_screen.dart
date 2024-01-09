import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/dropdown_list.dart';
import 'package:translatorclient/model/categories_model.dart';
import 'package:translatorclient/model/hire_model.dart';
import 'package:translatorclient/model/ldropdown_model.dart';
import 'package:translatorclient/providers/hire_provider.dart';
import 'package:translatorclient/providers/home_provider.dart';
import 'package:translatorclient/widgets/add_brand_bottomsheet.dart';

import 'auth_screen.dart';
import 'auth_widget.dart';
import 'colors.dart';
import 'data/service_locator.dart';
import 'model/auth_response.dart';
import 'model/translators_model.dart';

class HireTranslatorScreen extends StatefulWidget {
  const HireTranslatorScreen({Key? key,required this.translator,this.parent}) : super(key: key);

  final Category?parent;
  final Product translator;
  @override
  State<HireTranslatorScreen> createState() => _HireTranslatorScreenState();
}

class _HireTranslatorScreenState extends State<HireTranslatorScreen> {

  late HomeProvider homeProvider;

  TextEditingController detailsController = TextEditingController();

  pickFile()async{
    if(!sl.isRegistered<AuthResponse>()){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return AuthScreen();
      },));

      return;
    }

   /* FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc','docx','word'],
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      files.forEach((element) {print(element.path);});

      Provider.of<HireProvider>(context,listen: false).setFiles(files);
      Provider.of<HireProvider>(context,listen: false).uploadFile();

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Selected Files'),backgroundColor: Colors.red));
      // User canceled the picker
    }
*/  }

  sendRequest(BuildContext context){
    if(!sl.isRegistered<AuthResponse>()){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return AuthScreen();
      },));

      return;
    }
    HireProvider hireProvider = Provider.of<HireProvider>(context,listen: false);

    if(hireProvider.category==null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('enter_translation_type'.tr())));
      return;
    }
    if(hireProvider.fromLanguage==null||hireProvider.toLanguage==null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('select_language'.tr())));
      return;
    }
    if(hireProvider.uploads.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('no_attachments'.tr())));
      return;
    }

    int pages_count=0;
    hireProvider.uploads.forEach((element) {
      pages_count+=element.pagesCount??0;
    });

    Map requestBody = {
      'details':detailsController.text,
      'category_id':hireProvider.category,
      'from_language_id':hireProvider.fromLanguage,
      'to_language_id':hireProvider.toLanguage,
      'translator_id':widget.translator.id,
      'pdfs':hireProvider.uploads.map((e) => e.id).toList(),
      'pages_count':pages_count,
    };

  hireProvider.sendRequest(requestBody).then((value){

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor:value['data']!=null?Colors.green:Colors.red,content: Text(value['message'])));

    HireModel? hireModel = value['data'];
    //if(hireModel!=null)
     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaylinkWebView(model: hireModel),));
  });

  }
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
         // height: 600.0,
          color: Colors.white,
          child: Center(
            child: AddBrandSheet(),
          ),
        );
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    Future.delayed(Duration.zero).then((value){
      Provider.of<HireProvider>(context,listen: false).initPage();
      homeProvider = Provider.of<HomeProvider>(context,listen: false);


      if(homeProvider.mainCategories.isEmpty){
        homeProvider.getMainBrands();
      }
      if(homeProvider.languages.isEmpty){
        homeProvider.getLanguages();
      }

      _showBottomSheet(context);

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
          'hire_me'.tr(),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kPrimaryLight),
                child:  Consumer<HireProvider>(
                  builder:(context, hireProvider, child) {

                    Category? cat;
                    if(hireProvider.category==null){
                      cat=null;
                    }else{
                      if(widget.translator.categories!.isEmpty){
                        cat=null;
                      }
                      else{
                        widget.translator.categories!.forEach((element) {
                            if(element.id==hireProvider.category){
                              cat=element;
                            }
                        });

                      }
                    }
                    double? translatorPage=0;


                    return RichText(
                        text: TextSpan(
                            text: 'pricing_pre'.tr(),
                            style: GoogleFonts.cairo(color: Colors.black,fontWeight: FontWeight.w600),
                            children: <TextSpan>[
                        TextSpan(text: '${0} ${'pricing_price'.tr()}', style: TextStyle(fontWeight: FontWeight.w600,color: kPrimaryColor)),
                    TextSpan(text: 'pricing_post'.tr(),style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black)),
                    ],
                    ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Consumer<HomeProvider>(
                builder:(context, value, child) =>  Column(children: [
                  CustomDropdownList(
                    text: 'enter_translation_type'.tr(),
                    title: 'translation_type'.tr(),
                    list: widget.translator.categories!.map((e) =>DropdownModel(id: e.id??0, name: e.name??'')).toList(),
                    onSelect: Provider.of<HireProvider>(context,listen: false).setCategory,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomDropdownList(
                    text: '',
                    title: 'translate_from'.tr(),
                    list: widget.translator.languages!.map((e) =>DropdownModel(id: e.id??0, name: e.name??'')).toList(),
                    onSelect: Provider.of<HireProvider>(context,listen: false).setFromLanguage,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomDropdownList(
                    text: '',
                    title: 'translate_to'.tr(),
                    list: widget.translator.languages!.map((e) =>DropdownModel(id: e.id??0, name: e.name??'')).toList(),
                      onSelect: Provider.of<HireProvider>(context,listen: false).setToLanguage
                  ),
                ],),
              ),

              SizedBox(
                height: 20,
              ),
              Text(
                'add_attachments'.tr(),
                style: TextStyle(color: kDarkTxtGrey),
              ),
              Row(children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(15),
                    child: Text('add_attachments_here'.tr(),),

                  ),
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: pickFile,
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

              BasicTextField(color: Colors.white,margin: 0,),
              SizedBox(
                height: 20,
              ),
              BasicTextField(color: Colors.white,margin: 0,),
              SizedBox(
                height: 20,
              ),
              BasicTextField(color: Colors.white,margin: 0,),
              SizedBox(
                height: 20,
              ),
              Text(
                'optional_details'.tr(),
                style: TextStyle(color: kDarkTxtGrey),
              ),
              TextField(
                controller: detailsController,
                maxLines: 5,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: 'enter_optional_details'.tr(),
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.white),
              ),
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

                    sendRequest(context);
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
          ),
        ),
      ),
    );
  }
}

class DebugView extends StatelessWidget {
   DebugView({Key? key,this.text=''}) : super(key: key);

  String text='';
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kLightGrey,
      child: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            child: Text(text,style: TextStyle(color: kPrimaryColor),),
          ),
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}

