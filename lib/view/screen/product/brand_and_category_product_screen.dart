import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_image.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class BrandAndCategoryProductScreen extends StatefulWidget {
  final bool isBrand;
  final String id;
  final String? name;
  final String? image;

  const BrandAndCategoryProductScreen(
      {Key? key,
        required this.isBrand,
        required this.id,
        required this.name,
        this.image})
      : super(key: key);

  @override
  _BrandAndCategoryProductScreenState createState() => _BrandAndCategoryProductScreenState();
}

class _BrandAndCategoryProductScreenState extends State<BrandAndCategoryProductScreen> {
  String _selectedSortOption = 'Latest'; // Default sort option

  // Function to handle sorting
  void _sortProducts(ProductProvider productProvider) {
    switch (_selectedSortOption) {
      case 'Latest':
        productProvider.brandOrCategoryProductList.sort(
                (a, b) => a.addedBy!.toLowerCase().compareTo(b.addedBy!.toLowerCase()));
        break;

      case 'A to Z':
        productProvider.brandOrCategoryProductList.sort(
                (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        break;
      case 'Z to A':
        productProvider.brandOrCategoryProductList.sort(
                (a, b) => b.name!.toLowerCase().compareTo(a.name!.toLowerCase()));
        break;
      case 'Low to High Price':
        productProvider.brandOrCategoryProductList.sort(
                (a, b) => a.unitPrice!.compareTo(b.unitPrice as num));
        break;
      case 'High to Low Price':
        productProvider.brandOrCategoryProductList.sort(
                (a, b) => b.unitPrice!.compareTo(a.unitPrice as num));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false)
        .initBrandOrCategoryProductList(widget.isBrand, widget.id, context);

    return Scaffold(
      appBar: CustomAppBar(title: widget.name),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          // Apply sorting whenever product list is fetched
          _sortProducts(productProvider);

          return
            Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dropdown for sorting
             Align(
                  alignment: Alignment.topRight, // Align to top-right corner
                  child: PopupMenuButton<String>(
                    onSelected: (newValue) {
                      setState(() {
                        _selectedSortOption = newValue;
                        _sortProducts(productProvider); // Sort based on the new option
                      });
                    },
                    icon: const Icon(Icons.sort), // Custom icon for the popup button
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Latest',
                        child: Text('Latest'),
                      ),
                      const PopupMenuItem(
                        value: 'A to Z',
                        child: Text('A to Z'),
                      ),
                      const PopupMenuItem(
                        value: 'Z to A',
                        child: Text('Z to A'),
                      ),
                      const PopupMenuItem(
                        value: 'Low to High Price',
                        child: Text('Low to High Price'),
                      ),
                      const PopupMenuItem(
                        value: 'High to Low Price',
                        child: Text('High to Low Price'),
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Set the border radius for rounded corners
                    ),
                    offset: const Offset(0, 50), // Position the popup menu
                    tooltip: 'Sort By', // Tooltip for the button
                  ),
                ),

              widget.isBrand
                  ? Container(
                height: 100,
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                color: Theme.of(context).highlightColor,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImage(
                        image:
                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.brandImageUrl}/${widget.image}',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Text(widget.name!,
                          style: titilliumSemiBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge)),
                    ]),
              )
                  : const SizedBox.shrink(),

              const SizedBox(height: Dimensions.paddingSizeSmall),

              // Products
              productProvider.brandOrCategoryProductList.isNotEmpty
                  ? Expanded(
                child: MasonryGridView.count(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall),
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  itemCount: productProvider.brandOrCategoryProductList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductWidget(
                      categoryname:widget.name,
                        productModel: productProvider.brandOrCategoryProductList[index]);
                  },
                ),
              )
                  : Expanded(
                  child: productProvider.hasData!
                      ? ProductShimmer(
                      isHomePage: false,
                      isEnabled: Provider.of<ProductProvider>(context)
                          .brandOrCategoryProductList
                          .isEmpty)
                      : const NoInternetOrDataScreen(
                    isNoInternet: false,
                    icon: Images.noProduct,
                    message: 'no_product_found',
                  )),
            ],
          );
        },
      ),
    );
  }
}
