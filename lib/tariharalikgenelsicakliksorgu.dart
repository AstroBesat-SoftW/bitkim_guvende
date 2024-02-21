import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
class sicakliktamsorgu extends StatefulWidget {
  @override
  _sicakliktamsorguState createState() => _sicakliktamsorguState();
}

class _sicakliktamsorguState extends State<sicakliktamsorgu> {
  final DatabaseReference database =
  FirebaseDatabase.instance.reference().child("test/json/history3n");

  DateTime startDate;
  DateTime endDate;

  List<Map<String, dynamic>> dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kapsamlı Sıcaklık Sorgu"),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black54, // renk
                        onPrimary: Colors.white, // yazı rengi
                        elevation: 5, // gölge efekti
                      ),
                      child: Text(startDate == null
                          ? "Başlangıç Tarihi Seçin"
                          : "${startDate.day.toString().padLeft(2, '0')}/${startDate.month.toString().padLeft(2, '0')}/${startDate.year}"),
                      onPressed: () {
                        _selectDate(context, true);
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black54, // renk
                        onPrimary: Colors.white, // yazı rengi
                        elevation: 5, // gölge efekti
                      ),
                      child: Text(endDate == null
                          ? "Bitiş Tarihi Seçin"
                          : "${endDate.day.toString().padLeft(2, '0')}/${endDate.month.toString().padLeft(2, '0')}/${endDate.year}"),
                      onPressed: () {
                        _selectDate(context, false);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange, // renk
                    onPrimary: Colors.white, // yazı rengi
                    elevation: 5, // gölge efekti
                  ),
                  child: Text("Verileri Getir"),
                  onPressed: () {
                    if (startDate == null || endDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Lütfen tarih aralığı seçin"),
                      ));
                      return;
                    }
                    _getData();
                  },
                ),

              ],
            ),
          ),




          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = dataList[index];
                String id = data.keys.first;
                dynamic value = data.values.first;
                DateTime date = DateTime.parse(id.split(":")[0]);
                String time = id.split(":")[1];
                String saat = id.split(" ")[1].split(":")[0].padLeft(2, '0');

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      "Tarih: ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}  Saat: $saat:$time",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: value is double
                        ? Text(
                      value.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    )
                        : Text(
                      "Sıcaklık: $value °C",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate ?? DateTime.now() : endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _getData() {
    database
        .orderByKey()
        .startAt("${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}\uf8ff")
        .endAt("${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}\uf8ff")
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        dataList.clear();
        if (snapshot.value != null) {
          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach((key, value) {
            dataList.add({key: value});
          });
        }
      });
    });
  }
}
