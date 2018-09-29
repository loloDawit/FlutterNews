import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../model/newsapiresponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../apiConfig.dart';

import 'package:share/share.dart';

class SearchResultsPage extends StatefulWidget {
  final searchQuery;
  SearchResultsPage({
    Key key,
    this.searchQuery = "",
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchResultsPage( searchQuery: this.searchQuery);
}

class _SearchResultsPage extends State<SearchResultsPage> {
  _SearchResultsPage({this.searchQuery});
  var searchQuery;
  NewsApiResponse article;
  int _curIndex = 0;

  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();
  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(searchQuery),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: article == null
          ? const Center(child: const CircularProgressIndicator())
          : article.articles.length < 1
              ? new Padding(
                  padding: new EdgeInsets.only(top: 60.0),
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        new Icon(Icons.error_outline,
                            size: 60.0, color: Colors.redAccent[200]),
                        new Center(
                          child: new Text(
                            "Could not find anything related to '$searchQuery'",
                            textScaleFactor: 1.5,
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      ]))
              : new ListView.builder(
                  itemCount: article.articles.length < 51
                      ? article.articles.length
                      : 50,
                  itemBuilder: (BuildContext context, int index) {
                    return new GestureDetector(
                      child: new Card(
                        elevation: 1.7,
                        child: new Padding(
                          padding: new EdgeInsets.all(10.0),
                          child: new Column(
                            children: [
                              new Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: new EdgeInsets.only(left: 4.0),
                                    child: new Text(
                                      timeago.format(DateTime.parse(
                                          article.articles[index].publishedAt)),
                                      style: new TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  new Padding(
                                    padding: new EdgeInsets.all(5.0),
                                    child: new Text(
                                      article.articles[index].source.name,
                                      style: new TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              new Row(
                                children: [
                                  new Expanded(
                                    child: new GestureDetector(
                                      child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          new Padding(
                                            padding: new EdgeInsets.only(
                                                left: 4.0,
                                                right: 8.0,
                                                bottom: 8.0,
                                                top: 8.0),
                                            child: new Text(
                                              article.articles[index].title,
                                              style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          new Padding(
                                            padding: new EdgeInsets.only(
                                                left: 4.0,
                                                right: 4.0,
                                                bottom: 4.0),
                                            child: new Text(
                                              article
                                                  .articles[index].description,
                                              style: new TextStyle(
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        flutterWebviewPlugin.launch(
                                            article.articles[index].url);
                                      },
                                    ),
                                  ),
                                  new Column(
                                    children: <Widget>[
                                      new Padding(
                                        padding: new EdgeInsets.only(top: 8.0),
                                        child: new SizedBox(
                                          height: 100.0,
                                          width: 100.0,
                                          child: new Image.network(
                                            article.articles[index].urlToImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      new Row(
                                        children: <Widget>[
                                          new GestureDetector(
                                            child: new Padding(
                                                padding:
                                                    new EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 5.0),
                                                child: buildButtonColumn(
                                                    Icons.share)),
                                            onTap: () {
                                              Share.share(
                                                  article.articles[index].url);
                                            },
                                          ),
                                          // new GestureDetector(
                                          //   child: new Padding(
                                          //       padding:
                                          //           new EdgeInsets.all(5.0),
                                          //       child: _hasArticle(
                                          //               article.articles[index])
                                          //           ? buildButtonColumn(
                                          //               Icons.bookmark)
                                          //           : buildButtonColumn(
                                          //               Icons.bookmark_border)),
                                          //   onTap: () {
                                          //     _onBookmarkTap(
                                          //         article.articles[index]);
                                          //   },
                                          // ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
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

  void fetchNews() async {
    try {
      var response = await http.get('https://newsapi.org/v2/everything?q=' +
          searchQuery +
          '&sortBy=popularity&apiKey=' +
          NewsApiKey.apiKey);
      var decodedJson = jsonDecode(response.body);
      setState(() {
        article = NewsApiResponse.fromJson(decodedJson);
      });
    } on Exception catch (exp) {
      print(exp);
    }
  }

  buildButtonColumn(IconData icon) {
    Color color = Theme.of(context).primaryColor;
    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        new Icon(icon, color: color),
      ],
    );
  }

  _onBookmarkTap(article) {
    print('Bookmark testing..');
  }

  _hasArticle(article) {
    print('Testing...');
  }
}
