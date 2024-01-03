import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:katro_v2/common/styles.dart';
import 'package:katro_v2/provider/restaurant_provider.dart';
import 'package:katro_v2/ui/restaurant_detail_page.dart';
import 'package:provider/provider.dart';

class RestaurantBody extends StatefulWidget {
  const RestaurantBody({Key? key}) : super(key: key);

  @override
  State<RestaurantBody> createState() => _RestaurantBodyState();
}

class _RestaurantBodyState extends State<RestaurantBody> {
  late ScrollController scrollController;
  static const String _pictureUrl =
      'https://restaurant-api.dicoding.dev/images/medium/';

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        Widget restaurantList;
        if (state.state == ResultState.Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          restaurantList = LiveSliverList(
            controller: scrollController,
            showItemDuration: const Duration(milliseconds: 250),
            itemCount: state.result.restaurants.length,
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
              var restaurant = state.result.restaurants[index];
              return FadeTransition(
                opacity: Tween<double>(
                  begin: 0,
                  end: 1,
                ).animate(animation),
                // And slide transition
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  // Paste you Widget
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RestaurantDetailPage.routeName,
                            arguments: restaurant.id);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            margin: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Hero(
                                  tag: restaurant.pictureId,
                                  child: Image.network(
                                      _pictureUrl + restaurant.pictureId,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(restaurant.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.location_city,
                                                color: primaryColor),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4),
                                              child: Text(restaurant.city),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rate,
                                              color: secondaryColor),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: Text(
                                                restaurant.rating.toString()),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text(''));
        }
        return CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            const _Banner(),
            const _SectionTitle(),
            restaurantList,
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Mau makan dimana hari ini?',
                style: Theme.of(context).textTheme.headline6),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 132,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: 132,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [primaryColor, shadeColor],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        'Food is not rational. Food is culture, habit, craving and identity',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Flexible(
                        flex: 2,
                        child: Image.asset(
                            'assets/images/banner-illustration.png')),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
