import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:resto/data/api/api_service.dart';
import 'package:resto/data/model/restaurant_detail.dart';
import 'package:resto/data/model/restaurants_result.dart';
import 'package:resto/data/model/restaurant_search.dart';

void main() {
  group(
    'Uji Coba API Restaurant ',
        () {
      test(
        'Mengembalikan Daftar Restoran',
            () async {
          final client = MockClient((request) async {
            final response = {
              "error": false,
              "message": "success",
              "count": 20,
              "restaurants": []
            };
            return Response(json.encode(response), 200);
          });
          expect(
            await ApiService().restaurants(client),
            isA<Welcome>(),
          );
        },
      );

      test(
        "Mengembalikan Detail Restoran",
            () async {
          final client = MockClient(
                (request) async {
              final response = {
                "error": false,
                "message": "success",
                "restaurant": {
                  "id": "",
                  "name": "",
                  "description": "",
                  "city": "",
                  "address": "",
                  "pictureId": "",
                  "categories": [],
                  "menus": {"foods": [], "drinks": []},
                  "rating": 1.0,
                  "customerReviews": []
                }
              };
              return Response(json.encode(response), 200);
            },
          );
          expect(
            await ApiService().restaurantDetail('Id Resto', client),
            isA<RestaurantDetail>(),
          );
        },
      );

      test(
        'Mencari Restoran',
            () async {
          final client = MockClient(
                (request) async {
              final response = {
                "error": false,
                "founded": 1,
                "restaurants": []
              };
              return Response(json.encode(response), 200);
            },
          );

          expect(await ApiService().restaurantSearch('Nama Resto', client),
              isA<RestaurantSearchResult>());
        },
      );
    },
  );
}