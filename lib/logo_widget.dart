import 'package:flutter/material.dart';

import 'colors.dart';

class LogoWidget extends StatelessWidget {
  double unit;

  LogoWidget({this.unit = 50});

  BoxDecoration topBoxDecoration() {
    return BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(15));
  }

  BoxDecoration bottomBoxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: kPrimaryColor),
                  width: unit * 6 + 4,
                  height: unit * 3 + 6,
                ),
                /*Container(decoration: BoxDecoration(color:Colors.white,border:Border( bottom: BorderSide( //                    <--- top side
                  color: kPrimaryColor,
                  width: 3.0,
                ), top: BorderSide( //                    <--- top side
                  color: kPrimaryColor,
                  width: 3.0,
                ),) ),
                  width: MediaQuery.of(context).size.width,height: unit,),*/
                Center(
                  child: Container(
                    width: unit * 6,
                    height: unit * 3,
                    decoration: topBoxDecoration(),
                  ),
                  //Container(width: 300,height: 50,color: Colors.white,),
                  //Container(width: 300,height: 50,decoration: bottomBoxDecoration(),),
                ),
                Image.asset(
                  'assets/images/alogo.png',
                  height: unit * 3,
                )
              ],
              alignment: Alignment.center,
            ),
          ),
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
