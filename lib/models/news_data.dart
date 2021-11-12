import 'package:flutter/material.dart';

class NewsData {
  final String? title;
  final String? description;
  final DateTime? publishedAt;
  final String? url;
  final String? urlToImage;
  final String? name;
  final String? author;

  NewsData(
      {this.title,
      this.description,
      this.publishedAt,
      this.author,
      this.url,
      this.urlToImage,
      this.name});

  static List<NewsData> fromJson(dynamic json) {
    final jsonData = json['articles'];

    final List<NewsData> newsData = [];

    try {
      for (var data in jsonData) {
        NewsData country = NewsData(
          author: data['author'] ?? '',
          name: data['source']['name'],
          title: data['title'],
          description: data['description'] ?? '',
          url: data['url'] ?? '',
          urlToImage: data['urlToImage'] ?? '',
          publishedAt: DateTime.parse(data['publishedAt']),
        );

        newsData.add(country);
      }
    } catch (e) {
      debugPrint('fromJson Error: $e');
    }

    return newsData;
  }
}
