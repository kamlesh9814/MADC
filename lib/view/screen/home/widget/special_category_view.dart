import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/category_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/category_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:provider/provider.dart';

import '../shimmer/category_shimmer.dart';

class SpecialCategoryView extends StatelessWidget {
  final bool isHomePage;
  SpecialCategoryView({Key? key, required this.isHomePage}) : super(key: key);

  final List _scName = [
    'FPO/FPC',
    'Mahila Bachat Gat',
    'Blind Org',
    'Prison Org'
  ];
  final List _scImage = [
    'scimgfpo.png',
    'scimgmahila.jpg',
    'scimgblind.jpg',
    'scimgprison.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return SizedBox(
          height: 180,
          child: ListView.builder(
            physics:const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: _scName.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset('assets/images/${_scImage[index]}',fit: BoxFit.cover,height:150)),
                        Text(_scName[index])
                      ],
                    ),
                  ));
            },
          ),
        );
      },
    );
  }
}
