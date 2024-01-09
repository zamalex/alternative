
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translatorclient/colors.dart';
import 'package:translatorclient/model/ldropdown_model.dart';


class CustomDropdownList extends StatefulWidget {
   CustomDropdownList({this.color = Colors.white,this.otherLang,Key? key,this.text='',this.title='',this.list,this.onSelect}) : super(key: key);

  String text;
  String title;
  List<DropdownModel>? list=[];
  Function? onSelect;
  int? otherLang;
  Color? color;



  @override
  _CustomDropdownListState createState() => _CustomDropdownListState();
}

class _CustomDropdownListState extends State<CustomDropdownList> {
  DropdownModel? selectedType;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title,style: TextStyle(color: kDarkTxtGrey),),
        Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          height: 56,
          decoration: BoxDecoration(color: widget.color,borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonFormField<DropdownModel>(
           value: selectedType == null ? selectedType : widget.list!.where( (i) => i.name == selectedType!.name).first as DropdownModel,
            isDense: true,
            isExpanded: true,
            decoration: InputDecoration.collapsed(
                //suffixIcon: Icon(Icons.keyboard_arrow_down_rounded,color: Colors.black,),
                hintText: widget.text,

            ),
            icon: Icon(Icons.keyboard_arrow_down),
            items: widget.list!.map((DropdownModel value) {
              return DropdownMenuItem<DropdownModel>(

                value: value,
                child: Text(value.name),
              );
            }).toList(),
            onChanged: (v) {
              setState(() {
                selectedType=v;
              });
              if(widget.onSelect!=null) {

                widget.onSelect!(v!.id);

              }
            },
          )
          ,
        ),
      ],
    );
  }
}
