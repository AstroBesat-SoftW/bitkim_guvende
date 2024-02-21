import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';


import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class VeriTehlike extends StatefulWidget {
  @override
  _VeriTehlikeState createState() => _VeriTehlikeState();
}

class _VeriTehlikeState extends State<VeriTehlike> {
  double _currentSliderValue = 0;
  final databaseReference = FirebaseDatabase.instance.reference();

  Color _getColor() {
    switch (_currentSliderValue.round()) {
      case 0:
        return Colors.black;
      case 1:
        return Colors.white;
      case 2:
        return Colors.red[400];
      case 3:
        return Colors.blue[400];
      case 4:
        return Colors.green[400];
      case 5:
        return Colors.orange[400];
      case 6:
        return Colors.purple[400];
      case 7:
        return Colors.green[400];
      default:
        return Colors.white;
    }
  }

  String _getLabel() {
    switch (_currentSliderValue.round()) {
      case 0:
        return 'Kapalı';
      case 1:
        return 'Beyaz';
      case 2:
        return 'Kırmızı';
      case 3:
        return 'Mavi';
      case 4:
        return 'Yeşil';
      case 5:
        return 'Turuncu';
      case 6:
        return 'Mor';
      case 7:
        return 'Yeşil';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Renkli Kaydırıcı',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
        padding: EdgeInsets.all(20),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Container(
    width: double.infinity,
    height: 200,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: _getColor(),
    boxShadow: [
    BoxShadow(
    color: _getColor().withOpacity(0.5),
    spreadRadius: 3,
    blurRadius: 10,
    offset: Offset(0, 5),
    ),
    ],
    ),
    child: Center(
    child: Text(
    _getLabel(),
    style: TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: _getColor().computeLuminance() > 0.5
    ? Colors.black
        : Colors.white,
    ),
    ),
    ),
    ),
    SizedBox(height: 40),
    SliderTheme(
    data: SliderTheme .of(context)
        .copyWith(
      activeTrackColor: _getColor(),
      inactiveTrackColor: Colors.grey[300],
      thumbColor: _getColor(),
      overlayColor: _getColor().withOpacity(0.3),
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 30),
    ),
      child: Slider(
        value: _currentSliderValue,
        min: 0,
        max: 7,
        onChanged: (double value) {
          setState(() {
            _currentSliderValue = value;
          });
          databaseReference.child('test/ac').set(value.toInt());
        },
      ),
    ),
    ],
    ),
        ),
    );
  }
}



/*
import 'package:charts_flutter/flutter.dart' as charts;

class VeriTehlike extends StatefulWidget {
  @override
  _VeriTehlikeState createState() => _VeriTehlikeState();
}

class _VeriTehlikeState extends State<VeriTehlike> {
  double _currentSliderValue = 0;
  final databaseReference = FirebaseDatabase.instance.reference();

  Color _getColor() {
    switch (_currentSliderValue.round()) {
      case 0:
        return Colors.black;
      case 1:
        return Colors.white;
      case 2:
        return Colors.red;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.green;
      case 5:
        return Colors.orange;
      case 6:
        return Colors.purple;
      case 7:
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  String _getLabel() {
    switch (_currentSliderValue.round()) {
      case 0:
        return 'Kapalı';
      case 1:
        return 'Beyaz';
      case 2:
        return 'Kırmızı';
      case 3:
        return 'Mavi';
      case 4:
        return 'Yeşil';
      case 5:
        return 'Turuncu';
      case 6:
        return 'Mor';
      case 7:
        return 'Yeşil';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Renkli Kaydırıcı'),
      ),
      body: Container(
        color: _getColor(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Renkli Kaydırıcı',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 50),
            Slider(
              value: _currentSliderValue,
              min: 0,
              max: 6,
              divisions: 6,
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                  databaseReference
                      .child('test/ac')
                      .set(_currentSliderValue.round());
                });
              },
            ),
            SizedBox(height: 50),
            Text(
              'Firebase\'e Gönderilen Değer: ${_currentSliderValue.round()}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Renk: ${_getLabel()}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


*/


/*
class VeriTehlike extends StatefulWidget {
  @override
  _VeriTehlikeState createState() => _VeriTehlikeState();
}

class _VeriTehlikeState extends State<VeriTehlike> {

  double _currentSliderValue = 0;
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text('Renkli Kaydırıcı'),
  ),
  body: Container(
  color: Color.fromRGBO(_currentSliderValue.round(), 0, 0, 1),
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  Text(
  'Renkli Kaydırıcı',
  style: TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  ),
  ),
  SizedBox(height: 50),
  Slider(
  value: _currentSliderValue,
  min: 0,
  max: 255,
  onChanged: (double value) {
  setState(() {
  _currentSliderValue = value;
  databaseReference.child('test/ac').set(_currentSliderValue.round());
  });
  },
  ),
  SizedBox(height: 50),
  Text(
  'Firebase\'e Gönderilen Değer: ${_currentSliderValue.round()}',
  style: TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  ),
  ),
  ],
  ),
  ),
  );
  }
  }
*/