import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:boticario/utils/colors/colors.dart';
import 'package:flutter/widgets.dart';

class GlobalProvider extends StatelessWidget {
  GlobalProvider({
    Key key,
    @required this.child,
  });

  final Widget child;

  Future<void> initBox() async {
    await Hive.initFlutter();
    await Hive.openBox('global');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initBox(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return child;
        } else {
          return Container(
            color: DefaultSwatches.light,
          );
        }
      },
    );
  }
}
