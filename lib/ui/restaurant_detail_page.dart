import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katro_v2/common/styles.dart';
import 'package:katro_v2/data/api/api_service.dart';
import 'package:katro_v2/data/model/restaurant_detail.dart';
import 'package:katro_v2/provider/customer_review_provider.dart';
import 'package:katro_v2/provider/restaurant_detail_provider.dart';
import 'package:katro_v2/widgets/custom_back_button.dart';
import 'package:katro_v2/widgets/dummy_favorite_button.dart';
import 'package:provider/provider.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/detail';
  final String restaurantId;

  const RestaurantDetailPage({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<DetailRestaurantProvider>(
        create: (_) => DetailRestaurantProvider(
            apiService: ApiService(), restaurantId: restaurantId),
        child: Consumer<DetailRestaurantProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.HasData) {
              var detailRestaurant = state.result.restaurant;
              return DetailRestaurantBody(detailRestaurant: detailRestaurant);
            } else if (state.state == ResultState.NoData) {
              return Center(child: Text(state.message));
            } else if (state.state == ResultState.Error) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text(''));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const DummyFavoriteButton(),
      ),
    );
  }
}

class DetailRestaurantBody extends StatefulWidget {
  const DetailRestaurantBody({
    Key? key,
    required this.detailRestaurant,
  }) : super(key: key);

  final Restaurant detailRestaurant;

  @override
  State<DetailRestaurantBody> createState() => _DetailRestaurantBodyState();
}

class _DetailRestaurantBodyState extends State<DetailRestaurantBody> {
  static const String _pictureUrl =
      'https://restaurant-api.dicoding.dev/images/medium/';

  late ExpandedTileController _controllerDescription;
  late ExpandedTileController _controllerFood;
  late ExpandedTileController _controllerDrink;
  late ExpandedTileController _controllerReview;

  @override
  void initState() {
    _controllerDescription = ExpandedTileController(isExpanded: true);
    _controllerFood = ExpandedTileController(isExpanded: false);
    _controllerDrink = ExpandedTileController(isExpanded: false);
    _controllerReview = ExpandedTileController(isExpanded: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: const CustomBackButton(),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Image.asset('assets/images/logo-katro.png'),
            )
          ],
          pinned: true,
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(widget.detailRestaurant.name),
            background: Hero(
              tag: widget.detailRestaurant.pictureId,
              child: (Image.network(
                _pictureUrl + widget.detailRestaurant.pictureId,
                fit: BoxFit.cover,
              )),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: const EdgeInsets.only(top: 16),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.location_pin, color: primaryColor),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(widget.detailRestaurant.address,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.location_city, color: primaryColor),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(widget.detailRestaurant.city,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rate, color: secondaryColor),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                                widget.detailRestaurant.rating.toString(),
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: Row(
                          children: widget.detailRestaurant.categories
                              .map((category) {
                        return Container(
                          margin: const EdgeInsets.only(right: 4),
                          child: Badge(
                            shape: BadgeShape.square,
                            badgeColor: secondaryColor,
                            borderRadius: BorderRadius.circular(8),
                            badgeContent: Text(category.name,
                                style: const TextStyle(color: Colors.white)),
                          ),
                        );
                      }).toList()),
                    ),
                  ),
                  DescriptionExpandedTile(
                      detailRestaurant: widget.detailRestaurant,
                      controller: _controllerDescription),
                  FoodExpandedTile(
                      detailRestaurant: widget.detailRestaurant,
                      controllerFood: _controllerFood),
                  DrinkExpandedTile(
                      detailRestaurant: widget.detailRestaurant,
                      controllerDrink: _controllerDrink),
                  ReviewExpandedTile(
                      detailRestaurant: widget.detailRestaurant,
                      controllerReview: _controllerReview),
                  const SizedBox(
                    height: 200,
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class DescriptionExpandedTile extends StatelessWidget {
  final Restaurant detailRestaurant;

  const DescriptionExpandedTile({
    Key? key,
    required ExpandedTileController controller,
    required this.detailRestaurant,
  })  : _controllerDescription = controller,
        super(key: key);

  final ExpandedTileController _controllerDescription;

  @override
  Widget build(BuildContext context) {
    return ExpandedTile(
      title: Text('Description', style: Theme.of(context).textTheme.headline6),
      content: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        child: Text(detailRestaurant.description,
            style: Theme.of(context).textTheme.bodyText2),
      ),
      controller: _controllerDescription,
    );
  }
}

