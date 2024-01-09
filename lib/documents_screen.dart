import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'colors.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({Key? key}) : super(key: key);

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value){
      Provider.of<AuthProvider>(context,listen: false).getMyDocuments();
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
          'my_docs'.tr(),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(padding: EdgeInsets.all(15),child:
        Consumer<AuthProvider>(
          builder:(context, value, child) =>value.isLoading?Center(child: CircularProgressIndicator(),):  ListView.builder(itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
              child: ListTile(

                leading: Image.asset('assets/images/paper.png',width: 20,),
                title: Text('${'in_date'.tr()} ${value.myDocuments[index].created_at}',style: TextStyle(color: kDarkTxtGrey),),
                subtitle: Text(value.myDocuments[index].name!,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                trailing: Container(
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: Image.asset('assets/images/download.png',width: 20,),
                    onPressed: () async{

                      launch(value.myDocuments[index].pdf!);
                    },
                    label: Text('download'.tr(),style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: kPrimaryColor)
                            )),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.white)),
                  ),
                ),
              ),
            );
          },itemCount: value.myDocuments.length,),
        )
        ,),
    );
  }
}
