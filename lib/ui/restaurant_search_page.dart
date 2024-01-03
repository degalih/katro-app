import 'package:flutter/material.dart';
import 'package:katro_v2/common/styles.dart';
import 'package:katro_v2/data/api/api_service.dart';
import 'package:katro_v2/provider/restaurant_search_provider.dart';
import 'package:katro_v2/ui/restaurant_detail_page.dart';
import 'package:provider/provider.dart';

class RestaurantSearchPage extends StatelessWidget {
  static const routeName = '/search';
  final TextEditingController _queryController = TextEditingController();

  RestaurantSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantSearchProvider(
          apiService: ApiService(), query: _queryController.text),
      child: Consumer<RestaurantSearchProvider>(builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Search Restaurant'),
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                child: TextField(
                  controller: _queryController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    hintText: 'Nama Restoran / Kategori',
                  ),
                  onChanged: (query) {
                    state.fetchRestaurantByQuery(_queryController.text);
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: _queryController.text.isEmpty
                      ? const Center(
                          child: Text(
                              'Cari Restoran berdasarkan nama atau kategori'),
                        )
                      : _buildSearchResult(context),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

Widget _buildSearchResult(BuildContext context) {
  const String _pictureUrl =
      'https://restaurant-api.dicoding.dev/images/medium/';

  return Consumer<RestaurantSearchProvider>(builder: (context, state, _) {
    if (state.state == ResultState.Loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.state == ResultState.HasData) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: state.result.restaurants.length,
          itemBuilder: (context, index) {
            var searchRestaurantResult = state.result.restaurants[index];
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, RestaurantDetailPage.routeName,
                    arguments: searchRestaurantResult.id);
              },
              child: Card(
                child: ListTile(
                  leading: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Image.network(
                        _pictureUrl + searchRestaurantResult.pictureId,
                        fit: BoxFit.cover),
                  ),
                  title: Text(searchRestaurantResult.name),
                  subtitle: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.location_city,
                                color: primaryColor),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(searchRestaurantResult.city),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rate, color: secondaryColor),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child:
                                Text(searchRestaurantResult.rating.toString()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    } else if (state.state == ResultState.NoData) {
      return Center(child: Text(state.message, textAlign: TextAlign.center));
    } else if (state.state == ResultState.Error) {
      return Center(child: Text(state.message, textAlign: TextAlign.center));
    } else {
      return const Center(child: Text(''));
    }
  });
}