class FoodExpandedTile extends StatelessWidget {
  final Restaurant detailRestaurant;

  const FoodExpandedTile({
    Key? key,
    required ExpandedTileController controllerFood,
    required this.detailRestaurant,
  })  : _controllerFood = controllerFood,
        super(key: key);

  final ExpandedTileController _controllerFood;

  @override
  Widget build(BuildContext context) {
    return ExpandedTile(
        title: Text('Food', style: Theme.of(context).textTheme.headline6),
        content: SizedBox(
          height: 164,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: detailRestaurant.menus.foods.map((food) {
              return SizedBox(
                width: 132,
                height: 132,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Image.asset('assets/images/food_thumbnail.png'),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          food.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .copyWith(
                                caption: GoogleFonts.poppins(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w600),
                              )
                              .caption,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        controller: _controllerFood);
  }
}

class DrinkExpandedTile extends StatelessWidget {
  final Restaurant detailRestaurant;

  const DrinkExpandedTile({
    Key? key,
    required ExpandedTileController controllerDrink,
    required this.detailRestaurant,
  })  : _controllerDrink = controllerDrink,
        super(key: key);

  final ExpandedTileController _controllerDrink;

  @override
  Widget build(BuildContext context) {
    return ExpandedTile(
        title: Text('Drink', style: Theme.of(context).textTheme.headline6),
        content: SizedBox(
          height: 164,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: detailRestaurant.menus.drinks.map((drink) {
              return SizedBox(
                height: 132,
                width: 132,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Image.asset('assets/images/drink_thumbnail.png'),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          drink.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .copyWith(
                                caption: GoogleFonts.poppins(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600),
                              )
                              .caption,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        controller: _controllerDrink);
  }
}

class ReviewExpandedTile extends StatelessWidget {
  final Restaurant detailRestaurant;
  final TextEditingController _inputNameController = TextEditingController();
  final TextEditingController _inputReviewController = TextEditingController();

  ReviewExpandedTile({
    Key? key,
    required ExpandedTileController controllerReview,
    required this.detailRestaurant,
  })  : _controllerReview = controllerReview,
        super(key: key);

  final ExpandedTileController _controllerReview;

  @override
  Widget build(BuildContext context) {
    return ExpandedTile(
        title: Text('Consumer Review',
            style: Theme.of(context).textTheme.headline6),
        content: ChangeNotifierProvider<CustomerReviewProvider>(
          create: (_) => CustomerReviewProvider(
              apiService: ApiService(),
              restaurantId: detailRestaurant.id,
              name: _inputNameController.text,
              review: _inputReviewController.text),
          child: Consumer<CustomerReviewProvider>(builder: (context, state, _) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Review'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Add Customer Review'),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(16),
                                      child: TextField(
                                        controller: _inputNameController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Nama',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: TextField(
                                        controller: _inputReviewController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Review',
                                        ),
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text('Submit'),
                                  onPressed: () {
                                    if (_inputNameController.text.isNotEmpty &&
                                        _inputReviewController
                                            .text.isNotEmpty) {
                                      state.postCustomerReview(
                                          detailRestaurant.id,
                                          _inputNameController.text,
                                          _inputReviewController.text);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context,
                                          RestaurantDetailPage.routeName,
                                          arguments: detailRestaurant.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text('Review berhasil ditambahkan'),
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(state.message),
                                      ));
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }),
                ),
                Column(
                  children: detailRestaurant.customerReviews.map((customer) {
                    return Card(
                      child: ListTile(
                        leading: Image.asset('assets/images/user.png'),
                        title: Text(customer.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.date,
                              style: const TextStyle(color: primaryColor),
                            ),
                            Text(customer.review),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }),
        ),
        controller: _controllerReview);
  }
}
