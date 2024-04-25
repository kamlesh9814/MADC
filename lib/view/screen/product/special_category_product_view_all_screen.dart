import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class SpecialCategoryProductScreen extends StatelessWidget {
  final int id;
  final String? name;

  const SpecialCategoryProductScreen({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    context.read<ProductProvider>().getSpecialCategoryProducts(categoryID: id);
    return Scaffold(
      appBar: CustomAppBar(title: name),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return productProvider.isLoading
              ? const ProductShimmer(isEnabled: true, isHomePage: false)
              : productProvider
                      .specialCategoryProductModel!.sellerProducts.isEmpty
                  ? Center(
                      child: Text("No products found"),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                          Expanded(
                            child: MasonryGridView.count(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall),
                              physics: const BouncingScrollPhysics(),
                              crossAxisCount: 2,
                              itemCount: productProvider
                                  .specialCategoryProductModel
                                  ?.sellerProducts
                                  .length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                final product = productProvider
                                    .specialCategoryProductModel!
                                    .sellerProducts[index];
                                return SpecialCategoryProductWidget(
                                    productModel: product);
                              },
                            ),
                          )
                        ]);
        },
      ),
    );
  }
}
