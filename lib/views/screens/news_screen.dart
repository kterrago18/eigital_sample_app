import 'package:eigital_sample_app/models/models.dart';
import 'package:eigital_sample_app/services/news_network_service.dart';
import 'package:eigital_sample_app/views/components/news_data_list_view.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  final newsNetworkService = NewsNetworkService();

  NewsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: FutureBuilder(
        future: newsNetworkService.fetchNewsData(),
        builder: (context, AsyncSnapshot<List<NewsData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return NewsDataListView(newsData: snapshot.data ?? []);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
