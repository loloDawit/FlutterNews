import 'dart:convert';

import 'package:flutter/material.dart';
import '../widgets/newstileview.dart';
import '../model/newsapiresponse.dart';
import 'package:http/http.dart' as http;
import '../apiConfig.dart';

class HomePageFeed extends StatefulWidget {
  final String title;
  HomePageFeed({this.title});

  @override
  State<StatefulWidget> createState() => _HomePageFeed();
}

class _HomePageFeed extends State<HomePageFeed> {
  String url = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=' +
      NewsApi.apiKey;
  NewsApiResponse article;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: article == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ArticleItem(
                  article: article.articles[index],);
              },
              itemCount: article.articles.length,
            ),
    );
  }

  void fetchNews() async {
    var response = await http.get(url);
    var decodedJson = jsonDecode(response.body);
    print(article);
    print(response.body);
    setState(() {
      article = NewsApiResponse.fromJson(decodedJson);
    });
  }
}
