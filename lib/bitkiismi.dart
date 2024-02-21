import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {

  final _controller = TextEditingController();
  final _database =

  FirebaseDatabase.instance.reference().child('test').child('json').child('name').child('plant');


  void _saveName(String name) async {

    await _database.set(name);
  }

  Future<String> _getName() async {

    final snapshot = await _database.once();

    return snapshot.value.toString();

  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemIndigo,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.systemIndigo,
          middle: Text(
            'İsim Ekle',
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
              color: CupertinoColors.white,
            ),
          ),
          border: null,
        ),
        child: SafeArea(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text(
    'Lütfen Bitkinizin Sizi Daha İyi Tanıması İçin İsminizi Giriniz. \n',
    style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: CupertinoColors.white,
    ),
    ),
    SizedBox(height: 20),
    Container(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: CupertinoColors.white,
    ),
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: CupertinoTextField(
    controller: _controller,
    placeholder: 'İsmim...',
    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
    color: CupertinoColors.black,
    ),
    ),
    ),
    ),
    SizedBox(height: 20),
    CupertinoButton(
    color: CupertinoColors.systemGreen,
    onPressed: () {
    _saveName(_controller.text);
    showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
    title: Text(
    'İsim Kayıt Edildi.',
    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
    color: CupertinoColors.black,
    fontWeight: FontWeight.bold,
    ),
    ),
    actions: [
    CupertinoDialogAction(
    child: Text(
    'Tamam',
    style: CupertinoTheme.of(context).textTheme.actionTextStyle.copyWith(
    color: CupertinoColors.systemGreen,
    ),
    ),
    onPressed: () => Navigator.pop(context),
    ),
    ],
    ),
    );
    },
    child: Text(
    'Kaydet',
    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
    color: CupertinoColors.white,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    SizedBox(height: 20),
    FutureBuilder(


    future: _getName(),
    builder: (context, snapshot) {
    if (snapshot.hasData) {

    final name = snapshot.data;

    return Text(
    'Merhaba, $name.',
    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: CupertinoColors.white,
    ),
    );
    } else if (snapshot.hasError) {
    return Text(
    'Hata: ${snapshot.error}',
    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
    color: CupertinoColors.white,
    ),
    );
    } return SizedBox(
      height: 22,
      child: CupertinoActivityIndicator(),
    );
    },
    ),
    ],
    ),
        ),
        ),
    );

  }

}

