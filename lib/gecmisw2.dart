import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';


import 'package:charts_flutter/flutter.dart' as charts;

class VeriGecis extends StatefulWidget {
  @override
  _VeriGecisState createState() => _VeriGecisState();
}

class _VeriGecisState extends State<VeriGecis> {
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Veri Grafiği"),
      ),
      body: StreamBuilder(
        stream: databaseReference.child('test/json/history2').onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> values = snapshot.data.snapshot.value;
            List<double> yveriler = [];
            List<DateTime> xveriler = [];
            values.forEach((key, value) {
              Map<dynamic, dynamic> nestedValues = value;
              String dateStr = nestedValues["date"] + " " + nestedValues["time"];
              DateTime date = DateTime.parse(dateStr);
              double val = double.parse(nestedValues["value"].toString());
              xveriler.add(date);
              yveriler.add(val);
            });

            List<charts.Series<Veri, DateTime>> seriesList = [
              charts.Series<Veri, DateTime>(
                id: 'Değerler',
                colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                domainFn: (Veri veri, _) => veri.tarihSaat,
                measureFn: (Veri veri, _) => veri.deger,
                data: List.generate(
                  xveriler.length,
                      (index) => Veri(xveriler[index], yveriler[index]),
                ),
              ),
            ];

            return Container(
              child: Center(
                child: charts.TimeSeriesChart(
                  seriesList,
                  animate: true,
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
                  ),
                ),
              ),
            );
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

class Veri {
  final DateTime tarihSaat;
  final double deger;

  Veri(this.tarihSaat, this.deger);
}


/*
class VeriGecis extends StatefulWidget {
  @override
  _VeriGecisState createState() => _VeriGecisState();
}

class _VeriGecisState extends State<VeriGecis> {
  final databaseReference = FirebaseDatabase.instance.reference();

  List<double> yveriler = [];
  List<DateTime> xveriler = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    databaseReference.child('test/json/history2').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        Map<dynamic, dynamic> nestedValues = value;
        String dateStr = nestedValues["date"] + " " + nestedValues["time"];
        DateTime date = DateTime.parse(dateStr);
        double val = double.parse(nestedValues["value"].toString());
        setState(() {
          xveriler.add(date);
          yveriler.add(val);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Veri, DateTime>> seriesList = [
      charts.Series<Veri, DateTime>(
        id: 'Değerler',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Veri veri, _) => veri.tarihSaat,
        measureFn: (Veri veri, _) => veri.deger,
        data: List.generate(
          xveriler.length,
              (index) => Veri(xveriler[index], yveriler[index]),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Veri Grafiği"),
      ),
      body: Container(
        child: Center(
          child: charts.TimeSeriesChart(
            seriesList,
            animate: true,
            dateTimeFactory: const charts.LocalDateTimeFactory(),
            primaryMeasureAxis: charts.NumericAxisSpec(
              tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
            ),
          ),
        ),
      ),
    );
  }
}

class Veri {
  final DateTime tarihSaat;
  final double deger;

  Veri(this.tarihSaat, this.deger);
}
*/

/*
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class VeriGecis extends StatefulWidget {
  @override
  _VeriGecisState createState() => _VeriGecisState();
}
class _VeriGecisState extends State<VeriGecis> {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // "test>json>gecmis" referansını oluşturma
        DatabaseReference gecmisRef = FirebaseDatabase.instance.reference().child("test").child("json").child("gecmis");

        // "test>json>digertablogec>songecmis" referansını oluşturma
        DatabaseReference sonGecmisRef = FirebaseDatabase.instance.reference().child("test").child("json").child("digertablogec").child("songecmis");

        // "gecmis" tablosundan verileri alıp "songecmis" tablosuna kaydetme
        gecmisRef.once().then((DataSnapshot snapshot) {

          Map<dynamic, dynamic> gecmisValues = snapshot.value as Map<dynamic, dynamic>;

          gecmisValues.forEach((key, value) {
            String tarih = DateTime.now().toString();
            String saat = tarih.substring(11, 19);
            String deger = value["deger"];
            String yaz = value["yaz"];

            sonGecmisRef.child(key).set({
              "saat": saat,
              "deger": deger,
              "yaz": yaz
            });
          });
        });

      },
      child: Text("Veri Gecisi Yap"),
    );
  }
}
*/