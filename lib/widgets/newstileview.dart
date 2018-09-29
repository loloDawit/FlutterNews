import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/detailsview.dart';
import '../model/newsapiresponse.dart';
import 'package:timeago/timeago.dart' as timeago;

class ArticleListItem extends StatelessWidget {
  final Articles article;
  ArticleListItem({@required this.article});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        // shape of the card
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 8.0,
      margin: EdgeInsets.all(5.0),
      child: InkWell(
        radius: 8.0,
        child: _getCardView(context),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailsPage(article: article)));
        },
      ),
    );
  }

  _getCardView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Hero(
          tag:_randonNum().toString()+article.urlToImage,
          child: Container(
            height: 200.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage('${article.urlToImage}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                article.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              Text(
                article.description == null
                    ? 'No description provided by source'
                    : article.description,
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                    fontSize: 11.0, color: Colors.black.withOpacity(0.6)),
              ),
              Row(
                children: <Widget>[
                  Text(timeago.format(DateTime.parse(article.publishedAt)), style: TextStyle( fontSize: 10.0),),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    'source:' + article.source.name,
                    style: TextStyle(fontSize: 10.0),
                  ),
                ],
                
              )
            ],
          ),
        ),
      ],
    );
  }
  _randonNum(){
    var rnum = new Random();
    for(int i=0; i<100;i++){
      return rnum.nextInt(100);
    }
    return rnum.toString();
  }
}
