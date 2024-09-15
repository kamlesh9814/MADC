import 'package:flutter/foundation.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/check_tat_repo.dart';

class CheckTatProvider with ChangeNotifier {
  CheckTatRepo? checkTatRepo;
  bool _isLoading = false;
  String? _successMessage = '';
  String? _errorMessage = '';

  bool get isLoading => _isLoading;
  String? get successMessage => _successMessage;
  String? get errorMessage => _errorMessage;

  CheckTatProvider({required this.checkTatRepo});

  Future<void> postCheckTat(var payload) async {
    _isLoading = true;
    _successMessage = null;
    _errorMessage = null;
    notifyListeners();

    try {
      ApiResponse apiResponse = await checkTatRepo!.getCheckTat(payload);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        print('data is ${apiResponse.response!.data ['data']['tat']}');
        _successMessage = apiResponse.response!.data ['data']['tat']?? 'Success';
      } else {
        _errorMessage = apiResponse.response?.statusMessage ?? 'Error: Something went wrong';
      }
    } catch (exception) {
      _errorMessage = 'Error: ${exception.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
