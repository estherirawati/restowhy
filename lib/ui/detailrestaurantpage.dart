import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto/data/api/api_service.dart';
import 'package:resto/provider/restodetail_provider.dart';

import '../data/model/restaurant.dart';
import '../provider/dbprovider.dart';

class RestaurantDetailPage extends StatefulWidget {
  RestaurantDetailPage(String this.idResto, {Key? key}) : super(key: key);
  String idResto;
  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RestoDetailProvider>(
    create: (context) => RestoDetailProvider(
    apiService: ApiService(),
    idResto: widget.idResto,
    ),
    // TODO: implement build
    child: Scaffold(
      body:
        Consumer<RestoDetailProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.hasData) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text(state.result.restaurant.name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                  ),
                  body: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            children: <Widget>[
                              Image.network("https://restaurant-api.dicoding.dev/images/medium/${state.result.restaurant.pictureId}"),
                              Consumer<DbProvider>(
                              builder: (context, provider, child) {
                                return FutureBuilder(
                                    future: provider
                                        .getRestoById(state.result.restaurant.id),
                                    builder: (context, snapshot) {

                                      if ((snapshot.data??false)==true) {
                                        return
                                          SafeArea(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end,
                                                children: [
                                                  IconButton(icon:Icon(Icons
                                                          .favorite,
                                                      color: Colors.red),
                                                      highlightColor: Colors.red,
                                                      onPressed: () {
                                                        setState(() {
                                                        });

                                                          Provider.of<DbProvider>(
                                                              context,
                                                              listen: false)
                                                              .deleteResto(
                                                              state.result
                                                                  .restaurant
                                                                  .id);


                                                      }),
                                                ],
                                              ),
                                            ),
                                          );
                                      }
                                      else {
                                        return
                                          SafeArea(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .end,
                                                children: [
                                                  IconButton(icon:Icon(Icons
                                                      .favorite_border,
                                                      color: Colors.red),
                                                      highlightColor: Colors.red,
                                                      onPressed: () {
                                                        setState(() {
                                                        });

                                                        Provider.of<DbProvider>(
                                                            context,
                                                            listen: false)
                                                            .addResto(
                                                            Restaurant(
                                                                id: state.result
                                                                    .restaurant
                                                                    .id,
                                                                name: state.result
                                                                    .restaurant
                                                                    .name,
                                                                description: state
                                                                    .result
                                                                    .restaurant
                                                                    .description,
                                                                pictureId: state
                                                                    .result
                                                                    .restaurant
                                                                    .pictureId,
                                                                city: state.result
                                                                    .restaurant
                                                                    .city,
                                                                rating: state
                                                                    .result
                                                                    .restaurant
                                                                    .rating));


                                                      }),
                                                ],
                                              ),
                                            ),
                                          );
                                      }
                                    });
                              })
                            ]
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.result.restaurant.description,
                                  ),
                                  Divider(color: Colors.grey),
                                  Icon(Icons.add_location),
                                  Text(
                                    state.result.restaurant.city,
                                  ),
                                  Icon(Icons.star),
                                  Text(state.result.restaurant.rating.toString()),
                                  const Divider(color: Colors.grey),
                                  Text("Menus",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24)),
                                  Text(
                                    "Foods:",
                                  ),
                                  Container(
                                    width: 1000,
                                    height: 100,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.result.restaurant.menus.foods.length,
                                      itemBuilder: (BuildContext context, int index) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          child: Center(
                                              child: Text(
                                                  state.result.restaurant.menus.foods[index].name.toString())),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Drinks:",
                                  ),
                                  Container(
                                    width: 1000,
                                    height: 50,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.result.restaurant.menus.drinks.length,
                                      itemBuilder: (BuildContext context, int index) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          child: Center(
                                              child: Text(
                                                  state.result.restaurant.menus.drinks[index].name.toString())),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      )),
                );
            } else if (state.state == ResultState.noData) {
              return Center(
                child: Material(
                  child: Text(state.message),
                ),
              );
            } else if (state.state == ResultState.error) {
              return Center(
                child: Material(
                  child: Text(state.message),
                ),
              );
            } else {
              return const Center(
                child: Material(
                  child: Text(''),
                ),
              );
            }
          },
        ),
    )
    );
  }
  // @override
  // void initState() {
  //   isFavorite = Provider.of<DbProvider>(context,listen:false).getRestoById(widget.idResto) as bool;
  // }
}