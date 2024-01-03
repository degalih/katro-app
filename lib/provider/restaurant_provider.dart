import 'package:flutter/foundation.dart';
import 'package:katro_v2/data/api/api_service.dart';
import 'package:katro_v2/data/model/restaurant.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  late LocalRestaurant _localRestaurant;

  late ResultState _state;
  String _message = '';

  String get message => _message;

  LocalRestaurant get result => _localRestaurant;

  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final data = await apiService.getAllRestaurant();
      if (data.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _localRestaurant = data;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> Tidak ada koneksi internet';
    }
  }
}
