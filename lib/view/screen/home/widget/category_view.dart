import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/category_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/category_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:provider/provider.dart';

import '../shimmer/category_shimmer.dart';

class CategoryView extends StatelessWidget {
  final bool isHomePage;
  const CategoryView({Key? key, required this.isHomePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return categoryProvider.categoryList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 1100,
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    primary: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.45,
                    ),
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: categoryProvider.categoryList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
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
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: CategoryWidget(
                                category: categoryProvider.categoryList[index],
                                index: index,
                                length: categoryProvider.categoryList.length),
                          ),
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
