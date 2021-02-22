import 'package:boticario/utils/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:boticario/components/textfield/textfield.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email;
  String pswd;
  bool fieldsOk = false;
  bool isLoading = false;
  String error = '';
  String emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  Box _global = Hive.box('global');

  @override
  initState() {
    super.initState();
  }

  _verifyFields() {
    if (email.isNotEmpty &&
        RegExp(emailRegex).hasMatch(email) &&
        pswd.length >= 6 &&
        pswd.isNotEmpty) {
      fieldsOk = true;
    } else {
      fieldsOk = false;
    }
  }

  _submitAction() {
    if (fieldsOk == true) {
      return () => doLogin();
    } else {
      return null;
    }
  }

  Future getUsers() async {
    var data = _global.get('users', defaultValue: <List>[]);
    return data;
  }

  Future<void> doLogin() async {
    List<Map> user = [];
    setState(() {
      isLoading = true;
    });

    var savedUsers = await getUsers();

    for (var item in savedUsers) {
      if (item['email'] == email && item['pswd'] == pswd) {
        user.add(item);
      }
    }

    Future.delayed(Duration(seconds: 3), () async {
      if (user.isNotEmpty) {
        await _global.put('loggedUser', user);
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          error = '• O email ou senha estão incorretos';
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width / 4,
                ),
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
            Text(
              'Bem-vindo',
              style: Theme.of(context).textTheme.headline4.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              'Para prosseguir insira seus dados abaixo',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: DefaultSwatches.primary,
                  ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: error.isNotEmpty ? 16.0 : 0.0,
              ),
              child: Text(
                '$error',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: DefaultSwatches.standard,
                    ),
              ),
            ),
            InputText(
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              onChanged: (text) {
                setState(() {
                  email = text;
                });
                _verifyFields();
              },
            ),
            InputText(
              obscureText: true,
              label: 'Senha',
              onChanged: (text) {
                setState(() {
                  pswd = text;
                });
                _verifyFields();
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: DefaultSwatches.standard,
                  disabledColor: DefaultSwatches.standard50,
                  child: isLoading
                      ? CupertinoActivityIndicator()
                      : Text(
                          'Entrar',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  onPressed: isLoading ? null : _submitAction(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Center(
                child: CupertinoButton(
                  child: Text(
                    'Não tem usuário? Cadastre-se!',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: DefaultSwatches.standard,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
