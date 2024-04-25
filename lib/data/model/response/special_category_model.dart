// To parse this JSON data, do
//
//     final specialCategoryProduct = specialCategoryProductFromJson(jsonString);

import 'dart:convert';

SpecialCategoryProduct specialCategoryProductFromJson(String str) =>
    SpecialCategoryProduct.fromJson(json.decode(str));

String specialCategoryProductToJson(SpecialCategoryProduct data) =>
    json.encode(data.toJson());

class SpecialCategoryProduct {
  List<SellerProduct> sellerProducts;

  SpecialCategoryProduct({
    required this.sellerProducts,
  });

  factory SpecialCategoryProduct.fromJson(Map<String, dynamic> json) =>
      SpecialCategoryProduct(
        sellerProducts: List<SellerProduct>.from(
            json["seller_products"].map((x) => SellerProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "seller_products":
            List<dynamic>.from(sellerProducts.map((x) => x.toJson())),
      };
}

class SellerProduct {
  int id;
  AddedBy addedBy;
  int userId;
  String name;
  String slug;
  ProductTypeEnum productType;
  String categoryIds;
  String categoryId;
  String? subCategoryId;
  dynamic subSubCategoryId;
  int brandId;
  Unit unit;
  dynamic hsn;
  int minQty;
  int refundable;
  dynamic digitalProductType;
  dynamic digitalFileReady;
  String images;
  Color colorImage;
  String thumbnail;
  dynamic featured;
  dynamic flashDeal;
  VideoProvider videoProvider;
  dynamic videoUrl;
  Color colors;
  int variantProduct;
  Attributes attributes;
  String choiceOptions;
  String variation;
  int published;
  int unitPrice;
  int purchasePrice;
  int tax;
  TaxType taxType;
  TaxModel taxModel;
  int discount;
  DiscountType discountType;
  int currentStock;
  int minimumOrderQty;
  String details;
  int freeShipping;
  dynamic attachment;
  DateTime createdAt;
  DateTime updatedAt;
  int status;
  int featuredStatus;
  String metaTitle;
  String? metaDescription;
  Image metaImage;
  int requestStatus;
  dynamic deniedNote;
  int shippingCost;
  String? weightWithPkg;
  int multiplyQty;
  dynamic tempShippingCost;
  dynamic isShippingCostUpdated;
  String code;
  int wirehouseLocationId;
  int reviewsCount;
  Seller seller;
  List<dynamic> translations;
  List<dynamic> reviews;

  SellerProduct({
    required this.id,
    required this.addedBy,
    required this.userId,
    required this.name,
    required this.slug,
    required this.productType,
    required this.categoryIds,
    required this.categoryId,
    required this.subCategoryId,
    required this.subSubCategoryId,
    required this.brandId,
    required this.unit,
    required this.hsn,
    required this.minQty,
    required this.refundable,
    required this.digitalProductType,
    required this.digitalFileReady,
    required this.images,
    required this.colorImage,
    required this.thumbnail,
    required this.featured,
    required this.flashDeal,
    required this.videoProvider,
    required this.videoUrl,
    required this.colors,
    required this.variantProduct,
    required this.attributes,
    required this.choiceOptions,
    required this.variation,
    required this.published,
    required this.unitPrice,
    required this.purchasePrice,
    required this.tax,
    required this.taxType,
    required this.taxModel,
    required this.discount,
    required this.discountType,
    required this.currentStock,
    required this.minimumOrderQty,
    required this.details,
    required this.freeShipping,
    required this.attachment,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.featuredStatus,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaImage,
    required this.requestStatus,
    required this.deniedNote,
    required this.shippingCost,
    required this.weightWithPkg,
    required this.multiplyQty,
    required this.tempShippingCost,
    required this.isShippingCostUpdated,
    required this.code,
    required this.wirehouseLocationId,
    required this.reviewsCount,
    required this.seller,
    required this.translations,
    required this.reviews,
  });

  factory SellerProduct.fromJson(Map<String, dynamic> json) => SellerProduct(
        id: json["id"],
        addedBy: addedByValues.map[json["added_by"]]!,
        userId: json["user_id"],
        name: json["name"],
        slug: json["slug"],
        productType: productTypeValues.map[json["product_type"]]!,
        categoryIds: json["category_ids"],
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        subSubCategoryId: json["sub_sub_category_id"],
        brandId: json["brand_id"],
        unit: unitValues.map[json["unit"]]!,
        hsn: json["hsn"],
        minQty: json["min_qty"],
        refundable: json["refundable"],
        digitalProductType: json["digital_product_type"],
        digitalFileReady: json["digital_file_ready"],
        images: json["images"],
        colorImage: colorValues.map[json["color_image"]]!,
        thumbnail: json["thumbnail"],
        featured: json["featured"],
        flashDeal: json["flash_deal"],
        videoProvider: videoProviderValues.map[json["video_provider"]]!,
        videoUrl: json["video_url"],
        colors: colorValues.map[json["colors"]]!,
        variantProduct: json["variant_product"],
        attributes: attributesValues.map[json["attributes"]]!,
        choiceOptions: json["choice_options"],
        variation: json["variation"],
        published: json["published"],
        unitPrice: json["unit_price"],
        purchasePrice: json["purchase_price"],
        tax: json["tax"],
        taxType: taxTypeValues.map[json["tax_type"]]!,
        taxModel: taxModelValues.map[json["tax_model"]]!,
        discount: json["discount"],
        discountType: discountTypeValues.map[json["discount_type"]]!,
        currentStock: json["current_stock"],
        minimumOrderQty: json["minimum_order_qty"],
        details: json["details"],
        freeShipping: json["free_shipping"],
        attachment: json["attachment"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        status: json["status"],
        featuredStatus: json["featured_status"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        metaImage: imageValues.map[json["meta_image"]]!,
        requestStatus: json["request_status"],
        deniedNote: json["denied_note"],
        shippingCost: json["shipping_cost"],
        weightWithPkg: json["weight_with_pkg"],
        multiplyQty: json["multiply_qty"],
        tempShippingCost: json["temp_shipping_cost"],
        isShippingCostUpdated: json["is_shipping_cost_updated"],
        code: json["code"],
        wirehouseLocationId: json["wirehouse_location_id"],
        reviewsCount: json["reviews_count"],
        seller: Seller.fromJson(json["seller"]),
        translations: List<dynamic>.from(json["translations"].map((x) => x)),
        reviews: List<dynamic>.from(json["reviews"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "added_by": addedByValues.reverse[addedBy],
        "user_id": userId,
        "name": name,
        "slug": slug,
        "product_type": productTypeValues.reverse[productType],
        "category_ids": categoryIds,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "sub_sub_category_id": subSubCategoryId,
        "brand_id": brandId,
        "unit": unitValues.reverse[unit],
        "hsn": hsn,
        "min_qty": minQty,
        "refundable": refundable,
        "digital_product_type": digitalProductType,
        "digital_file_ready": digitalFileReady,
        "images": images,
        "color_image": colorValues.reverse[colorImage],
        "thumbnail": thumbnail,
        "featured": featured,
        "flash_deal": flashDeal,
        "video_provider": videoProviderValues.reverse[videoProvider],
        "video_url": videoUrl,
        "colors": colorValues.reverse[colors],
        "variant_product": variantProduct,
        "attributes": attributesValues.reverse[attributes],
        "choice_options": choiceOptions,
        "variation": variation,
        "published": published,
        "unit_price": unitPrice,
        "purchase_price": purchasePrice,
        "tax": tax,
        "tax_type": taxTypeValues.reverse[taxType],
        "tax_model": taxModelValues.reverse[taxModel],
        "discount": discount,
        "discount_type": discountTypeValues.reverse[discountType],
        "current_stock": currentStock,
        "minimum_order_qty": minimumOrderQty,
        "details": details,
        "free_shipping": freeShipping,
        "attachment": attachment,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "status": status,
        "featured_status": featuredStatus,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "meta_image": imageValues.reverse[metaImage],
        "request_status": requestStatus,
        "denied_note": deniedNote,
        "shipping_cost": shippingCost,
        "weight_with_pkg": weightWithPkg,
        "multiply_qty": multiplyQty,
        "temp_shipping_cost": tempShippingCost,
        "is_shipping_cost_updated": isShippingCostUpdated,
        "code": code,
        "wirehouse_location_id": wirehouseLocationId,
        "reviews_count": reviewsCount,
        "seller": seller.toJson(),
        "translations": List<dynamic>.from(translations.map((x) => x)),
        "reviews": List<dynamic>.from(reviews.map((x) => x)),
      };
}

enum AddedBy { SELLER }

final addedByValues = EnumValues({"seller": AddedBy.SELLER});

enum Attributes { NULL, THE_2, THE_5 }

final attributesValues = EnumValues({
  "null": Attributes.NULL,
  "[\"2\"]": Attributes.THE_2,
  "[\"5\"]": Attributes.THE_5
});

enum Color { EMPTY }

final colorValues = EnumValues({"[]": Color.EMPTY});

enum DiscountType { FLAT }

final discountTypeValues = EnumValues({"flat": DiscountType.FLAT});

enum Image { DEF_PNG, THE_2024032065_FA885_C15_B12_PNG }

final imageValues = EnumValues({
  "def.png": Image.DEF_PNG,
  "2024-03-20-65fa885c15b12.png": Image.THE_2024032065_FA885_C15_B12_PNG
});

enum ProductTypeEnum { PHYSICAL }

final productTypeValues = EnumValues({"physical": ProductTypeEnum.PHYSICAL});

class Seller {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  Image? image;
  String? sellertypeId;
  int? sellerpackageId;
  String? transaction;
  String? email;
  String? password;
  Status? status;
  String? packageStatus;
  String? rememberToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? bankName;
  String? branch;
  String? accountNo;
  String? holderName;
  String? ifsc;
  dynamic? authToken;
  int? salesCommissionPercentage;
  String? gst;
  dynamic? cmFirebaseToken;
  int? posStatus;
  int? minimumOrderAmount;
  int? freeDeliveryStatus;
  int? freeDeliveryOverAmount;
  dynamic extraContactNo;
  dynamic godamAddress;

  Seller({
    required this.id,
    required this.fName,
    required this.lName,
    required this.phone,
    required this.image,
    required this.sellertypeId,
    required this.sellerpackageId,
    required this.transaction,
    required this.email,
    required this.password,
    required this.status,
    required this.packageStatus,
    required this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
    required this.bankName,
    required this.branch,
    required this.accountNo,
    required this.holderName,
    required this.ifsc,
    required this.authToken,
    required this.salesCommissionPercentage,
    required this.gst,
    required this.cmFirebaseToken,
    required this.posStatus,
    required this.minimumOrderAmount,
    required this.freeDeliveryStatus,
    required this.freeDeliveryOverAmount,
    required this.extraContactNo,
    required this.godamAddress,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["id"],
        fName: json["f_name"]!,
        lName: json["l_name"]!,
        phone: json["phone"],
        image: imageValues.map[json["image"]]!,
        sellertypeId: json["sellertype_id"]!,
        sellerpackageId: json["sellerpackage_id"],
        transaction: json["transaction"],
        email: json["email"]!,
        password: json["password"]!,
        status: statusValues.map[json["status"]]!,
        packageStatus: json["package_status"]!,
        rememberToken: json["remember_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        bankName: json["bank_name"]!,
        branch: json["branch"]!,
        accountNo: json["account_no"],
        holderName: json["holder_name"]!,
        ifsc: json["ifsc"]!,
        authToken: json["auth_token"],
        salesCommissionPercentage: json["sales_commission_percentage"],
        gst: json["gst"],
        cmFirebaseToken: json["cm_firebase_token"],
        posStatus: json["pos_status"],
        minimumOrderAmount: json["minimum_order_amount"],
        freeDeliveryStatus: json["free_delivery_status"],
        freeDeliveryOverAmount: json["free_delivery_over_amount"],
        extraContactNo: json["extra_contact_no"],
        godamAddress: json["godamAddress"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "f_name": fNameValues.reverse[fName],
        "l_name": lNameValues.reverse[lName],
        "phone": phone,
        "image": imageValues.reverse[image],
        "sellertype_id": titleValues.reverse[sellertypeId],
        "sellerpackage_id": sellerpackageId,
        "transaction": transaction,
        "email": emailValues.reverse[email],
        "password": passwordValues.reverse[password],
        "status": statusValues.reverse[status],
        "package_status": packageStatusValues.reverse[packageStatus],
        "remember_token": rememberToken,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "bank_name": bankNameValues.reverse[bankName],
        "branch": branchValues.reverse[branch],
        "account_no": accountNo,
        "holder_name": holderNameValues.reverse[holderName],
        "ifsc": ifscValues.reverse[ifsc],
        "auth_token": authToken,
        "sales_commission_percentage": salesCommissionPercentage,
        "gst": gst,
        "cm_firebase_token": cmFirebaseToken,
        "pos_status": posStatus,
        "minimum_order_amount": minimumOrderAmount,
        "free_delivery_status": freeDeliveryStatus,
        "free_delivery_over_amount": freeDeliveryOverAmount,
        "extra_contact_no": extraContactNo,
        "godamAddress": godamAddress,
      };
}

enum BankName {
  BANK_OF_MAHARASHTRA,
  IDBI_BANK,
  INDIAN_BANK,
  STATE_BANK_OF_INDIA
}

final bankNameValues = EnumValues({
  "BANK OF MAHARASHTRA": BankName.BANK_OF_MAHARASHTRA,
  "IDBI Bank": BankName.IDBI_BANK,
  "Indian Bank": BankName.INDIAN_BANK,
  "State Bank Of India": BankName.STATE_BANK_OF_INDIA
});

enum Branch { DABHADI_845, DARWHA, GONDIA_BRANCH, MALEGAON_BRANCH }

final branchValues = EnumValues({
  "Dabhadi (845)": Branch.DABHADI_845,
  "DARWHA": Branch.DARWHA,
  "Gondia Branch": Branch.GONDIA_BRANCH,
  "Malegaon Branch": Branch.MALEGAON_BRANCH
});

enum Email {
  DURGAGURHUDHYOGGONDIA_GMAIL_COM,
  HARSHADAPAWAR2014_GMAIL_COM,
  KAVITAYEVLE80_GMAIL_COM,
  SHITALWAGH0610_GMAIL_COM
}

final emailValues = EnumValues({
  "durgagurhudhyoggondia@gmail.com": Email.DURGAGURHUDHYOGGONDIA_GMAIL_COM,
  "harshadapawar2014@gmail.com": Email.HARSHADAPAWAR2014_GMAIL_COM,
  "kavitayevle80@gmail.com": Email.KAVITAYEVLE80_GMAIL_COM,
  "shitalwagh0610@gmail.com": Email.SHITALWAGH0610_GMAIL_COM
});

enum FName { DURGA_DEEPAK, HARSHADA_MADHUKAR, KAVITA, SHITAL }

final fNameValues = EnumValues({
  "Durga Deepak": FName.DURGA_DEEPAK,
  "Harshada Madhukar": FName.HARSHADA_MADHUKAR,
  "KAVITA": FName.KAVITA,
  "Shital": FName.SHITAL
});

enum HolderName {
  KAVITA_PARMESHWAR_YEVALE,
  MISS_HARSHADA_MADHUKAR_PAWAR,
  SHITAL_ANIL_WAGH,
  SHREE_DURGA_GURH_UDHYOG
}

final holderNameValues = EnumValues({
  "Kavita Parmeshwar Yevale": HolderName.KAVITA_PARMESHWAR_YEVALE,
  "Miss. Harshada Madhukar Pawar": HolderName.MISS_HARSHADA_MADHUKAR_PAWAR,
  "Shital Anil Wagh": HolderName.SHITAL_ANIL_WAGH,
  "Shree Durga Gurh Udhyog": HolderName.SHREE_DURGA_GURH_UDHYOG
});

enum Ifsc { IBKL0000533, IDIB000_G108, MAHB0000845, SBIN0000356 }

final ifscValues = EnumValues({
  "IBKL0000533": Ifsc.IBKL0000533,
  "IDIB000G108": Ifsc.IDIB000_G108,
  "MAHB0000845": Ifsc.MAHB0000845,
  "SBIN0000356": Ifsc.SBIN0000356
});

enum LName { PAWAR, VERMA, WAGH, YEVALE }

final lNameValues = EnumValues({
  "Pawar": LName.PAWAR,
  "Verma": LName.VERMA,
  "Wagh": LName.WAGH,
  "YEVALE": LName.YEVALE
});

enum PackageStatus { PAID, UNPAID }

final packageStatusValues =
    EnumValues({"Paid": PackageStatus.PAID, "Unpaid": PackageStatus.UNPAID});

enum Password {
  THE_2_Y_1049_A_BG6_PX_E_PPQ_TE_C3_KA_N_YD_O3_QW_OA8_IGM_VAM_NK4_K1_ZBX_WCP_GL_LDQ,
  THE_2_Y_10_F_B_AM_HP_Z_ZLI_Y3_IL_N_ONJY_BU1_WXA_BBS_PB_SEU_SR_H_VI_X_FCJK_RFN_XX_G_RQ,
  THE_2_Y_10_M_EE_CYDK_8_RW_PY_ZW_ZK5_CQV_G_OT2_TF_V_CP_XW_XE77_LZ_ASD_JF_BF4_GWP2_C,
  THE_2_Y_10_Z_XJ_M_ODI_C7_Z_XV0_AV_YZ_J_LYGE_MA_SF_IJ_0_LE_TY_CHT_GS_YN_FI9_L_RDKD_F7_S
}

final passwordValues = EnumValues({
  "\u00242y\u002410\u002449aBg6pxEPpqTeC3kaNYdO3qw.oa8IGMVam.Nk4K1/zbxWCPGlLdq":
      Password
          .THE_2_Y_1049_A_BG6_PX_E_PPQ_TE_C3_KA_N_YD_O3_QW_OA8_IGM_VAM_NK4_K1_ZBX_WCP_GL_LDQ,
  "\u00242y\u002410\u0024fBAmHP.ZZliY3IlNOnjyBu1wxaBbsPbSeuSrHViX.fcjkRfnXxGRq":
      Password
          .THE_2_Y_10_F_B_AM_HP_Z_ZLI_Y3_IL_N_ONJY_BU1_WXA_BBS_PB_SEU_SR_H_VI_X_FCJK_RFN_XX_G_RQ,
  "\u00242y\u002410\u0024mEECydk/8RwPYZwZk5CQV.GOt2TfVCp.xwXe77LzAsdJFBf4Gwp2C":
      Password
          .THE_2_Y_10_M_EE_CYDK_8_RW_PY_ZW_ZK5_CQV_G_OT2_TF_V_CP_XW_XE77_LZ_ASD_JF_BF4_GWP2_C,
  "\u00242y\u002410\u0024zXjMOdiC7ZXv0AVYzJLygeMaSf.ij/0LeTYChtGsYnFi9lRdkdF7S":
      Password
          .THE_2_Y_10_Z_XJ_M_ODI_C7_Z_XV0_AV_YZ_J_LYGE_MA_SF_IJ_0_LE_TY_CHT_GS_YN_FI9_L_RDKD_F7_S
});

enum Title { MAHILA_BACHAT, MAHILA_BACHAT_GAT }

final titleValues = EnumValues({
  "mahila_bachat": Title.MAHILA_BACHAT,
  "Mahila Bachat Gat": Title.MAHILA_BACHAT_GAT
});

enum Status { APPROVED }

final statusValues = EnumValues({"approved": Status.APPROVED});

enum TaxModel { INCLUDE }

final taxModelValues = EnumValues({"include": TaxModel.INCLUDE});

enum TaxType { PERCENT }

final taxTypeValues = EnumValues({"percent": TaxType.PERCENT});

enum Unit { GMS, KG, ML, NOS }

final unitValues = EnumValues(
    {"gms": Unit.GMS, "kg": Unit.KG, "ml": Unit.ML, "nos": Unit.NOS});

enum VideoProvider { YOUTUBE }

final videoProviderValues = EnumValues({"youtube": VideoProvider.YOUTUBE});

class SellerType {
  int id;
  Title title;
  int published;
  DateTime createdAt;
  DateTime updatedAt;

  SellerType({
    required this.id,
    required this.title,
    required this.published,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SellerType.fromJson(Map<String, dynamic> json) => SellerType(
        id: json["id"],
        title: titleValues.map[json["title"]]!,
        published: json["published"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": titleValues.reverse[title],
        "published": published,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
