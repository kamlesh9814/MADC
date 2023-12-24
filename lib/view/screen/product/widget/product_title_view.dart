import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_details_model.dart'
    as pd;
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/rating_bar.dart';
import 'package:provider/provider.dart';

class ProductTitleView extends StatefulWidget {
  final pd.ProductDetailsModel? productModel;
  final String? averageRatting;
  const ProductTitleView(
      {Key? key, required this.productModel, this.averageRatting})
      : super(key: key);

  @override
  State<ProductTitleView> createState() => _ProductTitleViewState();
}

class _ProductTitleViewState extends State<ProductTitleView> {
  String variation = '';

  @override
  void initState() {
    super.initState();
    if (widget.productModel!.choiceOptions != null &&
        widget.productModel!.choiceOptions!.isNotEmpty) {
      variation = widget.productModel!.choiceOptions![0].options![0];
    }
    onChnageValue(variation);
  }

  double? price;
  onChnageValue(String value) {
    if (widget.productModel!.variation != null &&
        widget.productModel!.variation!.isNotEmpty) {
      price = widget.productModel!.variation!
          .where((element) => element.type == value.replaceAll(' ', ''))
          .first
          .price;
    } else {
      price = widget.productModel!.unitPrice;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double? startingPrice = 0;
    double? endingPrice;
    if (widget.productModel!.variation != null &&
        widget.productModel!.variation!.isNotEmpty) {
      List<double?> priceList = [];
      for (var variation in widget.productModel!.variation!) {
        priceList.add(variation.price);
      }
      priceList.sort((a, b) => a!.compareTo(b!));
      startingPrice = priceList[0];
      if (priceList[0]! < priceList[priceList.length - 1]!) {
        endingPrice = priceList[priceList.length - 1];
      }
    } else {
      startingPrice = widget.productModel!.unitPrice;
    }

    return widget.productModel != null
        ? Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.homePagePadding),
            child: Consumer<ProductDetailsProvider>(
              builder: (context, details, child) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.productModel!.name ?? '',
                          style: titleRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge),
                          maxLines: 2),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: Dimensions.paddingSizeDefault),
                        child: Row(
                          children: [
                            // Text(
                            //   '${startingPrice != null ? PriceConverter.convertPrice(context, startingPrice, discount: widget.productModel!.discount, discountType: widget.productModel!.discountType) : ''}'
                            //   '${endingPrice != null ? ' - ${PriceConverter.convertPrice(context, endingPrice, discount: widget.productModel!.discount, discountType: widget.productModel!.discountType)}' : ''}',
                            //   style: titilliumBold.copyWith(
                            //       color: ColorResources.getPrimary(context),
                            //       fontSize: Dimensions.fontSizeLarge),
                            // ),
                            Text(
                                price != null
                                    ? PriceConverter.convertPrice(
                                        context,
                                        price,
                                        discount: widget.productModel!.discount,
                                        discountType:
                                            widget.productModel!.discountType,
                                      )
                                    : '',
                                style: titilliumBold.copyWith(
                                    color: ColorResources.getPrimary(context),
                                    fontSize: Dimensions.fontSizeLarge)),
                            widget.productModel!.discount != null &&
                                    widget.productModel!.discount! > 0
                                ? Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeSmall),
                                      child: Text(
                                        '${PriceConverter.convertPrice(context, price)}',
                                        // '${endingPrice != null ? ' - ${PriceConverter.convertPrice(context, endingPrice)}' : ''}',
                                        style: titilliumRegular.copyWith(
                                            color: Theme.of(context).hintColor,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            Container(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeExtraSmall),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .error
                                      .withOpacity(.20),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeExtraSmall)),
                              child: Text(
                                PriceConverter.percentageCalculation(
                                    context,
                                    widget.productModel!.unitPrice,
                                    widget.productModel!.discount,
                                    widget.productModel!.discountType),
                                style: textRegular.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: Dimensions.fontSizeLarge),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: Dimensions.paddingSizeDefault),
                        child: Row(
                          children: [
                            RatingBar(
                                rating: widget.productModel!.reviews != null
                                    ? widget.productModel!.reviews!.isNotEmpty
                                        ? double.parse(widget.averageRatting!)
                                        : 0.0
                                    : 0.0),
                            Text('(${widget.productModel?.reviewsCount})')
                          ],
                        ),
                      ),
                      Row(children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text:
                                  '${details.reviewList != null ? details.reviewList!.length : 0} ',
                              style: textMedium.copyWith(
                                  color: Provider.of<ThemeProvider>(context,
                                              listen: false)
                                          .darkTheme
                                      ? Theme.of(context).hintColor
                                      : Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeDefault)),
                          TextSpan(
                              text: '${getTranslated('reviews', context)} | ',
                              style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                              ))
                        ])),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: '${details.orderCount} ',
                              style: textMedium.copyWith(
                                  color: Provider.of<ThemeProvider>(context,
                                              listen: false)
                                          .darkTheme
                                      ? Theme.of(context).hintColor
                                      : Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeDefault)),
                          TextSpan(
                              text: '${getTranslated('orders', context)} | ',
                              style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                              ))
                        ])),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: '${details.wishCount} ',
                              style: textMedium.copyWith(
                                  color: Provider.of<ThemeProvider>(context,
                                              listen: false)
                                          .darkTheme
                                      ? Theme.of(context).hintColor
                                      : Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeDefault)),
                          TextSpan(
                              text: '${getTranslated('wish_listed', context)}',
                              style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                              ))
                        ])),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      widget.productModel!.colors != null &&
                              widget.productModel!.colors!.isNotEmpty
                          ? Row(children: [
                              Text(
                                  '${getTranslated('select_variant', context)} : ',
                                  style: titilliumRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge)),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: ListView.builder(
                                    itemCount:
                                        widget.productModel!.colors!.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      String colorString =
                                          '0xff${widget.productModel!.colors![index].code!.substring(1, 7)}';
                                      return Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(Dimensions
                                                      .paddingSizeExtraSmall)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                Dimensions
                                                    .paddingSizeExtraSmall),
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              padding: const EdgeInsets.all(
                                                  Dimensions
                                                      .paddingSizeExtraSmall),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Color(
                                                    int.parse(colorString)),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ])
                          : const SizedBox(),
                      widget.productModel!.colors != null &&
                              widget.productModel!.colors!.isNotEmpty
                          ? const SizedBox(height: Dimensions.paddingSizeSmall)
                          : const SizedBox(),
                      widget.productModel!.choiceOptions != null &&
                              widget.productModel!.choiceOptions!.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  widget.productModel!.choiceOptions!.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          '${getTranslated('available', context)} ${widget.productModel!.choiceOptions![index].title} :',
                                          style: titilliumRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeLarge)),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: SizedBox(
                                            height: 40,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: widget
                                                  .productModel!
                                                  .choiceOptions![index]
                                                  .options!
                                                  .length,
                                              itemBuilder: (context, i) {
                                                return InkWell(
                                                  onTap: () {
                                                    variation = widget
                                                        .productModel!
                                                        .choiceOptions![index]
                                                        .options![i];

                                                    onChnageValue(variation);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .paddingSizeExtraSmall),
                                                        border: variation ==
                                                                widget
                                                                    .productModel!
                                                                    .choiceOptions![
                                                                        index]
                                                                    .options![i]
                                                            ? Border.all(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                width: 1.5)
                                                            : null),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 5,
                                                                vertical: 5),
                                                        child: Text(
                                                            widget
                                                                .productModel!
                                                                .choiceOptions![
                                                                    index]
                                                                .options![i]
                                                                .trim(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: textRegular.copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeLarge,
                                                                color: Provider.of<ThemeProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .darkTheme
                                                                    ? Colors
                                                                        .white
                                                                    : Theme.of(
                                                                            context)
                                                                        .primaryColor)),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]);
                              },
                            )
                          : const SizedBox(),
                    ]);
              },
            ),
          )
        : const SizedBox();
  }
}
