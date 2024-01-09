import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class PaymentOptionsScreen extends StatelessWidget {
  PaymentOptionsScreen({Key? key}) : super(key: key);
  final methods = ['بطاقة مدى / VISA','ابل باي'];

  final images = ['assets/images/visa.png','assets/images/apple.png'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldGrey,
      appBar: AppBar(
        elevation: .5,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('payment_methods'.tr(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),
      body: Column(children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          )),
          padding: EdgeInsets.symmetric(vertical: 30,horizontal: 50),
          child: Column(
            children: [
              Image.asset('assets/images/bye.png',width: 80,),
              SizedBox(height: 10,),
              Container(
                  width: 180,
                  child: Text('select_payment_methods'.tr(),textAlign: TextAlign.center,))
            ],
          ),
        ),
        SizedBox(height: 10,),
        Expanded(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width>400?2:2,childAspectRatio: 2,crossAxisSpacing: 10,mainAxisSpacing: 10), itemBuilder: (context, index) {
            return PaymentItem(title: methods[index],image: images[index],);
          },itemCount: 2,),
        ))

      ],),

    );
  }
}

class PaymentItem extends StatelessWidget {
   PaymentItem({Key? key,this.title='',this.image=''}) : super(key: key);
  String title;
  String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Image.asset(image,width: 24,),
        SizedBox(height: 10,),
        Text(title,style: TextStyle(color: kDarkTxtGrey),)
      ],),
    );
  }
}
