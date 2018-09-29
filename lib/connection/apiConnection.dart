import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class NewsApi {
  final String url = 'https://newsapi.org/v2/';
  Future<Map> loadSearch(query) async {
    String apiUrl =
        '$url/everything?q=$query&sortBy=publishedAt&apiKey=c7573d3c97504960831b2c7a496677bd';
    // Make a HTTP GET request to the CoinMarketCap API.
    // Await basically pauses execution until the get() function returns a Response
    try {
      http.Response response = await http.get(apiUrl);
      // Using the JSON class to decode the JSON String
      const JsonDecoder decoder = const JsonDecoder();
      return decoder.convert(response.body);
    } on Exception catch (_) {
      return null;
    }
  }
}
