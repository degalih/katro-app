import 'package:flutter/foundation.dart';
import 'package:katro_v2/data/model/restaurant_search.dart';

import '../data/api/api_service.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;
  final String query;

  RestaurantSearchProvider({required this.apiService, required this.query}) {
    fetchRestaurantByQuery(query);
  }

  late SearchRestaurant _searchRestaurant;

  late ResultState _state;
  String _message = '';

  String get message => _message;

  SearchRestaurant get result => _searchRestaurant;

  ResultState get state => _state;

  Future<dynamic> fetchRestaurantByQuery(String query) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final data = await apiService.getRestaurantByQuery(query);
      if (data.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message =
            'Empty Data: Restoran tidak ditemukan. Masukkan kata kunci lain';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _searchRestaurant = data;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> Tidak ada koneksi internet';
    }
  }
}
