import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../widgets/newstileview.dart';
import '../model/newsapiresponse.dart';
import 'package:http/http.dart' as http;
import '../pages/search.dart' as SearchPage;
import '../apiConfig.dart';

class HomePageFeed extends StatefulWidget {
  final String title;
  HomePageFeed({this.title});

  @override
  State<StatefulWidget> createState() => _HomePageFeed();
}

class _HomePageFeed extends State<HomePageFeed> {
  String url = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=' +
      NewsApiKey.apiKey;
  NewsApiResponse article;

  final TextEditingController _controller = new TextEditingController();
  int _curIndex = 0;
  @override
  void initState() {
    super.initState();
    fetchNews();
  }
   @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.all(0.0),
            child: new PhysicalModel(
              color: Colors.white,
              child: new TextField(
                controller: _controller,
                onSubmitted: onSubmit,
                decoration: InputDecoration(
                    hintText: 'Search for news here', icon: Icon(Icons.search)),
              ),
            ),
          ),
          Expanded(
            child: article == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return ArticleListItem(
                          article: article.articles[index],
                        );
                      },
                      itemCount: article.articles.length,
                    ),
                    onRefresh: _handleRefresh,
                  ),
          )
        ],
      ),
    );
  }

  void fetchNews() async {
    try {
      var response = await http.get(url);
      var decodedJson = jsonDecode(response.body);
      setState(() {
        article = NewsApiResponse.fromJson(decodedJson);
      });
    } on Exception catch (exp) {
      print(exp);
    }
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {
      fetchNews();
    });
    return null;
  }

  onTabTapped(int index) {
    if (index != _curIndex) {
      setState(() {
        _curIndex = index;
      });
    }
  }

  void onSubmit(var input) {
    if (input != '') {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (_) =>
                  SearchPage.SearchResultsPage(searchQuery: input)));
    }
  }
}
