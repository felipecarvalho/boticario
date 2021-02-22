import 'package:boticario/utils/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class Tab extends StatelessWidget {
  const Tab({
    Key key,
    @required this.title,
    @required this.screen,
    @required this.heroTag,
  }) : super(key: key);

  final String title;
  final Widget screen;
  final String heroTag;

  _logoutUser(context) {
    Box _global = Hive.box('global');
    _global.delete('loggedUser');
    Navigator.popAndPushNamed(context, '/logout');
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          heroTag: heroTag,
          border: Border.symmetric(horizontal: BorderSide.none),
          backgroundColor: DefaultSwatches.light,
          leading: CupertinoButton(
            minSize: 0.0,
            padding: EdgeInsets.zero,
            child: Text(
              'Sair',
              style: TextStyle(
                color: DefaultSwatches.standard,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () => _logoutUser(context),
          ),
          largeTitle: Text(
            title,
            style: TextStyle(
              color: DefaultSwatches.primary,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [screen, SizedBox(width: double.infinity, height: 150.0)],
          ),
        ),
        // SliverFillRemaining(
        //   hasScrollBody: true,
        //   child: screen,
        // ),
      ],
    );
  }
}
