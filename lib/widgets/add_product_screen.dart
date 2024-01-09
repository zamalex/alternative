import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../auth_screen.dart';
import '../auth_widget.dart';
import '../colors.dart';
import '../data/repository/auth_repo.dart';
import '../data/service_locator.dart';
import '../done_add_dialog.dart';
import '../dropdown_list.dart';
import '../model/auth_response.dart';
import '../model/ldropdown_model.dart';
import '../providers/hire_provider.dart';
import '../providers/home_provider.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({Key? key, this.barcode, this.parent}) : super(key: key);
  String? barcode;
  int? parent;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String? barcode;

  int brand = 0;
  selectBrand(int id) {
    brand = id;
  }

  ImagePicker imagePicker = ImagePicker();
  File? selectedFile;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
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

  addProducts() {
    String name = nameController.text.toString();
    String desc = descController.text.toString();
    barcode = barcodeController.text.toString();

    if (name.isEmpty ||
        desc.isEmpty ||
        selectedFile == null ||
        barcode == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill required data')));
      return;
    }

    Map<String, dynamic> params = {};
    params.putIfAbsent('product_name', () => name);
    params.putIfAbsent('brand_id', () => brand == 0 ? null : brand);
    params.putIfAbsent('parent_product_id', () => widget.parent);
    params.putIfAbsent('product_barcode', () => barcode);
    params.putIfAbsent('product_decription', () => desc);
    params.putIfAbsent('product_additional_notes', () => desc);

    params.putIfAbsent('user_id', () => sl.get<AuthResponse>().user!.id);
    params.putIfAbsent('isAlternative', () => isChecked ? 1 : 0);

    setState(() {
      isLoading = true;
    });
    sl.get<AuthRepository>().addProducts(selectedFile!, params).then((value) {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    barcode = widget.barcode;
    if (barcode != null) barcodeController.text = barcode!;
    Future.delayed(Duration.zero).then((value) {
      Provider.of<HomeProvider>(context, listen: false).getMainBrands();
    });
  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldGrey,
      appBar: AppBar(
        elevation: .5,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Add New Product'.tr(),
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
                  'Add New Product'.tr(),
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Consumer<HomeProvider>(
                  builder: (context, value, child) => CustomDropdownList(
                    color: kLightGrey,
                    text: 'select_brand'.tr(),
                    title: 'brand'.tr(),
                    list: value.mainCategories
                        .map((e) =>
                            DropdownModel(id: e.id ?? 0, name: e.name ?? ''))
                        .toList(),
                    onSelect: selectBrand,
                  ),
                ),
                SizedBox(
                  height: 10,
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
                          'add_attachments_here'.tr(),
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
                            addProducts();
                            //sendRequest(context);
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
