import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../model/newsapiresponse.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatelessWidget {
  final Articles article;
  DetailsPage({this.article});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.bookmark_border),
        ),
        body: Scaffold(
          backgroundColor: Colors.white30,
          body: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag:_randonNum().toString()+ article.urlToImage,
                      child: Container(
                        height: 400.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage("${article.urlToImage}"),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      article.title,
                      style: Theme.of(context).textTheme.title,
                      softWrap: true,
                    ),
                    Text(timeago.format(DateTime.parse(article.publishedAt))),
                    SizedBox(
                      height: 12.0,
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        article.description + '...read more',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      onPressed: () {
                        _launchURL(article.url);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      print('error');
    }
  }

  Future _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
   _randonNum(){
    var rnum = new Random();
    for(int i=0; i<100;i++){
      return rnum.nextInt(100);
    }
    return rnum.toString();
  }
}
