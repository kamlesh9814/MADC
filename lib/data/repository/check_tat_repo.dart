import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/response/base/api_response.dart';

class CheckTatRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  CheckTatRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getCheckTat(var payload) async {
    print('payload in repo is ${payload}');
    try {
      Response response = await dioClient!.post(
        AppConstants.checkTatURl,
        data: jsonEncode(payload),
      );
      print('nirajan');
      print(response);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }}