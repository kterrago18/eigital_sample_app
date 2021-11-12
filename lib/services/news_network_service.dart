import 'dart:convert';

import 'package:eigital_sample_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const newsBaseUrl = 'newsapi.org';

class NewsNetworkService {
  var client = http.Client();

  Map<String, dynamic> queryParameters = {
    'country': 'ph',
    'apiKey': '0679c05b277d4111b5c12d333fcc6592',
    'sortBy': 'publishedAt'
  };

  Future<List<NewsData>> fetchNewsData() async {
    var uri = Uri(
      scheme: 'https',
      host: newsBaseUrl,
      path: 'v2/top-headlines',
      queryParameters: queryParameters,
    );

    var response = await http.get(uri);

    var jsonData;

    if (response.statusCode != 200) {
      debugPrint('Connection error occured');
    } else {
      jsonData = jsonDecode(response.body);
    }

    return NewsData.fromJson(jsonData);
  }
}
