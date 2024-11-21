class GetQuotesModel {
  bool? success;
  Data? data;

  GetQuotesModel({this.success, this.data});
  GetQuotesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }

    return data;
  }
}

class Data {
  String? name;
  String? number;
  String? email;
  String? message;
  String? productId;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.name,
        this.number,
        this.email,
        this.message,
        this.productId,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    number = json['number'];
    email = json['email'];
    message = json['message'];
    productId = json['product_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['number'] = number;
    data['email'] = email;
    data['message'] = message;
    data['product_id'] = productId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}