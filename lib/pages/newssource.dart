import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:newsapi/apiConfig.dart';

class SourcesPage extends StatefulWidget {
  SourcesPage({Key key}) : super(key: key);

  @override
  _SourcesPage createState() => new _SourcesPage();
}

class _SourcesPage extends State<SourcesPage> {
  var sources;
  bool change = false;
  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  Future getData() async {
    var libSources = await http.get(
        Uri.encodeFull('https://newsapi.org/v2/sources?language=en'),
        headers: {
          "Accept": "application/json",
          "X-Api-Key": NewsApiKey.apiKey
        });
    if (mounted) {
      this.setState(() {
        sources = json.decode(libSources.body);
      
      });
    }
    return "Success!";
  }
  CircleAvatar _loadAvatar(var url) {
    try {
      String imageUrl = 'https://logo.clearbit.com/'+ url;
     
      return new CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: new NetworkImage(imageUrl),
        radius: 40.0,
      );
    } catch (Exception) {
      return new CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2014/10/12/12/38/google-485611_1280.jpg'),
        radius: 40.0,
      );
    } 
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[200],
      body: sources == null
          ? const Center(child: const CircularProgressIndicator())
          : new GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 25.0),
              padding: const EdgeInsets.all(10.0),
              itemCount: sources == null ? 0 : sources['sources'].length,
              itemBuilder: (BuildContext context, int index) {
                return new GridTile(
                  footer: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Flexible(
                          child: new SizedBox(
                            height: 16.0,
                            width: 100.0,
                            child: new Text(
                              sources['sources'][index]['name'],
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ]),
                  child: new Container(
                    height: 500.0,
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: new GestureDetector(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new SizedBox(
                            height: 100.0,
                            width: 100.0,
                            child: new Row(
                              children: <Widget>[
                                new Stack(
                                  children: <Widget>[
                                    new SizedBox(
                                      child: new Container(
                                        child: _loadAvatar(
                                            sources['sources'][index]['url']),
                                            
                                        padding: const EdgeInsets.only(
                                            left: 10.0, top: 12.0, right: 10.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        print('this works');
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
