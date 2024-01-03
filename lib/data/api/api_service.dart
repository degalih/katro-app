import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:katro_v2/data/model/restaurant.dart';
import 'package:katro_v2/data/model/restaurant_detail.dart';
import 'package:katro_v2/data/model/restaurant_search.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _list = 'list';
  static const String _detail = 'detail';
  static const String _search = 'search?q=';
  static const String _review = 'review';

  Future<LocalRestaurant> getAllRestaurant() async {
    final response = await http.get(Uri.parse(_baseUrl + _list));
    if (response.statusCode == 200) {
      return LocalRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load List of Restaurant');
    }
  }

  Future<DetailRestaurant> getRestaurantById(String restaurantId) async {
    final response =
        await http.get(Uri.parse(_baseUrl + _detail + '/' + restaurantId));

    if (response.statusCode == 200) {
      return DetailRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Detail of Restaurant');
    }
  }

  Future<SearchRestaurant> getRestaurantByQuery(String query) async {
    final response = await http.get(Uri.parse(_baseUrl + _search + query));

    if (response.statusCode == 200) {
      return SearchRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Search Result');
    }
  }

  Future<CustomerReview> postCustomerReview(
      String restaurantId, String name, String review) async {
    final response = await http.post(
      Uri.parse(_baseUrl + _review),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'id': restaurantId, 'name': name, 'review': review}),
    );

    if (response.statusCode == 201) {
      return CustomerReview.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add Customer Review');
    }
  }
}
