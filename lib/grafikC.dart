import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';

class GrafikC extends StatefulWidget {
  @override
  _GrafikCState createState() => _GrafikCState();
}

class _GrafikCState extends State<GrafikC> {
  final databaseReference = FirebaseDatabase.instance.reference();

  List<double> xvericek = []; // Değişkenin tipi double olarak değiştirildi.
  List<String> xzamanak = [];

  Future<void> fetchData() async {
    databaseReference.child('test/json/gecmis').onChildAdded.listen((Event event) {
      double value = event.snapshot.value; // Verinin tipi double olarak değiştirildi.
      var now = new DateTime.now();
      xvericek.add(value);
      xzamanak.add(now.toString());
      setState(() {});
    });

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      var now = new DateTime.now();
      xzamanak.add(now.toString());
      xvericek.add(xvericek[xvericek.length - 1]); // add a dummy value for demo purposes
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<TimeSeriesSales, DateTime>> seriesList = [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: List.generate(
          xvericek.length,
              (index) => TimeSeriesSales(
            DateTime.parse(xzamanak[index]),
            xvericek[index],
          ),
        ),
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: charts.TimeSeriesChart(
          seriesList,
          animate: true,
          animationDuration: Duration(milliseconds: 500),
          dateTimeFactory: const charts.LocalDateTimeFactory(),
          layoutConfig: charts.LayoutConfig(
            leftMarginSpec: charts.MarginSpec.fixedPixel(50),
            topMarginSpec: charts.MarginSpec.fixedPixel(10),
            rightMarginSpec: charts.MarginSpec.fixedPixel(10),
            bottomMarginSpec: charts.MarginSpec.fixedPixel(30),
          ),
          domainAxis: charts.DateTimeAxisSpec(
            viewport: charts.DateTimeExtents(
              start: DateTime.now().subtract(Duration(minutes: 5)), // son 4 dk nın verisi kalsın
              end: DateTime.now(),
            ),
          ),
        ),
      ),
    );
  }
}

class TimeSeriesSales {
  final DateTime time;
  final double sales; // Değişkenin tipi double olarak değiştirildi.

  TimeSeriesSales(this.time, this.sales);
}