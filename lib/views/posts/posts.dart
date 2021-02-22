import 'package:hive/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:boticario/utils/colors/colors.dart';
import 'package:boticario/components/textfield/textfield.dart';

class Posts extends StatefulWidget {
  Posts({Key key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  String postText = '';
  TextEditingController postTextCtrl = TextEditingController();
  bool fieldsOk = false;
  bool isLoading = false;
  List posts = [];
  Box _global = Hive.box('global');

  @override
  initState() {
    super.initState();
    initializeDateFormatting();
    initPosts();
    // _global.delete('posts');
  }

  Widget _publishForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'O que você está pensando?',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontWeight: FontWeight.w600,
                color: DefaultSwatches.primary,
              ),
        ),
        InputText(
          minLines: 3,
          maxLines: 3,
          maxLength: 280,
          controller: postTextCtrl,
          onChanged: (text) {
            setState(() {
              postText = text;
            });
            _verifyFields();
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${postText.length}/280',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: DefaultSwatches.primary,
                  ),
            ),
            CupertinoButton(
              minSize: 0.0,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5.0),
                    child: isLoading
                        ? null
                        : Text(
                            'Publicar',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: fieldsOk
                                  ? DefaultSwatches.standard
                                  : DefaultSwatches.standard50,
                            ),
                          ),
                  ),
                  isLoading
                      ? CupertinoActivityIndicator()
                      : Icon(
                          CupertinoIcons.paperplane,
                          color: fieldsOk
                              ? DefaultSwatches.standard
                              : DefaultSwatches.standard50,
                        ),
                ],
              ),
              onPressed: isLoading ? null : _submitAction(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _allPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            posts.length > 0 ? 'O que estão falando?' : '',
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.w700,
                  color: DefaultSwatches.standard,
                ),
          ),
        ),
        for (var post in posts.reversed)
          Padding(
            padding: EdgeInsets.only(top: 20.0),
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
                          post['name'][0],
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
                                  post['name'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Text(
                                  ' em ' +
                                      DateFormat.Md('pt_BR')
                                          .format(post['date']) +
                                      ' às ' +
                                      DateFormat.Hm('pt_BR')
                                          .format(post['date'])
                                          .toString(),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 3.0),
                              child: Text(
                                '“${post['text']}”',
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
    );
  }

  _verifyFields() {
    if (postText.isNotEmpty && postText.length > 60 && postText.length <= 280) {
      fieldsOk = true;
    } else {
      fieldsOk = false;
    }
  }

  _submitAction() {
    if (fieldsOk == true) {
      return () => _createPost();
    } else {
      return null;
    }
  }

  Future getPosts() async {
    var data = _global.get('posts', defaultValue: <List>[]);
    return data;
  }

  Future initPosts() async {
    var data = _global.get('posts', defaultValue: <List>[]);
    posts = data;
  }

  Future<void> _createPost() async {
    List<Map> allposts = [];
    var user = _global.get('loggedUser');

    setState(() {
      isLoading = true;
    });

    Map newPost = {
      'name': user[0]['name'],
      'text': postText,
      'date': DateTime.now(),
    };

    var savedPosts = await getPosts();

    for (var post in savedPosts) {
      allposts.add(post);
    }

    Future.delayed(Duration(seconds: 3), () async {
      allposts.add(newPost);
      await _global.put('posts', allposts);
      postTextCtrl.clear();
      setState(() {
        posts = allposts;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _publishForm(),
          Divider(),
          _allPosts(),
        ],
      ),
    );
  }
}
