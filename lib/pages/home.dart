import 'package:flutter/material.dart';
import '../pages/homefeed.dart';
import '../pages/about.dart';
import '../pages/newssource.dart';
import '../widgets/btmnavigation.dart';

class LandingPage extends StatefulWidget {
  final String title;
  LandingPage({this.title});

  @override
  State<StatefulWidget> createState() => _LandingPage();
}

class _LandingPage extends State<LandingPage> with TickerProviderStateMixin {
  int _curIndex = 0;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: EdgeInsets.only(top: 20.0),
        color: Colors.grey[200],
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Expanded(child: getPageContent(_curIndex))
          ],
        ),
      ),
      bottomNavigationBar: new BottomNavigation(onTabTapped),
    );
  }

  onTabTapped(int index) {
    if (index != _curIndex) {
      setState(() {
        _curIndex = index;
      });
    }
  }
  Widget getPageContent(index) {
    Widget content;
    switch (index) {
      case 0:
        content = new HomePageFeed();
        break;
      case 1:
        content = new SourcesPage();
        break;
      default:
        {
          content = new About(new AnimationController(
              vsync: this, duration: new Duration(milliseconds: 500)));
          (content as About).animationController.forward();
        }
    }

    return content;
  }
}
