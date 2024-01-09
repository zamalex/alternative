import 'package:flutter/material.dart';

const kPrimaryColor = Color.fromRGBO(0, 183, 206, 1);
const kDarkGrey = Color.fromRGBO(197, 197, 197, 1);
const kLightGrey = Color.fromRGBO(239, 240, 243, 1);
const kScaffoldGrey = Color.fromRGBO(245, 245, 245, 1);
const kDarkTxtGrey = Color.fromRGBO(147, 149, 152, 1);
const kPrimaryLight = Color.fromRGBO(190, 41, 236, 0.1);
const kOrange = Color.fromRGBO(250, 187, 81, 1);
const kBorderGrey = Color.fromRGBO(234, 234, 234, 1);

Color setStatusColor(String status){
  if(status=='جديد'||status=='تم استلام الطلب'||status=='New'){
    return Colors.blue;
  }else if(status=='قيد التنفيذ'||status=='Processing'||status=='Processed'){
    return kOrange;
  }else if(status=='في الطريق'||status=='On way'){
    return Colors.green;
  }else if(status=='ملغي'||status=='Cancelled'||status=='Canceled'){
    return Colors.red;
  }else{
    return Colors.greenAccent;
  }
}