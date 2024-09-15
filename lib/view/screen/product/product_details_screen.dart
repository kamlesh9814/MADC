import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/check_tat_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/shimmer/product_details_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/promise_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/review_section.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/seller_view.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/bottom_cart_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_image_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_specification_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_title_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/related_product_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/youtube_video_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/shop/widget/shop_product_view_list.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final int? productId;
  final String? slug;
  final bool isFromWishList;
  const ProductDetails(
      {Key? key,
      required this.productId,
      required this.slug,
      this.isFromWishList = false})
      : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final TextEditingController checkTat = TextEditingController();
  _loadData(BuildContext context) async {
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getProductDetails(context, widget.slug.toString());
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .removePrevReview();
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .initProduct(widget.productId, widget.slug, context);
    Provider.of<ProductProvider>(context, listen: false)
        .removePrevRelatedProduct();
    Provider.of<ProductProvider>(context, listen: false)
        .initRelatedProductList(widget.productId.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getCount(widget.productId.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getSharableLink(widget.slug.toString(), context);
  }

  @override
  void initState() {
    _loadData(context);
    super.initState();
  }

  bool isReview = false;
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('product_details', context)),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(context),
        child: Consumer<ProductDetailsProvider>(
          builder: (context, details, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: !details.isDetails
                  ? Column(
                      children: [
                        ProductImageView(
                            productModel: details.productDetailsModel),
                        Column(
                          children: [
                            ProductTitleView(
                                productModel: details.productDetailsModel,
                                averageRatting: details.productDetailsModel
                                            ?.averageReview !=
                                        null
                                    ? details.productDetailsModel!.averageReview
                                    : "0"),

                Consumer<CheckTatProvider>(
                  builder: (context, checkTatProvider, child) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0), // Add padding around the whole column
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align messages to the left
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0), // Padding below the row
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Align items to the start
                              crossAxisAlignment: CrossAxisAlignment.center, // Centers items vertically
                              children: [
                                const Text("Delivery :",style: TextStyle(fontSize: 14,)),
                                const SizedBox(width: 3,),
                                Expanded(
                                  child:
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: checkTat,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.black,
                                      isDense: true,
                                      hintText: 'Enter the pin code ',
                                      hintStyle: TextStyle(color: Colors.grey , fontSize: 14 ,fontWeight: FontWeight.normal), // Optional: Change hint text color
                                      prefixIcon: Icon(Icons.telegram_sharp, color: ColorResources.black ,size: 20,), // Add location icon
                                    ),
                                    onChanged: (value) {
                                      // Map payload = {
                                      //   'product_id': widget.productId,
                                      //   'pincode': checkTat.text,
                                      // };
                                      // print('load is $payload');
                                      // checkTatProvider.postCheckTat(payload);
                                    },
                                  )

                                ),
                                const SizedBox(width: 10), // Space between the form field and button
                                TextButton(
                                  onPressed: () {
                                    Map payload = {
                                      'product_id': widget.productId,
                                      'pincode': checkTat.text,
                                    };
                                    print('load is $payload');
                                    checkTatProvider.postCheckTat(payload);
                                  },
                                  child: const Text('Check'),
                                ),
                              ],
                            ),
                          ),
                          // Display success message after API response
                          if (checkTatProvider.successMessage != null &&
                              checkTatProvider.successMessage!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0), // Add padding around message
                              child: Text(
                                'The Product will be Delivered in ${checkTatProvider.successMessage!}',
                                style: const TextStyle(color: Colors.green),
                                overflow: TextOverflow.ellipsis, // Handle long text
                              ),
                            ),

                        ],
                      ),
                    );
                  },
                ),





                Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeDefault),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          isReview = false;
                                        });
                                      },
                                      child: Column(children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeDefault,
                                              vertical:
                                                  Dimensions.paddingSizeSmall),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(Dimensions
                                                      .paddingSizeExtraSmall),
                                              color: !isReview
                                                  ? Provider.of<ThemeProvider>(
                                                              context,
                                                              listen: false)
                                                          .darkTheme
                                                      ? Theme.of(context)
                                                          .hintColor
                                                          .withOpacity(.25)
                                                      : Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(.05)
                                                  : Colors.transparent),
                                          child: Text(
                                            '${getTranslated('specification', context)}',
                                            style: textRegular.copyWith(
                                                color:
                                                    Provider.of<ThemeProvider>(
                                                                context,
                                                                listen: false)
                                                            .darkTheme
                                                        ? Theme.of(context)
                                                            .hintColor
                                                        : Theme.of(context)
                                                            .primaryColor),
                                          ),
                                        ),
                                        if (!isReview)
                                          Container(
                                            width: 60,
                                            height: 3,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )
                                      ])),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeDefault),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isReview = true;
                                      });
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Column(children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeDefault,
                                                vertical: Dimensions
                                                    .paddingSizeSmall),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(Dimensions
                                                        .paddingSizeExtraSmall),
                                                color: isReview
                                                    ? Provider.of<ThemeProvider>(
                                                                context,
                                                                listen: false)
                                                            .darkTheme
                                                        ? Theme.of(context)
                                                            .hintColor
                                                            .withOpacity(.25)
                                                        : Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(.05)
                                                    : Colors.transparent),
                                            child: Text(
                                              '${getTranslated('reviews', context)}',
                                              style: textRegular.copyWith(
                                                  color:
                                                      Provider.of<ThemeProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .darkTheme
                                                          ? Theme.of(context)
                                                              .hintColor
                                                          : Theme.of(context)
                                                              .primaryColor),
                                            ),
                                          ),
                                          if (isReview)
                                            Container(
                                                width: 60,
                                                height: 3,
                                                color: Theme.of(context)
                                                    .primaryColor)
                                        ]),
                                        Positioned(
                                          top: -10,
                                          right: -10,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Center(
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .paddingSizeDefault),
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: Dimensions
                                                            .paddingSizeExtraSmall,
                                                        horizontal: Dimensions
                                                            .paddingSizeSmall),
                                                    child: Text(
                                                      '${details.reviewList != null ? details.reviewList!.length : 0}',
                                                      style: textRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            isReview
                                ? ReviewSection(details: details)
                                : Column(
                                    children: [
                                      (details.productDetailsModel?.details !=
                                                  null &&
                                              details.productDetailsModel!
                                                  .details!.isNotEmpty)
                                          ? Container(
                                              height: 250,
                                              margin: const EdgeInsets.only(
                                                  top: Dimensions
                                                      .paddingSizeSmall),
                                              padding: const EdgeInsets.all(
                                                  Dimensions.paddingSizeSmall),
                                              child: ProductSpecification(
                                                  productSpecification: details
                                                          .productDetailsModel!
                                                          .details ??
                                                      ''),
                                            )
                                          : const SizedBox(),
                                      details.productDetailsModel?.videoUrl !=
                                              null
                                          ? YoutubeVideoWidget(
                                              url: details.productDetailsModel!
                                                  .videoUrl)
                                          : const SizedBox(),
                                      (details.productDetailsModel != null &&
                                              details.productDetailsModel!
                                                      .addedBy ==
                                                  'seller')
                                          ? SellerView(
                                              sellerId: details
                                                  .productDetailsModel!.userId
                                                  .toString())
                                          : const SizedBox.shrink(),
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .paddingSizeDefault),
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor),
                                          child: const PromiseScreen()),
                                      (details.productDetailsModel != null &&
                                              details.productDetailsModel!
                                                      .addedBy ==
                                                  'seller')
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: Dimensions
                                                          .paddingSizeDefault),
                                              child: TitleRow(
                                                  title: getTranslated(
                                                      'more_from_the_shop',
                                                      context),
                                                  isDetailsPage: true),
                                            )
                                          : const SizedBox(),
                                      details.productDetailsModel!.addedBy ==
                                              'seller'
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeDefault),
                                              child: ShopProductViewList(
                                                  scrollController:
                                                      scrollController,
                                                  sellerId: details
                                                      .productDetailsModel!
                                                      .userId!))
                                          : const SizedBox(),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: Dimensions
                                                    .paddingSizeExtraSmall),
                                            child: TitleRow(
                                                title: getTranslated(
                                                    'related_products',
                                                    context),
                                                isDetailsPage: true),
                                          ),
                                          const SizedBox(height: 5),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeDefault),
                                            child: RelatedProductView(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ],
                    )
                  : const ProductDetailsShimmer(),
            );
          },
        ),
      ),
      bottomNavigationBar:
          Consumer<ProductDetailsProvider>(builder: (context, details, child) {
        return !details.isDetails
            ? BottomCartView(product: details.productDetailsModel)
            : const SizedBox();
      }),
    );
  }
}
