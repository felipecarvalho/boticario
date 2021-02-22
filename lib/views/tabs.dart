import 'package:flutter/cupertino.dart';
import 'package:boticario/views/news/news.dart';
import 'package:boticario/views/posts/posts.dart';
import 'package:boticario/utils/colors/colors.dart';
import 'package:boticario/components/tab/tab.dart';

class AppTabs extends StatefulWidget {
  AppTabs({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AppTabsState createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> {
  int _selectedItem = 0;

  List<Map> _routeItems = [
    {
      'herotag': 'posts',
      'title': 'Postagens',
      'icon': CupertinoIcons.home,
      'screen': Posts(),
    },
    {
      'herotag': 'news',
      'title': 'Novidades',
      'icon': CupertinoIcons.doc_plaintext,
      'screen': News(),
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        onTap: _onItemTapped,
        iconSize: 24.0,
        activeColor: DefaultSwatches.standard,
        inactiveColor: DefaultSwatches.primary,
        items: <BottomNavigationBarItem>[
          for (var item in _routeItems)
            BottomNavigationBarItem(
              icon: Icon(item['icon']),
              label: item['title'],
            )
        ],
      ),
      tabBuilder: (context, index) => Stack(
        children: <Widget>[
          IndexedStack(
            index: _selectedItem,
            children: <Widget>[
              for (var item in _routeItems)
                Tab(
                  title: item['title'],
                  heroTag: item['herotag'],
                  screen: item['screen'],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
