import 'package:flutter/material.dart';
import '../model/newsapiresponse.dart';

class ArticleItem extends StatelessWidget {
  final Articles article;
  ArticleItem({@required this.article});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        radius: 8.0,
        child: _getCardView(context),
      ),
    );
  }

  _getCardView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Hero(
          tag: article.urlToImage,
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                article.description,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.body2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
