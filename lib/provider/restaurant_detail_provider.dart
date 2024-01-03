import 'package:flutter/foundation.dart';
import 'package:katro_v2/data/model/restaurant_detail.dart';

import '../data/api/api_service.dart';

enum ResultState { Loading, NoData, HasData, Error }

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  final String restaurantId;

  DetailRestaurantProvider(
      {required this.apiService, required this.restaurantId}) {
    _fetchRestaurantById(restaurantId);
  }

  late DetailRestaurant _detailRestaurant;

  late ResultState _state;
  String _message = '';

  String get message => _message;

  DetailRestaurant get result => _detailRestaurant;

  ResultState get state => _state;

  Future<dynamic> _fetchRestaurantById(String restaurantId) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final data = await apiService.getRestaurantById(restaurantId);
      if (data.restaurant.id.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _detailRestaurant = data;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> Tidak ada koneksi internet';
    }
  }
}
