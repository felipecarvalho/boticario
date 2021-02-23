import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:boticario/utils/colors/colors.dart';
import 'package:boticario/services/http/http.dart';

class News extends StatefulWidget {
  News({Key key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  bool isLoading = false;
  List posts = [];
  dynamic http = HttpService();

  Future getNews() async {
    isLoading = true;

    var data = await http
        .getData('https://gb-mobile-app-teste.s3.amazonaws.com/data.json');

    setState(() {
      posts = data['news'];
      isLoading = false;
    });
  }

  @override
  initState() {
    super.initState();
    initializeDateFormatting();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'As novidades mais quentes sobre o Grupo Boticário',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: DefaultSwatches.primary,
                  ),
            ),
          ),
          isLoading ? Center(child: CupertinoActivityIndicator()) : Container(),
          for (var post in posts.reversed)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        child: Center(
                          child: Text(
                            'B',
                            style: TextStyle(
                              color: DefaultSwatches.standard,
                              fontWeight: FontWeight.w600,
                              fontSize: 26.0,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: DefaultSwatches.standard50,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    post['user']['name'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    ' em ' +
                                        DateFormat.Md('pt_BR').format(
                                            DateTime.parse(post['message']
                                                ['created_at'])) +
                                        ' às ' +
                                        DateFormat.Hm('pt_BR')
                                            .format(DateTime.parse(
                                                post['message']['created_at']))
                                            .toString(),
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 3.0),
                                child: Text(
                                  '${post['message']['content']}',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
