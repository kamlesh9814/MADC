import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/coupon_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/not_logged_in_bottom_sheet.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/order_place_success_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/widget/cart_page_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/widget/cart_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/checkout_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/widget/shipping_details_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/widget/shipping_method_bottom_sheet.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/widget/wallet_payment.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/offline_payment/offline_payment.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final bool fromCheckout;
  final int sellerId;
  final bool hasPhysical;
  final bool onlyDigital;
  final List<CartModel> cartList;
  final double shippingFee;
  final double discount;
  final double tax;

  const CartScreen({
    Key? key,
    this.fromCheckout = false,
    this.sellerId = 1,
    this.hasPhysical = true,
    this.onlyDigital = false,
    required this.cartList,
    this.shippingFee = 0,
    this.discount = 0,
    this.tax = 0,
  }) : super(key: key);

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  late bool _billingAddress;
  double? _couponDiscount;
  double _order = 0;
  String? gstText;

  Future<void> _loadData() async {
    await Provider.of<CartProvider>(Get.context!, listen: false)
        .getCartDataAPI(Get.context!);
    Provider.of<CartProvider>(Get.context!, listen: false).setCartData();
    if (Provider.of<SplashProvider>(Get.context!, listen: false)
            .configModel!
            .shippingMethod !=
        'sellerwise_shipping') {
      Provider.of<CartProvider>(Get.context!, listen: false)
          .getAdminShippingMethodList(Get.context!);
    }
  }

  List<bool> chooseShipping = [];

  @override
  void initState() {
    _loadData();
    _billingAddress = Provider.of<SplashProvider>(Get.context!, listen: false)
            .configModel!
            .billingInputByCustomer ==
        1;
    Provider.of<ProfileProvider>(context, listen: false)
        .initAddressTypeList(context);
    Provider.of<ProfileProvider>(context, listen: false).initAddressList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, configProvider, _) {
      return Consumer<CartProvider>(builder: (context, cart, child) {
        return Consumer<ProfileProvider>(
            builder: (context, profileProvider, _) {
          return Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
            return Consumer<CouponProvider>(
                builder: (context, couponProvider, _) {
              return Consumer<OrderProvider>(
                  builder: (context, orderProvider, child) {
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: CustomButton(
                    onTap: () async {
                      if (orderProvider.addressIndex == null &&
                          !widget.onlyDigital) {
                        showCustomSnackBar(
                            getTranslated('select_a_shipping_address', context),
                            context,
                            isToaster: true);
                      } else if (orderProvider.billingAddressIndex == null) {
                        showCustomSnackBar(
                            getTranslated('select_a_billing_address', context),
                            context,
                            isToaster: true);
                      } else {
                        List<CartModel> cartList = [];
                        cartList.addAll(widget.cartList);

                        for (int index = 0;
                            index < widget.cartList.length;
                            index++) {
                          for (int i = 0;
                              i < cart.chosenShippingList.length;
                              i++) {
                            if (cart.chosenShippingList[i].cartGroupId ==
                                widget.cartList[index].cartGroupId) {
                              cartList[index].shippingMethodId =
                                  cart.chosenShippingList[i].id;
                              break;
                            }
                          }
                        }

                        String orderNote =
                            orderProvider.orderNoteController.text.trim();
                        String couponCode = couponProvider.discount != null &&
                                couponProvider.discount != 0
                            ? couponProvider.couponCode
                            : '';

                        String couponCodeAmount =
                            couponProvider.discount != null &&
                                    couponProvider.discount != 0
                                ? couponProvider.discount.toString()
                                : '0';

                        String addressId = !widget.onlyDigital
                            ? profileProvider
                                .addressList[orderProvider.addressIndex!].id
                                .toString()
                            : '';

                        String billingAddressId = (_billingAddress)
                            ? profileProvider
                                .billingAddressList[
                                    orderProvider.billingAddressIndex!]
                                .id
                                .toString()
                            : '';

                        if (orderProvider.paymentMethodIndex != -1) {
                          // orderProvider.digitalPayment(
                          //     orderNote: orderNote,
                          //     customerId: Provider.of<AuthProvider>(context,
                          //                 listen: false)
                          //             .isLoggedIn()
                          //         ? profileProvider.userInfoModel?.id.toString()
                          //         : Provider.of<AuthProvider>(context,
                          //                 listen: false)
                          //             .getGuestToken(),
                          //     addressId: addressId,
                          //     billingAddressId: billingAddressId,
                          //     couponCode: couponCode,
                          //     couponDiscount: couponCodeAmount,
                          //     paymentMethod:
                          //         orderProvider.selectedDigitalPaymentMethodName);
                          orderProvider.webPayment(
                              orderNote: orderNote,
                              customerId: Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .isLoggedIn()
                                  ? profileProvider.userInfoModel?.id.toString()
                                  : Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .getGuestToken(),
                              addressId: addressId,
                              billingAddressId: billingAddressId,
                              couponCode: couponCode,
                              couponDiscount: couponCodeAmount,
                              paymentMethod: orderProvider
                                  .selectedDigitalPaymentMethodName);
                        } else if (orderProvider.codChecked &&
                            !widget.onlyDigital) {
                          orderProvider.placeOrder(
                              callback: _callback,
                              addressID: widget.onlyDigital ? '' : addressId,
                              couponCode: couponCode,
                              couponAmount: couponCodeAmount,
                              billingAddressId: _billingAddress
                                  ? billingAddressId
                                  : widget.onlyDigital
                                      ? ''
                                      : addressId,
                              orderNote: orderNote);
                        } else if (orderProvider.offlineChecked) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => OfflinePaymentScreen(
                                  payableAmount: _order, callback: _callback)));
                        } else if (orderProvider.walletChecked) {
                          showAnimatedDialog(context, Consumer<ProfileProvider>(
                              builder: (context, profile, _) {
                            print("tax amount ${widget.discount}");
                            return WalletPayment(
                              currentBalance: profile.balance,
                              orderAmount: _order +
                                  widget.shippingFee -
                                  widget.discount -
                                  _couponDiscount! +
                                  widget.tax,
                              onTap: () {
                                if (profile.balance! <
                                    (_order +
                                        widget.shippingFee -
                                        widget.discount -
                                        _couponDiscount! +
                                        widget.tax)) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'insufficient_balance', context),
                                      context,
                                      isToaster: true);
                                } else {
                                  Navigator.pop(context);
                                  orderProvider.placeOrder(
                                      callback: _callback,
                                      wallet: true,
                                      addressID: widget.onlyDigital
                                          ? ''
                                          : profileProvider
                                              .addressList[
                                                  orderProvider.addressIndex!]
                                              .id
                                              .toString(),
                                      couponCode: couponCode,
                                      couponAmount: couponCodeAmount,
                                      billingAddressId: _billingAddress
                                          ? profileProvider
                                              .billingAddressList[orderProvider
                                                  .billingAddressIndex!]
                                              .id
                                              .toString()
                                          : widget.onlyDigital
                                              ? ''
                                              : profileProvider
                                                  .addressList[orderProvider
                                                      .addressIndex!]
                                                  .id
                                                  .toString(),
                                      orderNote: orderNote);
                                }
                              },
                            );
                          }), dismissible: false, isFlip: true);
                        } else {}
                      }

                      /** .................................................................................. **/
                    },
                    buttonText: '${getTranslated('proceed', context)}',
                  ),
                );

                double amount = 0.0;
                double shippingAmount = 0.0;
                double discount = 0.0;
                double tax = 0.0;
                int totalQuantity = 0;
                int totalPhysical = 0;
                bool onlyDigital = true;
                List<CartModel> cartList = [];
                cartList.addAll(cart.cartList);

                for (CartModel cart in cartList) {
                  if (cart.productType == "physical") {
                    onlyDigital = false;
                  }
                }

                List<String?> orderTypeShipping = [];
                List<String?> sellerList = [];
                List<List<String>> productType = [];
                List<CartModel> sellerGroupList = [];
                List<List<CartModel>> cartProductList = [];
                List<List<int>> cartProductIndexList = [];
                for (CartModel cart in cartList) {
                  if (!sellerList.contains(cart.cartGroupId)) {
                    sellerList.add(cart.cartGroupId);
                    sellerGroupList.add(cart);
                  }
                }

                // totalQuantity = cartList.length;

                for (String? seller in sellerList) {
                  List<CartModel> cartLists = [];
                  List<int> indexList = [];
                  List<String> productTypeList = [];
                  for (CartModel cart in cartList) {
                    if (seller == cart.cartGroupId) {
                      cartLists.add(cart);
                      indexList.add(cartList.indexOf(cart));
                      productTypeList.add(cart.productType!);
                    }
                  }
                  cartProductList.add(cartLists);
                  productType.add(productTypeList);
                  cartProductIndexList.add(indexList);
                }

                double freeDeliveryAmountDiscount = 0;
                for (var seller in sellerGroupList) {
                  if (seller.freeDeliveryOrderAmount?.status == 1) {
                    freeDeliveryAmountDiscount +=
                        seller.freeDeliveryOrderAmount!.shippingCostSaved!;
                  }
                  if (seller.shippingType == 'order_wise') {
                    orderTypeShipping.add(seller.shippingType);
                  }
                }

                if (cart.getData &&
                    configProvider.configModel!.shippingMethod ==
                        'sellerwise_shipping') {
                  cart.getShippingMethod(context, cartProductList);
                }

                for (int i = 0; i < cart.cartList.length; i++) {
                  totalQuantity += cart.cartList[i].quantity!;
                  amount +=
                      (cart.cartList[i].price! - cart.cartList[i].discount!) *
                          cart.cartList[i].quantity!;
                  discount +=
                      cart.cartList[i].discount! * cart.cartList[i].quantity!;
                  if (kDebugMode) {
                    print('====TaxModel == ${cart.cartList[i].taxModel}');
                  }
                  if (cart.cartList[i].taxModel == "exclude") {
                    tax += cart.cartList[i].tax! * cart.cartList[i].quantity!;
                    gstText = "exclude";
                  } else if (cart.cartList[i].taxModel == "include") {
                    tax += cart.cartList[i].tax! * cart.cartList[i].quantity!;
                    gstText = "include";
                  }
                }
                for (int i = 0; i < cart.chosenShippingList.length; i++) {
                  shippingAmount += cart.chosenShippingList[i].shippingCost!;
                }
                for (int j = 0; j < cartList.length; j++) {
                  shippingAmount += cart.cartList[j].shippingCost ?? 0;
                }

                return Scaffold(
                  bottomNavigationBar: (!cart.isXyz && cartList.isNotEmpty)
                      ? Consumer<SplashProvider>(
                          builder: (context, configProvider, _) {
                          return Container(
                              height: cartList.isNotEmpty ? 120 : 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeLarge,
                                  vertical: Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10))),
                              child: cartList.isNotEmpty
                                  ? Column(children: [
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .paddingSizeDefault),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(children: [
                                                  Text(
                                                      '${getTranslated('total_price', context)} ',
                                                      style: titilliumSemiBold.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge,
                                                          color: Provider.of<ThemeProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .darkTheme
                                                              ? Theme.of(
                                                                      context)
                                                                  .hintColor
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColor)),
                                                  Text(
                                                      '${getTranslated('inc_vat_tax', context)}',
                                                      style: titilliumSemiBold
                                                          .copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor))
                                                ]),
                                                gstText == "exclude"
                                                    ? Text(
                                                        PriceConverter.convertPrice(
                                                            context,
                                                            amount +
                                                                tax +
                                                                shippingAmount -
                                                                freeDeliveryAmountDiscount),
                                                        style: titilliumSemiBold.copyWith(
                                                            color: Provider.of<ThemeProvider>(context, listen: false).darkTheme
                                                                ? Theme.of(context)
                                                                    .hintColor
                                                                : Theme.of(context)
                                                                    .primaryColor,
                                                            fontSize: Dimensions
                                                                .fontSizeLarge))
                                                    : Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                context,
                                                                amount +
                                                                    // tax +
                                                                    shippingAmount -
                                                                    freeDeliveryAmountDiscount),
                                                        style: titilliumSemiBold.copyWith(
                                                            color: Provider.of<ThemeProvider>(context, listen: false).darkTheme
                                                                ? Theme.of(context).hintColor
                                                                : Theme.of(context).primaryColor,
                                                            fontSize: Dimensions.fontSizeLarge))
                                              ])),
                                      InkWell(
                                        onTap: () {
                                          bool hasNull = false;
                                          bool minimum = false;
                                          double total = 0;

                                          if (configProvider.configModel!
                                                  .shippingMethod ==
                                              'sellerwise_shipping') {
                                            for (int index = 0;
                                                index < cartProductList.length;
                                                index++) {
                                              for (CartModel cart
                                                  in cartProductList[index]) {
                                                if (cart.productType ==
                                                        'physical' &&
                                                    sellerGroupList[index]
                                                            .shippingType ==
                                                        'order_wise' &&
                                                    Provider.of<CartProvider>(
                                                                context,
                                                                listen: false)
                                                            .shippingList![
                                                                index]
                                                            .shippingIndex ==
                                                        -1) {
                                                  hasNull = true;
                                                  break;
                                                }
                                              }
                                            }
                                          }

                                          for (int index = 0;
                                              index < cartProductList.length;
                                              index++) {
                                            for (CartModel cart
                                                in cartProductList[index]) {
                                              total += (cart.price! -
                                                          cart.discount!) *
                                                      cart.quantity! +
                                                  tax +
                                                  shippingAmount;
                                              if (total <
                                                  cart.minimumOrderAmountInfo!) {
                                                minimum = true;
                                              }
                                            }
                                          }

                                          if (configProvider.configModel
                                                      ?.guestCheckOut ==
                                                  0 &&
                                              !Provider
                                                      .of<
                                                              AuthProvider>(
                                                          context,
                                                          listen: false)
                                                  .isLoggedIn()) {
                                            showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (_) =>
                                                    const NotLoggedInBottomSheet());
                                          } else if (cart.cartList.isEmpty) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'select_at_least_one_product',
                                                    context),
                                                context);
                                          } else if (hasNull &&
                                              configProvider.configModel!
                                                      .shippingMethod ==
                                                  'sellerwise_shipping' &&
                                              !onlyDigital) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'select_all_shipping_method',
                                                    context),
                                                context);
                                          } else if (orderProvider
                                                      .addressIndex ==
                                                  null &&
                                              !widget.onlyDigital) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'select_a_shipping_address',
                                                    context),
                                                context,
                                                isToaster: true);
                                          } else if (orderProvider
                                                  .billingAddressIndex ==
                                              null) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'select_a_billing_address',
                                                    context),
                                                context,
                                                isToaster: true);
                                          } else if (cart
                                                  .chosenShippingList.isEmpty &&
                                              configProvider.configModel!
                                                      .shippingMethod !=
                                                  'sellerwise_shipping' &&
                                              configProvider.configModel!
                                                      .inhouseSelectedShippingType ==
                                                  'order_wise' &&
                                              !onlyDigital) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'select_all_shipping_method',
                                                    context),
                                                context);
                                          } else if (minimum) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'some_shop_not_full_fill_minimum_order_amount',
                                                    context),
                                                context);
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        CheckoutScreen(
                                                          quantity:
                                                              totalQuantity,
                                                          cartList: cartList,
                                                          totalOrderAmount:
                                                              amount,
                                                          shippingFee:
                                                              shippingAmount -
                                                                  freeDeliveryAmountDiscount,
                                                          discount: discount,
                                                          tax: tax,
                                                          onlyDigital:
                                                              sellerGroupList
                                                                      .length !=
                                                                  totalPhysical,
                                                          hasPhysical:
                                                              totalPhysical > 0,
                                                        )));
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions
                                                          .paddingSizeSmall)),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall,
                                                      vertical: Dimensions
                                                          .fontSizeSmall),
                                              child: Text(
                                                  getTranslated(
                                                      'checkout', context)!,
                                                  style: titilliumSemiBold
                                                      .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeDefault,
                                                          color: Colors.white)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ])
                                  : const SizedBox());
                        })
                      : null,
                  appBar:
                      CustomAppBar(title: getTranslated('my_cart', context)),
                  body: Column(children: [
                    cart.isXyz
                        ? const Expanded(child: CartPageShimmer())
                        : sellerList.isNotEmpty
                            ? Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: RefreshIndicator(
                                        onRefresh: () async {
                                          if (Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .isLoggedIn()) {
                                            await Provider.of<CartProvider>(
                                                    context,
                                                    listen: false)
                                                .getCartDataAPI(context);
                                          }
                                        },
                                        child: ListView.builder(
                                          itemCount: sellerList.length,
                                          padding: const EdgeInsets.all(0),
                                          itemBuilder: (context, index) {
                                            bool hasPhysical = false;
                                            double totalCost = 0;
                                            for (CartModel cart
                                                in cartProductList[index]) {
                                              totalCost += (cart.price! -
                                                          cart.discount!) *
                                                      cart.quantity! +
                                                  tax +
                                                  shippingAmount;
                                            }

                                            for (CartModel cart
                                                in cartProductList[index]) {
                                              if (cart.productType ==
                                                  'physical') {
                                                hasPhysical = true;
                                                totalPhysical += 1;
                                                break;
                                              }
                                            }

                                            return Container(
                                              color: (sellerGroupList[index]
                                                          .minimumOrderAmountInfo! >
                                                      totalCost)
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .error
                                                      .withOpacity(.05)
                                                  : index.floor().isOdd
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .onSecondaryContainer
                                                      : Theme.of(context)
                                                          .canvasColor,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: Dimensions
                                                        .paddingSizeSmall),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      sellerGroupList[index]
                                                              .shopInfo!
                                                              .isNotEmpty
                                                          ? Padding(
                                                              padding: const EdgeInsets
                                                                      .only(
                                                                  top: Dimensions
                                                                      .paddingSizeSmall),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                      child: Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                                                          child: Row(children: [
                                                                            Flexible(
                                                                              child: Text(sellerGroupList[index].shopInfo!, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Theme.of(context).hintColor : Theme.of(context).primaryColor)),
                                                                            ),
                                                                            Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                                                                child: Text('(${cartProductList[index].length})', style: textBold.copyWith(color: Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Theme.of(context).hintColor : Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge))),
                                                                          ]))),
                                                                  SizedBox(
                                                                    width: 200,
                                                                    child: configProvider.configModel!.shippingMethod ==
                                                                                'sellerwise_shipping' &&
                                                                            sellerGroupList[index].shippingType ==
                                                                                'order_wise' &&
                                                                            hasPhysical
                                                                        ? Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                showModalBottomSheet(
                                                                                  context: context,
                                                                                  isScrollControlled: true,
                                                                                  backgroundColor: Colors.transparent,
                                                                                  builder: (context) => ShippingMethodBottomSheet(groupId: sellerGroupList[index].cartGroupId, sellerIndex: index, sellerId: sellerGroupList[index].id),
                                                                                );
                                                                              },
                                                                              child: Container(
                                                                                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.grey), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                                    if (cart.shippingList == null || cart.shippingList![index].shippingMethodList == null || cart.chosenShippingList.isEmpty || cart.shippingList![index].shippingIndex == -1)
                                                                                      Row(
                                                                                        children: [
                                                                                          SizedBox(width: 15, height: 15, child: Image.asset(Images.delivery, color: Theme.of(context).textTheme.bodyLarge?.color)),
                                                                                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                                                          Text(
                                                                                            getTranslated('choose_shipping', context)!,
                                                                                            style: textRegular,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            maxLines: 1,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    Flexible(child: Text((cart.shippingList == null || cart.shippingList![index].shippingMethodList == null || cart.chosenShippingList.isEmpty || cart.shippingList![index].shippingIndex == -1) ? '' : cart.shippingList![index].shippingMethodList![cart.shippingList![index].shippingIndex!].title.toString(), style: titilliumSemiBold.copyWith(color: Theme.of(context).hintColor), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end)),
                                                                                    Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                                                                                  ]),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : const SizedBox(),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                      if (sellerGroupList[index]
                                                              .minimumOrderAmountInfo! >
                                                          totalCost)
                                                        Padding(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: Dimensions
                                                                  .paddingSizeSmall,
                                                              vertical: Dimensions
                                                                  .paddingSizeSmall),
                                                          child: Text(
                                                            '${getTranslated('minimum_order_amount_is', context)} ${PriceConverter.convertPrice(context, sellerGroupList[index].minimumOrderAmountInfo)}',
                                                            style: textRegular.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .error),
                                                          ),
                                                        ),
                                                      if (configProvider
                                                                  .configModel!
                                                                  .shippingMethod ==
                                                              'sellerwise_shipping' &&
                                                          sellerGroupList[index]
                                                                  .shippingType ==
                                                              'order_wise' &&
                                                          hasPhysical)
                                                        Padding(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: Dimensions
                                                                  .paddingSizeSmall),
                                                          child: (cart
                                                                          .shippingList ==
                                                                      null ||
                                                                  cart
                                                                          .shippingList![
                                                                              index]
                                                                          .shippingMethodList ==
                                                                      null ||
                                                                  cart.chosenShippingList
                                                                      .isEmpty ||
                                                                  cart.shippingList![index]
                                                                          .shippingIndex ==
                                                                      -1)
                                                              ? const SizedBox()
                                                              : Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          (cart.shippingList == null || cart.shippingList![index].shippingMethodList == null || cart.chosenShippingList.isEmpty || cart.shippingList![index].shippingIndex == -1)
                                                                              ? ''
                                                                              : '${getTranslated('shipping_cost', context) ?? ''} : ',
                                                                          style:
                                                                              textRegular,
                                                                        ),
                                                                        Text(
                                                                            (cart.shippingList == null || cart.shippingList![index].shippingMethodList == null || cart.chosenShippingList.isEmpty || cart.shippingList![index].shippingIndex == -1)
                                                                                ? ''
                                                                                : PriceConverter.convertPrice(context, cart.shippingList![index].shippingMethodList![cart.shippingList![index].shippingIndex!].cost),
                                                                            style: textBold.copyWith(),
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            textAlign: TextAlign.end),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: Dimensions
                                                                          .paddingSizeExtraSmall,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          (cart.shippingList == null || cart.shippingList![index].shippingMethodList == null || cart.chosenShippingList.isEmpty || cart.shippingList![index].shippingIndex == -1)
                                                                              ? ''
                                                                              : '${getTranslated('shipping_time', context) ?? ''} : ',
                                                                          style:
                                                                              textRegular,
                                                                        ),
                                                                        Text(
                                                                            (cart.shippingList == null || cart.shippingList![index].shippingMethodList == null || cart.chosenShippingList.isEmpty || cart.shippingList![index].shippingIndex == -1)
                                                                                ? ''
                                                                                : '${cart.shippingList![index].shippingMethodList![cart.shippingList![index].shippingIndex!].duration.toString()} ${getTranslated('days', context)}',
                                                                            style: textBold
                                                                                .copyWith(),
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            textAlign: TextAlign.end)
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                        ),
                                                      Card(
                                                        child: Container(
                                                          padding: const EdgeInsets
                                                                  .only(
                                                              bottom: Dimensions
                                                                  .paddingSizeLarge),
                                                          decoration: BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .highlightColor),
                                                          child: Column(
                                                            children: [
                                                              ListView.builder(
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                itemCount:
                                                                    cartProductList[
                                                                            index]
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        i) {
                                                                  return CartWidget(
                                                                    cartModel:
                                                                        cartProductList[index]
                                                                            [i],
                                                                    index: cartProductIndexList[
                                                                        index][i],
                                                                    fromCheckout:
                                                                        widget
                                                                            .fromCheckout,
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      if (sellerGroupList[index]
                                                                  .freeDeliveryOrderAmount
                                                                  ?.status ==
                                                              1 &&
                                                          hasPhysical)
                                                        Padding(
                                                          padding: const EdgeInsets
                                                                  .only(
                                                              bottom: Dimensions
                                                                  .paddingSizeSmall,
                                                              left: Dimensions
                                                                  .paddingSizeDefault,
                                                              right: Dimensions
                                                                  .paddingSizeDefault,
                                                              top: Dimensions
                                                                  .paddingSizeSmall),
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                  height: 16,
                                                                  child: Image
                                                                      .asset(
                                                                    Images
                                                                        .freeShipping,
                                                                    color: Provider.of<ThemeProvider>(context,
                                                                                listen:
                                                                                    false)
                                                                            .darkTheme
                                                                        ? Theme.of(context)
                                                                            .hintColor
                                                                        : Theme.of(context)
                                                                            .primaryColor,
                                                                  )),
                                                              if (sellerGroupList[
                                                                          index]
                                                                      .freeDeliveryOrderAmount!
                                                                      .amountNeed! >
                                                                  0)
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          Dimensions
                                                                              .paddingSizeExtraSmall),
                                                                  child: Text(
                                                                      PriceConverter.convertPrice(
                                                                          context,
                                                                          sellerGroupList[index]
                                                                              .freeDeliveryOrderAmount!
                                                                              .amountNeed!),
                                                                      style: textMedium.copyWith(
                                                                          color:
                                                                              Theme.of(context).primaryColor)),
                                                                ),
                                                              sellerGroupList[index]
                                                                          .freeDeliveryOrderAmount!
                                                                          .percentage! <
                                                                      100
                                                                  ? Text(
                                                                      '${getTranslated('add_more_for_free_delivery', context)}',
                                                                      style: textMedium.copyWith(
                                                                          color:
                                                                              Theme.of(context).hintColor))
                                                                  : Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              Dimensions.paddingSizeExtraSmall),
                                                                      child: Text(
                                                                          '${getTranslated('you_got_free_delivery', context)}',
                                                                          style:
                                                                              textMedium.copyWith(color: Colors.green)),
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                      if (sellerGroupList[index]
                                                                  .freeDeliveryOrderAmount
                                                                  ?.status ==
                                                              1 &&
                                                          hasPhysical)
                                                        Padding(
                                                          padding: const EdgeInsets
                                                                  .fromLTRB(
                                                              Dimensions
                                                                  .paddingSizeDefault,
                                                              0,
                                                              Dimensions
                                                                  .paddingSizeDefault,
                                                              Dimensions
                                                                  .paddingSizeDefault),
                                                          child:
                                                              LinearPercentIndicator(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            barRadius: const Radius
                                                                    .circular(
                                                                Dimensions
                                                                    .paddingSizeDefault),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                40,
                                                            lineHeight: 4.0,
                                                            percent: sellerGroupList[
                                                                        index]
                                                                    .freeDeliveryOrderAmount!
                                                                    .percentage! /
                                                                100,
                                                            backgroundColor: Provider.of<
                                                                            ThemeProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .darkTheme
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        .5)
                                                                : Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        .2),
                                                            progressColor: (sellerGroupList[index]
                                                                            .freeDeliveryOrderAmount!
                                                                            .percentage! <
                                                                        100 &&
                                                                    !Provider.of<ThemeProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .darkTheme)
                                                                ? Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSecondary
                                                                : Colors.green,
                                                          ),
                                                        ),
                                                    ]),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    (!onlyDigital &&
                                            configProvider.configModel!
                                                    .shippingMethod !=
                                                'sellerwise_shipping' &&
                                            configProvider.configModel!
                                                    .inhouseSelectedShippingType ==
                                                'order_wise')
                                        ? InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) =>
                                                    const ShippingMethodBottomSheet(
                                                        groupId:
                                                            'all_cart_group',
                                                        sellerIndex: 0,
                                                        sellerId: 1),
                                              );
                                            },
                                            child: Padding(
                                                padding: const EdgeInsets
                                                        .fromLTRB(
                                                    Dimensions
                                                        .paddingSizeDefault,
                                                    0,
                                                    Dimensions
                                                        .paddingSizeDefault,
                                                    Dimensions
                                                        .paddingSizeDefault),
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.6,
                                                              // 50% of screen height
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(16),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  bottom: Dimensions
                                                                      .paddingSizeDefault,
                                                                ),
                                                                child:
                                                                    ShippingDetailsWidget(
                                                                  hasPhysical:
                                                                      widget
                                                                          .hasPhysical,
                                                                  billingAddress:
                                                                      _billingAddress,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                        width: 400,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        // Optional: add padding inside the container
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              width: 0.5,
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        child: const Text(
                                                          'Choose a Shipping Address',
                                                          style: textRegular,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 0.5,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 15,
                                                                      height:
                                                                          15,
                                                                      child: Image
                                                                          .asset(
                                                                        Images
                                                                            .delivery,
                                                                        color: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyLarge
                                                                            ?.color,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width: Dimensions
                                                                            .paddingSizeExtraSmall),
                                                                    Text(
                                                                      getTranslated(
                                                                          'choose_shipping',
                                                                          context)!,
                                                                      style:
                                                                          textRegular,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          1,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      (cart.shippingList == null ||
                                                                              cart
                                                                                  .chosenShippingList.isEmpty ||
                                                                              cart
                                                                                  .shippingList!.isEmpty ||
                                                                              cart.shippingList![0].shippingMethodList ==
                                                                                  null ||
                                                                              cart.shippingList![0].shippingIndex ==
                                                                                  -1)
                                                                          ? ''
                                                                          : cart
                                                                              .shippingList![0]
                                                                              .shippingMethodList![cart.shippingList![0].shippingIndex!]
                                                                              .title
                                                                              .toString(),
                                                                      style: titilliumSemiBold
                                                                          .copyWith(
                                                                        color: Theme.of(context)
                                                                            .hintColor,
                                                                      ),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                    const SizedBox(
                                                                        width: Dimensions
                                                                            .paddingSizeExtraSmall),
                                                                    Icon(
                                                                      Icons
                                                                          .keyboard_arrow_down,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              )
                            : const Expanded(
                                child: NoInternetOrDataScreen(
                                icon: Images.emptyCart,
                                icCart: true,
                                isNoInternet: false,
                                message: 'no_product_in_cart',
                              )),
                  ]),
                );
              });
            });
          });
        });
      });
    });
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    if (isSuccess) {
      Navigator.of(Get.context!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const DashBoardScreen()),
          (route) => false);
      showAnimatedDialog(
          context,
          OrderPlaceSuccessDialog(
            icon: Icons.check,
            title: getTranslated('order_placed', context),
            description: getTranslated('your_order_placed', context),
            isFailed: false,
          ),
          dismissible: false,
          isFlip: true);
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
    } else {
      showCustomSnackBar(message, context, isToaster: true);
    }
  }
}
