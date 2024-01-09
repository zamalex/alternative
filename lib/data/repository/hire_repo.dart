import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:translatorclient/data/http/dio_client.dart';
import 'package:translatorclient/data/http/urls.dart';
import 'package:translatorclient/model/hire_model.dart';
import 'package:translatorclient/model/upload_response.dart';

import '../service_locator.dart';


class HireRepository{

   Future uploadFile( File file) async {

     try{
       var fileName = file.path.split('/').last;
       print(fileName);
       var formData = FormData.fromMap({
         'pdf': await MultipartFile.fromFile(file.path,
           filename: fileName,),
       });

       String platform = 'ios';
       if(Platform.isAndroid){
         platform = 'android';
       }
       var response = await sl<DioClient>().post(Url.UPLOAD_PDF_URL, data: formData);


       print(response);
       final parsedJson = response.data;
       if(parsedJson['code']==200){

         return {'message':'success ${parsedJson['message']}','data':UploadResponse.fromJson(parsedJson).data,'response':'success ${response.toString()}'};
       }

       return {'message':'false ${parsedJson['message']} ${response.statusCode}','response':'false ${response.toString()} ${response.statusCode}'};



     }catch(e){
       return {'message':'error ${e.toString()}','response':'error ${e.toString()}'};
     }
  }



  Future sendRequest( Map body) async {

     try{

       print(body);
       var response = await sl<DioClient>().post(Url.SEND_REQUEST_URL, data: jsonEncode(body));

       print(response);
       final parsedJson = response.data;
       if(parsedJson['code']==200){

         return {'message':parsedJson['message'],'data':HireModel.fromJson(parsedJson)};
       }

       return {'message':parsedJson['message'],};



     }catch(e){
       return {'message':'server error , please try again later',};
     }
  }

}