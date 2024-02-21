




/*   eğer açarsam hh ı aktif ederim

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FirebaseService {
  final databaseReference = FirebaseDatabase.instance.reference();

  double lastSavedDouble = 0;

  void saveDoubleToHistory() async {
    databaseReference.child('test/json').child('double').onValue.listen((event) async {
      final doubleValue = event.snapshot.value;

      if (lastSavedDouble != doubleValue) {
        lastSavedDouble = doubleValue;

        final now = DateTime.now();
        final date = DateFormat('yyyy-MM-dd').format(now);
        final time = DateFormat('HH:mm:ss').format(now);

        final historyRef = databaseReference.child('test/json/hh');
        final indexRef = await historyRef.once().then((snapshot) => snapshot.value == null ? 0 : snapshot.value.length);

        // yeni bir değişken oluşturun ve en son kaydedilen değeri kaydedin
        final lastSavedValue = await databaseReference.child('test/json/hh/$indexRef/value').once().then((snapshot) => snapshot.value);

        // son kaydedilen değer, şimdiki değer ile aynı ise kaydetmeyin
        if (lastSavedValue != doubleValue) {
          historyRef.child(indexRef.toString()).set({
            'value': doubleValue,
            'date': date,
            'time': time,
          });
        }
      }

    });
  }
}  */