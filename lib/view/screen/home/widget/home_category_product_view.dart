import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/home_category_product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class HomeCategoryProductView extends StatefulWidget {
  final bool isHomePage;
  const HomeCategoryProductView({Key? key, required this.isHomePage}) : super(key: key);

  @override
  _HomeCategoryProductViewState createState() => _HomeCategoryProductViewState();
}

class _HomeCategoryProductViewState extends State<HomeCategoryProductView> {
  // Map to hold expanded state for each category
  Map<int, bool> _expandedState = {};

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeCategoryProductProvider>(
      builder: (context, homeCategoryProductProvider, child) {
        return homeCategoryProductProvider.homeCategoryProductList.isNotEmpty
            ? ListView.builder(
            itemCount: homeCategoryProductProvider.homeCategoryProductList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) {
              bool isExpanded = _expandedState[index] ?? false;

              return Container(
                color: index.isEven
                    ? Theme.of(context).primaryColor.withOpacity(.125)
                    : Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1,top: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(

                            child: TitleRow(
                              title: homeCategoryProductProvider.homeCategoryProductList[index].name,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BrandAndCategoryProductScreen(
                                            isBrand: false,
                                            id: homeCategoryProductProvider.homeCategoryProductList[index].id.toString(),
                                            name: homeCategoryProductProvider.homeCategoryProductList[index].name)));
                              },
                            ),
                          ),
                          // Dropdown Icon
                          IconButton(
                            icon: Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                            onPressed: () {
                              setState(() {
                                _expandedState[index] = !isExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // Show products if expanded
                    isExpanded
                        ? ConstrainedBox(
                      constraints: homeCategoryProductProvider
                          .homeCategoryProductList[index].products!.isNotEmpty
                          ? const BoxConstraints(maxHeight: 1000)
                          : const BoxConstraints(maxHeight: 0),
                      child: MasonryGridView.count(
                          itemCount: (widget.isHomePage &&
                              homeCategoryProductProvider.homeCategoryProductList[index].products!.length > 4)
                              ? 4
                              : homeCategoryProductProvider.homeCategoryProductList[index].products!.length,
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          physics: const BouncingScrollPhysics(),
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int i) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 1000),
                                      pageBuilder: (context, anim1, anim2) => ProductDetails(
                                        productId: homeCategoryProductProvider.productList![i].id,
                                        slug: homeCategoryProductProvider.productList![i].slug,
                                      ),
                                    ));
                              },
                              child: SizedBox(
                                  width: (MediaQuery.of(context).size.width / 2) - 20,
                                  child: ProductWidget(
                                      productModel: homeCategoryProductProvider
                                          .homeCategoryProductList[index]
                                          .products![i])),
                            );
                          }),
                    )
                        : const SizedBox(),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ],
                ),
              );
            })
            : const SizedBox();
      },
    );
  }
}
