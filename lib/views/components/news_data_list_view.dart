import 'package:eigital_sample_app/models/models.dart';
import 'package:eigital_sample_app/models/news_data.dart';
import 'package:eigital_sample_app/views/components/news_tile.dart';
import 'package:flutter/material.dart';

class NewsDataListView extends StatelessWidget {
  final List<NewsData> newsData;
  const NewsDataListView({Key? key, required this.newsData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return NewsTile(
          url: newsData.elementAt(index).url,
          author: newsData.elementAt(index).author,
          urlToImage: newsData.elementAt(index).urlToImage,
          title: newsData.elementAt(index).title,
          description: newsData.elementAt(index).description,
          name: newsData.elementAt(index).name,
          publishedAt:
              TimeAgo().getTimeAgo(newsData.elementAt(index).publishedAt!),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 16,
        );
      },
      itemCount: newsData.length,
    );
  }
}
