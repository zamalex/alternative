import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/colors.dart';
import 'package:translatorclient/model/categories_model.dart';
import 'package:translatorclient/providers/translators_provider.dart';
import 'package:translatorclient/translator_list_item.dart';

class SubCategoryTranslatorsScreen extends StatefulWidget {
  SubCategoryTranslatorsScreen({Key? key,required this.category}) : super(key: key);
  Category category;

  @override
  State<SubCategoryTranslatorsScreen> createState() => _SubCategoryTranslatorsScreenState();
}

class _SubCategoryTranslatorsScreenState extends State<SubCategoryTranslatorsScreen> {

  ScrollController _scrollController = new ScrollController();

 @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value){
      Provider.of<TranslatorsProvider>(context,listen: false).initPage();
      Provider.of<TranslatorsProvider>(context,listen: false).getBrandProducts(widget.category.id!,null);
    });

    _scrollController
        .addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Future.delayed(Duration.zero).then((value){
          Provider.of<TranslatorsProvider>(context,listen: false).getBrandProducts(widget.category.id!,null);

        });        }
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
      body: Consumer<TranslatorsProvider>(
        builder:(context, value, child) =>  Column(
          children: [
            Expanded(

              child: ListView.builder(controller:_scrollController,itemBuilder: (context, index) {
                return TranslatorListItem(translator:value.categoryTranslators[index] ,);
              },itemCount: value.categoryTranslators.length,),
            ),
            !value.isLoading?Container():Center(child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator()),)
          ],
        ),
      ),
    );
  }
}
