import 'dart:convert';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/GetQuotesModel.dart';
import 'package:http/http.dart' as http;

class GetQuotesRepo {

  Future<bool> submitQuote(Data quote) async {
    final url = Uri.parse(AppConstants.baseUrl+AppConstants.addQuotes);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(quote),
      );

      print(response.statusCode);

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);
        print(" data is where$data");
        return true;
      } else {
        throw Exception('Failed to submit quote.');
      }
    } catch (error) {
      throw Exception('Error submitting quote: $error');
    }
  }
}
