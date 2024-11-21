import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/category_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/category_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:provider/provider.dart';

import '../shimmer/category_shimmer.dart';

class CategoryView extends StatelessWidget {
  final bool isHomePage;
  const CategoryView({Key? key,  required this.isHomePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return categoryProvider.categoryList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 1200,
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    primary: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.45,
                          mainAxisSpacing: 10,
                    ),
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: categoryProvider.categoryList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                     // print("data is here ${categoryProvider.categoryList[index].id}");
                      return InkWell(
                        onTap: () {
                        //  print("ID  is here ${categoryProvider.categoryList[index].id}");
                          print("Name is here ${categoryProvider.categoryList[index].name}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BrandAndCategoryProductScreen(
                                        isBrand: false,
                                        id: categoryProvider
                                            .categoryList[index].id
                                            .toString(),
                                        name: categoryProvider
                                            .categoryList[index].name,
                                      ))
                          );
                        },

                          child: Center(
                            child: CategoryWidget(
                                category: categoryProvider.categoryList[index],
                                index: index,
                                length: categoryProvider.categoryList.length),
                          ),
                      );
                    },
                  ),
                ),
              )
            : const CategoryShimmer();
      },
    );
  }
}
