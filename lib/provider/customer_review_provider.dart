import 'package:flutter/foundation.dart';
import 'package:katro_v2/data/model/restaurant_detail.dart';

import '../data/api/api_service.dart';

enum ReviewResultState { Loading, NoData, HasData, Error }

class CustomerReviewProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;
  final String name;
  final String review;

  CustomerReviewProvider({
    required this.apiService,
    required this.restaurantId,
    required this.name,
    required this.review,
  }) {
    postCustomerReview(restaurantId, name, review);
  }

  late CustomerReview _customerReview;

  late ReviewResultState _state;
  String _message = '';

  String get message => _message;

  CustomerReview get result => _customerReview;

  ReviewResultState get state => _state;

  Future<dynamic> postCustomerReview(
      String restaurantId, String name, String review) async {
    try {
      _state = ReviewResultState.Loading;
      notifyListeners();
      await apiService.postCustomerReview(restaurantId, name, review);
      notifyListeners();
    } catch (e) {
      _state = ReviewResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
