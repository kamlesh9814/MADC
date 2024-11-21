import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/GetQuotesModel.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/GetQuotesRepo.dart';


class GetQuotesProvider extends ChangeNotifier {
  final GetQuotesRepo getQuotesRepo;

  GetQuotesModel? _getQuotesModel;
  String? _errorMessage;
  bool _isLoading = false;

  GetQuotesProvider({required this.getQuotesRepo});

  GetQuotesModel? get getQuotesModel => _getQuotesModel;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  // Function to submit a quote
  Future<bool> submitQuote(var quoteData) async {
    try {
      // Get the response model
      final  response = await getQuotesRepo!.submitQuote(
          quoteData );

      // Check if the response indicates success
      if (response == true) {
        notifyListeners();
        return true; // Submission succeeded
      } else {
        return false; // Submission failed
      }
    } catch (e) {
      print("Error submitting quote: $e");
      return false; // Return false on error
    }
  }
}
