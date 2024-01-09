import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translatorclient/providers/home_provider.dart';

class HomeSlider extends StatefulWidget {
  final sliderImages = [
    'assets/images/woman-holding-glass.jpg',
    'assets/images/drink.jpeg'
  ];

  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int _current = 0;

  List<Widget> getChild() {

    return /*Provider.of<HomeProvider>(context).sliders*/widget.sliderImages.map((i) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          // margin: EdgeInsets.all(5.0),
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: '${i}'??'',
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.asset('assets/images/icons.jpg',fit:BoxFit.cover),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.bottomCenter,
        children: [
      CarouselSlider(
        options: CarouselOptions(
          height: 200,
          viewportFraction: 1,
          autoPlay: false,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        ),
        items: getChild(),
      ),
      Positioned(
        bottom: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.sliderImages.map((image) {
            int index = widget.sliderImages.indexOf(image);
            return Container(
              width: 20.0,
              height: 2.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: _current == index
                      ? Colors.white
                      : Colors.grey),
            );
          }).toList(),
        ),
      ),
    ]);
  }
}
