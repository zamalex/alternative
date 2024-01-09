import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/model/categories_model.dart';
import 'package:translatorclient/providers/home_provider.dart';
import 'package:translatorclient/subcategory_translators_screen.dart';

import 'colors.dart';
import 'main_category_translators_screen.dart';


class SubcategoriesScreen extends StatefulWidget {
  const SubcategoriesScreen({required this.category,Key? key}) : super(key: key);

  final Category category;

  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value){
      Provider.of<HomeProvider>(context,listen: false).getSubCategories(widget.category.id.toString()).then((value){
        if((value['data']as List).isEmpty){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){
            return MainCategoryTranslatorsScreen(category: widget.category,);
          }));
        }
      });
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
        title: Text(widget.category.name??'',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),
      body: Consumer<HomeProvider>(
        builder:(context, value, child) =>  Container(
          padding: EdgeInsets.all(10),
          height: double.infinity,
          child: GridView.builder(gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width>400?2:2,crossAxisSpacing: 5,mainAxisSpacing: 5,mainAxisExtent: 200), itemBuilder: (context, index) {
            return Container(
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_){
                    return SubCategoryTranslatorsScreen(category: value.subCategories[index],);
                  }));
                },
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: value.subCategories[index].image!,
                        width: 165,
                        height: 165,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset('assets/images/icon.png'),
                      ),
                    ),
                    Container(width:165,child: Text(value.subCategories[index].name??'',textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,))
                  ],
                ),
              ),
            );
          },itemCount: value.subCategories.length,)
        ),
      ),
    );
  }
}
