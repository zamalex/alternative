import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/providers/auth_provider.dart';

import 'colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  ScrollController _scrollController =  ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value){
      Provider.of<AuthProvider>(context,listen: false).getNotifications(true);

      _scrollController
          .addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          Future.delayed(Duration.zero).then((value){
            Provider.of<AuthProvider>(context,listen: false).getNotifications(false);

          });        }
      });

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        backgroundColor: Colors.white,
        title: Text('notifications'.tr(),style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),centerTitle: true,),
      body: Container(
        padding: EdgeInsets.all(10),
        height: double.infinity,
        child: Consumer<AuthProvider>(
          builder: (context, value, child) =>
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return Container(child: Card(
                            child: ListTile(

                              title: Text(value.notifications[index].title??''),
                              subtitle: Text(value.notifications[index].body??''),
                              trailing: Text(DateFormat.Hm(context.locale.languageCode).format(DateTime.parse(value.notifications[index].createdAt??''))),
                            ),
                          ),margin: EdgeInsets.symmetric(vertical: 5),);
                        },itemCount: value.notifications.length),
                  ),
                  if(value.isLoading)
                    CircularProgressIndicator(color: kPrimaryColor,)
                ],
              ),
        ),
      ),
    );
  }
}
