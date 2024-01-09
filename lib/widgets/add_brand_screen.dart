import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:translatorclient/data/repository/auth_repo.dart';

import '../auth_screen.dart';
import '../auth_widget.dart';
import '../colors.dart';
import '../data/countries.dart';
import '../data/service_locator.dart';
import '../done_add_dialog.dart';
import '../model/auth_response.dart';
import '../providers/hire_provider.dart';

class AddBrandScreen extends StatefulWidget {
  AddBrandScreen({Key? key, this.parent}) : super(key: key);

  int? parent;

  @override
  State<AddBrandScreen> createState() => _AddBrandScreenState();
}

class _AddBrandScreenState extends State<AddBrandScreen> {
  ImagePicker imagePicker = ImagePicker();
  DateTime selectedDate = DateTime.now();
  Country? selectedCountry;
  bool isChecked = false;
  TextEditingController barcodeController = TextEditingController();
  String? barcode;
  File? selectedFile;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  pickFile() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () async {
                Navigator.pop(context); // Close the bottom sheet
                final image = await imagePicker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  File file = File(image.path);
                  setState(() {
                    selectedFile = file;
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () async {
                Navigator.pop(context); // Close the bottom sheet
                final image = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  File file = File(image.path);
                  setState(() {
                    selectedFile = file;
                  });
                }
              },
            ),
          ],
        );
      },
    );
/*
    FilePickerResult? result = await FilePicker.platform.pickFiles(
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

  addBrand() {
    String name = nameController.text.toString();
    String desc = descController.text.toString();

    if (name.isEmpty ||
        desc.isEmpty ||
        selectedCountry == null ||
        selectedFile == null ||
        selectedDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill required data')));
      return;
    }

    Map<String, dynamic> params = {};
    params.putIfAbsent('brand_name', () => name);
    params.putIfAbsent('brand_origin_country', () => selectedCountry!.name);
    params.putIfAbsent('brand_year_founded',
        () => '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}');
    params.putIfAbsent('brand_description', () => desc);
    params.putIfAbsent('brand_barcode', () => barcodeController.text);

    params.putIfAbsent('parent_brand_id', () => widget.parent);

    params.putIfAbsent('user_id', () => sl.get<AuthResponse>().user!.id);
    params.putIfAbsent('isAlternative', () => isChecked ? 1 : 0);

    setState(() {
      isLoading = true;
    });
    sl.get<AuthRepository>().addBrand(selectedFile!, params).then((value) {
      setState(() {
        isLoading = false;
      });

      Navigator.pop(context);
      showDoneDialog(context);
    });
  }

  void showDoneDialog(BuildContext context) {
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
            child: DoneAddDialog(
              barcode: '',
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldGrey,
      appBar: AppBar(
        elevation: .5,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Add New Brand'.tr(),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Add New Brand'.tr(),
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'add_logo'.tr(),
                  style: TextStyle(color: kDarkTxtGrey),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: kLightGrey,
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'add_logo'.tr(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        pickFile();
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        child: Provider.of<HireProvider>(
                          context,
                        ).uploading
                            ? CircularProgressIndicator(
                                color: kPrimaryColor,
                              )
                            : Icon(
                                Icons.attach_file,
                                color: Colors.white,
                              ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kPrimaryLight),
                      ),
                    )
                  ],
                ),
                //Consumer<HireProvider>(builder:(context, value, child) =>DebugView(text:  value.debug,)),
                Column(
                  children: Provider.of<HireProvider>(
                    context,
                  )
                      .uploads
                      .map((e) => Text(
                            '${'uploaded ${e.name!}'}',
                            style: TextStyle(color: Colors.green),
                          ))
                      .toList(),
                ),
                SizedBox(
                  height: 5,
                ),
                if (selectedFile != null)
                  Image.file(selectedFile!,
                      fit: BoxFit.cover, width: 70, height: 70),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'name'.tr(),
                  style: TextStyle(color: kDarkTxtGrey),
                ),
                BasicTextField(
                  color: kLightGrey,
                  margin: 0,
                  controller: nameController,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'barcode'.tr(),
                  style: TextStyle(color: kDarkTxtGrey),
                ),
                Row(
                  children: [
                    Expanded(
                      child: BasicTextField(
                        color: kLightGrey,
                        margin: 0,
                        controller: barcodeController,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        var res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SimpleBarcodeScannerPage(),
                            ));
                        setState(() async {
                          if (res is String) {
                            if (res == '-1') return;

                            barcode = res;
                            barcodeController.text = barcode!;
                          }
                        });
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        child: Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kPrimaryLight),
                      ),
                    )
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                Text(
                  'optional_details'.tr(),
                  style: TextStyle(color: kDarkTxtGrey),
                ),
                TextField(
                  controller: descController,
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
                SizedBox(
                  height: 10,
                ),
                Text(
                  'add_date'.tr(),
                  style: TextStyle(color: kDarkTxtGrey),
                ),

                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now());
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: kLightGrey,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(15),
                    child: Text(
                      '${'foundation_year'.tr()} : ${selectedDate.year}',
                    ),
                  ),
                ),

                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    showCountriesDialog(
                      context,
                      (country) {
                        setState(() {
                          selectedCountry = country;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      height: 56,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: kLightGrey,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        selectedCountry == null
                            ? 'select_origin_country'.tr()
                            : selectedCountry!.name,
                        style: TextStyle(color: Colors.black),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                CheckboxListTile(
                    value: isChecked,
                    onChanged: (v) {
                      setState(() {
                        isChecked = v!;
                      });
                    },
                    title: Text(
                      'Alternative'.tr(),
                      style: TextStyle(color: kPrimaryColor),
                    ),
                    checkColor: Colors.white,
                    activeColor: Colors.red),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 56,
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            /* Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return PaymentOptionsScreen();
                      },));*/

                            if (!sl.isRegistered<AuthResponse>()) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return AuthScreen();
                                },
                              ));

                              return;
                            }

                            addBrand();
                          },
                          child: Provider.of<HireProvider>(
                            context,
                          ).isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text('send_request'.tr()),
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
            )),
      ),
    );
  }
}
