import 'package:boticario/utils/colors/colors.dart';
import 'package:hive/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:boticario/components/textfield/textfield.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name;
  TextEditingController nameCtrl = TextEditingController();
  String email;
  TextEditingController emailCtrl = TextEditingController();
  String pswd;
  TextEditingController pswdCtrl = TextEditingController();
  String pswd2;
  TextEditingController pswd2Ctrl = TextEditingController();
  String error = '';
  bool fieldsOk = false;
  bool isLoading = false;
  String emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  Box _global = Hive.box('global');

  @override
  initState() {
    // _global.delete('users');
    super.initState();
  }

  _verifyFields() {
    if (!RegExp(emailRegex).hasMatch(email)) {
      error = '• O email inserido é inválido';
    } else if (pswd.length < 6) {
      error = '• As senha deve ter no mínimo 6 caracteres';
    } else if (pswd != pswd2) {
      error = '• As senhas inseridas não conferem';
    } else {
      error = '';
    }

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        RegExp(emailRegex).hasMatch(email) &&
        pswd.length >= 6 &&
        pswd.isNotEmpty &&
        pswd2.isNotEmpty &&
        pswd == pswd2) {
      fieldsOk = true;
    } else {
      fieldsOk = false;
    }
  }

  _submitAction() {
    if (fieldsOk == true) {
      return () => _createUser();
    } else {
      return null;
    }
  }

  Future getUsers() async {
    var data = _global.get('users', defaultValue: <List>[]);
    return data;
  }

  Future<void> _createUser() async {
    bool emailExists = false;
    List<Map> users = [];
    setState(() {
      isLoading = true;
    });

    Map newUser = {
      'name': name,
      'email': email,
      'pswd': pswd,
    };

    var savedUsers = await getUsers();

    for (var user in savedUsers) {
      users.add(user);
    }

    for (var item in users) {
      if (item['email'] == email) {
        emailExists = true;
      }
    }

    Future.delayed(Duration(seconds: 3), () async {
      if (!emailExists) {
        users.add(newUser);
        await _global.put('users', users);
        nameCtrl.clear();
        emailCtrl.clear();
        pswdCtrl.clear();
        pswd2Ctrl.clear();
        setState(() {
          isLoading = false;
        });
        displayDialog();
      } else {
        setState(() {
          error = '• O email já está cadastrado';
          isLoading = false;
        });
      }
    });
  }

  void displayDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: Text(
            'Seu cadastro foi realizado com sucesso, agora você pode se logar no app.'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              'Ok',
              style: TextStyle(color: DefaultSwatches.standard),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            border: Border.symmetric(horizontal: BorderSide.none),
            backgroundColor: DefaultSwatches.light,
            previousPageTitle: 'Voltar',
            largeTitle: Text(
              'Cadastro',
              style: TextStyle(
                color: DefaultSwatches.primary,
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Para criar um novo usuário insira seus dados abaixo',
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
                    label: 'Nome',
                    controller: nameCtrl,
                    keyboardType: TextInputType.name,
                    onChanged: (text) {
                      setState(() {
                        name = text;
                      });
                      _verifyFields();
                    },
                  ),
                  InputText(
                    label: 'Email',
                    controller: emailCtrl,
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
                    controller: pswdCtrl,
                    label: 'Senha',
                    onChanged: (text) {
                      setState(() {
                        pswd = text;
                      });
                      _verifyFields();
                    },
                  ),
                  InputText(
                    obscureText: true,
                    controller: pswd2Ctrl,
                    label: 'Repita a senha',
                    onChanged: (text) {
                      setState(() {
                        pswd2 = text;
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
                                'Cadastrar',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        onPressed: isLoading ? null : _submitAction(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
