import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_realtimedb/ttgecmis.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTarih extends StatefulWidget {
  const ListTarih({Key key}) : super(key: key);

  @override
  _ListTarihState createState() => _ListTarihState();
}

class _ListTarihState extends State<ListTarih> {
  List<dynamic> searchResults = [];
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
  }
  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayıt Edilen Değerler Sorgusu'),
        elevation: 0,
        backgroundColor: Colors.black12,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              _startDateController.text = '';
              _endDateController.text = '';
              setState(() {
                searchResults.clear();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () {
                  _selectDate(_startDateController);
                },
                child: IgnorePointer(
                  child: TextField(
                    controller: _startDateController,
                    decoration: InputDecoration(
                      hintText: 'Başlangıç Tarihi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: EdgeInsets.all(16.0),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: Icon(Icons.calendar_today),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey[300],
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () {
                  _selectDate(_endDateController);
                },
                child: IgnorePointer(
                  child: TextField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                      hintText: 'Bitiş Tarihi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: EdgeInsets.all(16.0),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: Icon(Icons.calendar_today),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey[300],
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  _searchFirebase();
                },
                child: Text('Ara'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 10.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      searchResults[index]['date'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Saat: ${searchResults[index]['time']}, Sıcaklık: ${searchResults[index]['value']}°C',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _searchFirebase() {
    String startDate = _startDateController.text;
    String endDate = _endDateController.text;

    _databaseReference.child('test/json/history2').once().then((DataSnapshot snapshot) {
      List<dynamic> results = [];
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        if (value['date'] != null && value['date'] != '') {
          DateTime date = DateTime.parse(value['date']);
          DateTime start = DateTime.parse(startDate);
          DateTime end = DateTime.parse(endDate);
          if (date.isAfter(start.subtract(Duration(days: 1))) && date.isBefore(end.add(Duration(days: 1)))) {
            results.add(value);
          }
        }
      });
      setState(() {
        searchResults = results;
      });
    });
  }
}

/*
class ListTarih extends StatefulWidget {
  const ListTarih({Key key}) : super(key: key);

  @override
  _ListTarihState createState() => _ListTarihState();
}

class _ListTarihState extends State<ListTarih> {

List<dynamic> searchResults = [];
final TextEditingController _startDateController = TextEditingController();
final TextEditingController _endDateController = TextEditingController();
DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

final FirebaseService firebaseService = FirebaseService();  // veriyi her giridğidne kaydetisn diye
@override
void initState() {
super.initState();
firebaseService.saveDoubleToHistory(); // veriyi er girdiğinde kaydetsin diye
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('Sorgu'),
),
body: Column(
children: [
Padding(
padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
child: TextField(
controller: _startDateController,
decoration: InputDecoration(
hintText: 'Başlangıç Tarihi (örn: 2002-02-28)',
border: OutlineInputBorder(),
contentPadding: EdgeInsets.all(16.0),
),
),
),
Padding(
padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
child: TextField(
controller: _endDateController,
decoration: InputDecoration(
hintText: 'Bitiş Tarihi (örn: 2002-04-20)',
border: OutlineInputBorder(),
contentPadding: EdgeInsets.all(16.0),
),
),
),
SizedBox(height: 16.0),
ElevatedButton(
onPressed: () {
_searchFirebase();
},
child: Text('Ara'),
),
SizedBox(height: 16.0),
Expanded(
child:ListView.builder(
  itemCount: searchResults.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(searchResults[index]['date']),
      subtitle: Text(
          'Saat: ${searchResults[index]['time']}, Sıcaklık: ${searchResults[index]['value']}°C'),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          setState(() {
            searchResults.removeAt(index);
          });
          String date = searchResults[index]['date'];
          String time = searchResults[index]['time'];
          _databaseReference.child('hh').orderByChild('date').equalTo(date).once().then((DataSnapshot snapshot) {
            Map<dynamic, dynamic> values = snapshot.value;
            values.forEach((key, value) {
              if (value['time'] == time) {
                _databaseReference.child('hh').child(key).remove();
              }
            });
          });
        },
      )


    );

  },
),

),
],
),
);
}


void _searchFirebase() {
  String startDate = _startDateController.text;
  String endDate = _endDateController.text;

  _databaseReference.child('test/json/hh').once().then((DataSnapshot snapshot) {
    List<Map<dynamic, dynamic>> results = [];  // results listesi Map<dynamic, dynamic> türünde olmalı
    List<dynamic> values = snapshot.value as List<dynamic>;  // snapshot.value türü List<Object?> olduğundan dolayı değişkenin türü List<dynamic> olarak alınmalı
    values.forEach((value) {  // values listesi üzerinde dönerken key kısmına gerek yoktur
      if (value['date'] != null && value['date'] != '') {
        DateTime date = DateTime.parse(value['date']);
        DateTime start = DateTime.parse(startDate);
        DateTime end = DateTime.parse(endDate);
        if (date.isAfter(start.subtract(Duration(days: 1))) && date.isBefore(end.add(Duration(days: 1)))) {
          results.add(value as Map<dynamic, dynamic>);  // sadece Map<dynamic, dynamic> türünde veriler results listesine eklenir
        }
      }
    });
    setState(() {
      searchResults = results;
    });
  });
}



}  */

/* bu üsten daha iyi
class ListTarih extends StatefulWidget {
  const ListTarih({Key key}) : super(key: key);

  @override
  _ListTarihState createState() => _ListTarihState();
}

class _ListTarihState extends State<ListTarih> {
  List<dynamic> searchResults = [];
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Sorgu'),
    elevation: 0,
    backgroundColor: Colors.white,
    centerTitle: true,
    actions: [
    IconButton(
    icon: Icon(
    Icons.refresh,
    color: Colors.black,
    ),
    onPressed: () {
    _startDateController.text = '';
    _endDateController.text = '';
    setState(() {
    searchResults.clear();
    });
    },
    ),
    ],
    ),
    body: SingleChildScrollView(
    child: Column(
    children: [
    SizedBox(height: 16.0),
    Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: TextField(
    controller: _startDateController,
    decoration: InputDecoration(
    hintText: 'Başlangıç Tarihi (örn: 2002-02-28)',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    ),
    contentPadding: EdgeInsets.all(16.0),
    filled: true,
    fillColor: Colors.white,
    suffixIcon: Icon(Icons.calendar_today),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
    color: Colors.grey[300],
    ),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
    color: Colors.blue,
    ),
    ),
    ),
    ),
    ),
    SizedBox(height: 16.0),
    Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: TextField(
    controller: _endDateController,
    decoration: InputDecoration(
    hintText: 'Bitiş Tarihi (örn: 2002-04-20)',
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    ),
    contentPadding: EdgeInsets.all(16.0),
    filled: true,
    fillColor: Colors.white,
    suffixIcon: Icon(Icons.calendar_today),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
    color: Colors.grey[300],
    ),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
    color: Colors.blue,
    ),
    ),
    ),
    ),
    ),
    SizedBox(height: 16.0),
    Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: ElevatedButton(
    onPressed: () {
    _searchFirebase();
    },
    child: Text('Ara'),
    style: ElevatedButton.styleFrom(
    primary: Colors.blue,
    onPrimary: Colors.white,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
    ),
    padding: EdgeInsets.all(16.0),
    ),
    ),
    ),
    SizedBox(height: 16.0),
    Container(
    height: MediaQuery.of(context).size.height * 0.6,
    margin: EdgeInsets.symmetric(horizontal: 16.0),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8.0),
    boxShadow: [
    BoxShadow(
    color: Colors.grey[300],
    blurRadius: 10.0,
    offset: Offset(0, 2),
    ),
    ],
    ),
    child: ListView.builder(
    itemCount: searchResults.length,
    itemBuilder: (context, index) {
    return ListTile(
    title: Text(
    searchResults[index]['date'],
    style: TextStyle(
    fontWeight: FontWeight.bold,
    ),
    ),
    subtitle: Text(
      'Saat: ${searchResults[index]['time']}, Sıcaklık: ${searchResults[index]['value']}°C',
    ),
    );
    },
    ),
    ),
    ],
    ),
    ),
    );
  }

  void _searchFirebase() {
    String startDate = _startDateController.text;
    String endDate = _endDateController.text;

    _databaseReference.child('test/json/history2').once().then((DataSnapshot snapshot) {
      List<dynamic> results = [];
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        if (value['date'] != null && value['date'] != '') {
          DateTime date = DateTime.parse(value['date']);
          DateTime start = DateTime.parse(startDate);
          DateTime end = DateTime.parse(endDate);
          if (date.isAfter(start.subtract(Duration(days: 1))) && date.isBefore(end.add(Duration(days: 1)))) {
            results.add(value);
          }
        }
      });
      setState(() {
        searchResults = results;
      });
    });
  }
}


*/



/*
class ListTarih extends StatefulWidget {
  const ListTarih({Key key}) : super(key: key);

  @override
  _ListTarihState createState() => _ListTarihState();
}

class _ListTarihState extends State<ListTarih> {
  List<dynamic> searchResults = [];
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sorgu'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _startDateController,
              decoration: InputDecoration(
                hintText: 'Başlangıç Tarihi (örn: 2002-02-28)',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(16.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _endDateController,
              decoration: InputDecoration(
                hintText: 'Bitiş Tarihi (örn: 2002-04-20)',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(16.0),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _searchFirebase();
            },
            child: Text('Ara'),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index]['date']),
                  subtitle: Text(
                      'Saat: ${searchResults[index]['time']}, Sıcaklık: ${searchResults[index]['value']}°C'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  void _searchFirebase() {
    String startDate = _startDateController.text;
    String endDate = _endDateController.text;

    _databaseReference.child('test/json/history2').once().then((DataSnapshot snapshot) {
      List<dynamic> results = [];
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        if (value['date'] != null && value['date'] != '') {
          DateTime date = DateTime.parse(value['date']);
          DateTime start = DateTime.parse(startDate);
          DateTime end = DateTime.parse(endDate);
          if (date.isAfter(start.subtract(Duration(days: 1))) && date.isBefore(end.add(Duration(days: 1)))) {
            results.add(value);
          }
        }
      });
      setState(() {
        searchResults = results;
      });
    });
  }
}


*/



/*
class ListTarih extends StatefulWidget {
  const ListTarih({Key key}) : super(key: key);

  @override
  _ListTarihState createState() => _ListTarihState();
}

class _ListTarihState extends State<ListTarih> {

  List<dynamic> searchResults = [];

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text('Date Range'),
  ),
  body: Column(
  children: [
  TextField(
  controller: _startDateController,
  decoration: InputDecoration(
  hintText: 'Start Date (YYYY-MM-DD)',
  ),
  ),
  TextField(
  controller: _endDateController,
  decoration: InputDecoration(
  hintText: 'End Date (YYYY-MM-DD)',
  ),
  ),
  ElevatedButton(
  onPressed: () {
  _searchFirebase();
  },
  child: Text('Search'),
  ),
  Expanded(
  child: ListView.builder(
  itemCount: searchResults.length,
  itemBuilder: (context, index) {
  return ListTile(
  title: Text(searchResults[index]['date']),
  subtitle: Text('Time: ${searchResults[index]['time']}, Value: ${searchResults[index]['value']}'),
  );
  },
  ),
  ),
  ],
  ),
  );
  }

  void _searchFirebase() {
  String startDate = _startDateController.text;
  String endDate = _endDateController.text;

  _databaseReference.child('test/json/history2').once().then((DataSnapshot snapshot) {
  List<dynamic> results = [];
  Map<dynamic, dynamic> values = snapshot.value;
  values.forEach((key, value) {
    if (value['date'] != null && value['date'] != '') {
      DateTime date = DateTime.parse(value['date']);
      DateTime start = DateTime.parse(startDate);
      DateTime end = DateTime.parse(endDate);
      if (date.isAfter(start.subtract(Duration(days: 1))) && date.isBefore(end.add(Duration(days: 1)))) {
        results.add(value);
      }
    }

  });
  setState(() {
  searchResults = results;
  });
  });
  }
  }

  */

/*
class ListTarih extends StatefulWidget {
  const ListTarih({Key key}) : super(key: key);

  @override
  _ListTarihState createState() => _ListTarihState();
}

class _ListTarihState extends State<ListTarih> {

  DateTime _baslangicTarihi;
  DateTime _bitisTarihi;
  List<Map<String, dynamic>> _sicaklikData;
  final _databaseRef = FirebaseDatabase.instance.reference().child('test/json/hh/hh2');

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text('Sıcaklık Verileri'),
  ),
  body: Center(
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
  Text(_baslangicTarihi != null && _bitisTarihi != null
  ? 'Seçilen tarih aralığı: ${DateFormat('dd.MM.yyyy').format(_baslangicTarihi)} - ${DateFormat('dd.MM.yyyy').format(_bitisTarihi)}'
      : 'Tarih aralığı seçin'),
  SizedBox(height: 20),
  ElevatedButton(
  onPressed: () async {
  final DateTime picked = await showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2015, 8),
  lastDate: DateTime.now());
  if (picked != null &&
  picked != _baslangicTarihi &&
  (_bitisTarihi == null || picked.isBefore(_bitisTarihi))) {
  setState(() {
  _baslangicTarihi = picked;
  });
  if (_bitisTarihi != null) {
  await _getSicaklikData();
  }
  }
  },
  child: Text('Başlangıç Tarihi Seç'),
  ),
  SizedBox(height: 20),
  ElevatedButton(
  onPressed: () async {
  final DateTime picked = await showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2015, 8),
  lastDate: DateTime.now());
  if (picked != null &&
  picked != _bitisTarihi &&
  (_baslangicTarihi == null || picked.isAfter(_baslangicTarihi))) {
  setState(() {
  _bitisTarihi = picked;
  });
  if (_baslangicTarihi != null) {
  await _getSicaklikData();
  }
  }
  },
  child: Text('Bitiş Tarihi Seç'),
  ),
  SizedBox(height: 20),
  _sicaklikData != null
  ? Expanded(
  child: ListView.builder(
  itemCount: _sicaklikData.length,
  itemBuilder: (context, index) {
  final data = _sicaklikData[index];
  return ListTile(
  title: Text(
  'Tarih: ${DateFormat('dd.MM.yyyy').format(DateTime.fromMillisecondsSinceEpoch(data['tarih']))}'),
  subtitle: Text('Sıcaklık: ${data['sicaklik']}°C'),
  );
  },
  ),
  )
      : Text('Veri yok'),
  ],
  ),
  ),
  );
  }

  Future<void> _getSicaklikData() async {
  setState(() {
  _sicaklikData = null;
  });

  final start = DateFormat('yyyy-MM-dd').format(_baslangicTarihi);
  final end = DateFormat('yyyy-MM-dd').format(_bitisTarihi);
  final snapshot = await _databaseRef.orderByChild('tarih').startAt(start).endAt(end).once();

  if (snapshot.value != null) {
  final Map<dynamic, dynamic> data = snapshot.value;
  final List<Map<String, dynamic>> list = [];
  data.forEach((key, value) {
  final map = Map<String, dynamic>.from(value);
  map['tarih'] = int.parse(key);
  list.add(map);
  });
  setState(() {
  _sicaklikData = list;
  });
  }
  }
  }
*/