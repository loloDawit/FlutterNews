import 'package:flutter/material.dart';
import '../model/newsapiresponse.dart';

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
          backgroundColor: Colors.grey,
          body: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: article.urlToImage,
                      child: Container(
                        height: 400.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage("${article.urlToImage}"
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      article.title,
                      style: Theme.of(context).textTheme.title, softWrap:true ,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      article.description,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
