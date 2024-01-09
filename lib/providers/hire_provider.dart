
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:translatorclient/data/repository/hire_repo.dart';

import 'package:translatorclient/data/service_locator.dart';
import 'package:translatorclient/model/hire_model.dart';
import 'package:translatorclient/model/translators_model.dart';
import 'package:translatorclient/model/upload_response.dart';


class HireProvider extends ChangeNotifier{

  String debug='';
  bool isLoading=false;
  bool uploading=false;

  int? fromLanguage;
  int? toLanguage;
  int? category;
  List<File> files=[];
  List<UploadData> uploads=[];

  HireModel? hireModel;
  initPage(){
    debug='';
    files.clear();
    uploads.clear();
    fromLanguage = null;
    toLanguage = null;
    category = null;
    notifyListeners();
  }



  setCategory(int id){
    category = id;
    notifyListeners();
  }
  setFromLanguage(int id){
    fromLanguage = id;
  }
  setToLanguage(int id){
    toLanguage = id;
  }

  setFiles(List<File>loadedFiles){
    files.addAll(loadedFiles);
    notifyListeners();
  }

  Future uploadFile()async{

    uploading = true;

    files.forEach((element) {
      debug = debug+'selected ${element}\n';
    });
    debug = debug+'-----------------\n';
    notifyListeners();


    Future.wait(files.map((e){
      return  sl<HireRepository>().uploadFile(e).then((value) {
        debug = debug+'selected ${value['response']}\n';

        if(value['data']!=null){
          uploads.add((value['data']));
          notifyListeners();
        }
      });
    }).toList()).then((value){

      uploading = false;
      notifyListeners();

      uploads.forEach((upload) {
        print('uploaded ${upload.name} with id ${upload.id}');
      });

      return true;
    });

    notifyListeners();
  }




  Future<Map> sendRequest(Map body)async{
    isLoading = true;
    notifyListeners();

    Map response = await sl<HireRepository>().sendRequest(body);
      isLoading = false;
      notifyListeners();

      hireModel = response['data'];
      return response;

  }

}