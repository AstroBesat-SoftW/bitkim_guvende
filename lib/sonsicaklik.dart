import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_realtimedb/dht.dart';
import 'package:firebase_realtimedb/sicakliktehlike.dart';
import 'package:firebase_realtimedb/tariharalikdeneme.dart';
import 'package:firebase_realtimedb/tariharalikgenelsicakliksorgu.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math';

import './singlepage_app.dart';


// altaki ile ilgili hafızada tutmak için
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'gecmisw2.dart';
SharedPreferences prefs;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  List<double> dataList = [];


  double calculateAverage(List<double> data) {
    double sum = 0.0;
    double fark = 1.0;
    for (double num in data) {            // ortlama için
      sum += num;
    }
    return sum / data.length;
    return fark;
  }



  @override
  void initState() {
    super.initState();

    // Create the Firebase Realtime Database reference.
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child("test") // led
        .child("json")
        .child("gecmis");

    // Read the data once.
    databaseRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        // Extract the data and add it to the dataList.
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          dataList.add(double.parse(value.toString()));
        });
      } else {
        // Notify the user if there is no data.
        print("Veri Yok!");
      }
      setState(() {}); // SetState() is used for the refresh.
    });

    // Add a listener to listen for the data.
    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and add it to the dataList.
        double value = double.parse(event.snapshot.value.toString());
        dataList.add(value);
        setState(() {}); // SetState() is used for the refresh.
      }
    });

    // Add a listener to listen for the data being deleted.
// Add a listener to listen for the data being deleted.




  }

  @override
  Widget build(BuildContext context) {
    double average = calculateAverage(dataList); // ortalma için
    double fark = dataList.last - dataList.first;
    double sonveri = dataList.last;
   // String _s = "b";
    //if (dataList.last < 25) {
     // _s = "Nem miktarı az, sulamak isteyebilirsin.";

    //}
    //else if(dataList.last > 25){
     // _s = "Nemi çok çıkta su miktarını azalt.";
   // }

    final databaseRef = FirebaseDatabase.instance.reference();
    final testRef = databaseRef.child("test");
    final jsonRef = testRef.child("json");
    final gecmisRef = jsonRef.child("gecmis");
    final history2Ref = jsonRef.child("history2");

    return Scaffold(
      appBar: AppBar(
        title: Text(
        //  "$_s", // yani bitkiye derecesine göre yorum yapcak
          'Sıcaklık Geçmişi',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.blue[600], // sky blue
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => sicakliktamsorgu(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.date_range_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListTarih(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.auto_graph_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VeriGecis(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.save_as_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => History2Screen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete_forever_rounded,
              color: Colors.white,
            ),
            onPressed: () async {

              // Remove the data from Firebase.
              await gecmisRef.remove();

              // Remove the data from the dataList.
              dataList.clear();
              await gecmisRef.push().set(sonveri); // buda hiç veri olmadığından hata vermesin diye nasnahsha diye son veri atıyor
              // Show a snackbar to notify the user.
              final snackBar = SnackBar(
                content: Text(
                  "Veriler başarıyla silindi!",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.green[700], // green as plants
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },

          ),
        ],
      ),
      body: dataList.isEmpty
          ? Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
            Colors.green[700], // green as plants
          ),
        ),
      )
          : ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 3.0,
            margin: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: ListTile(
              leading: Icon(
                Icons.thermostat_outlined,
                color: Colors.green[700], // green as plants
              ),
              title: Text(
                '${dataList[index]} °C',
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700], // green as plants
                ),
              ),

              trailing: IconButton(
                icon: Icon(
                  Icons.save,
                  color: Colors.red[700], // red as life
                ),
                onPressed: () async {
                  // Remove the data from the dataList.
                  final value = dataList.removeAt(index);

                  // Get the current date and time.
                  final now = DateTime.now();
                  final dateFormatted = DateFormat('yyyy-MM-dd').format(now); // format the date
                  final timeFormatted = DateFormat('HH:mm:ss').format(now); // format the time

                  // Add the data with the date and time to the history2 node.
                  await history2Ref.push().set({
                    'value': value,
                    'date': dateFormatted,
                    'time': timeFormatted,
                  });

                  // Show a snackbar to notify the user.
                  final snackBar = SnackBar(
                    content: Text(
                      "Kaydettin!", // saved!
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.red[700], // red as life
                    duration: const Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  setState(() {}); // SetState() is used for the refresh.
                },
              ),

            ),
          );

        },
      ),

      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            TextButton(
              child: Text(
                'Sıcaklık ${dataList.last.toStringAsFixed(2)}°C, ortalama değer ${average.toStringAsFixed(2)}°C, Fark ${fark.toStringAsFixed(2)}°C',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),

          ],
        ),
      ),


    );

  }
}

class History2Screen extends StatefulWidget {
  @override
  _History2ScreenState createState() => _History2ScreenState();
}

class _History2ScreenState extends State<History2Screen> {
  List<Map<String, dynamic>> dataList = [];


  @override
  void initState() {
    super.initState();

    // Retrieve the data from the history2 node.
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child("test")
        .child("json")
        .child("history2");

    // Add a listener to listen for the data.
    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and add it to the dataList.
        Map<String, dynamic> data = Map.from(event.snapshot.value);
        dataList.add(data);
        setState(() {}); // SetState() is used for the refresh.
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kayıt Edilenler",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.amber),
      ),
      body: dataList.length == 0
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.green[800],
          ),
        ),
      )
          : ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.white,
            elevation: 2,
            child: ListTile(
              leading: Icon(
                Icons.thermostat_outlined,
                color: Colors.green[800],
              ),
              title: Text(
                '${dataList[index]["value"]} °C',
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 20.0,
                ),
              ),
              subtitle: Text(
                '${dataList[index]["date"]} ${dataList[index]["time"]}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.0,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () async {
                  // Call a function to delete the selected data from the database
                  await deleteData(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> deleteData(int index) async {
    // Create a copy of the dataList
    List<Map<String, dynamic>> newDataList = List.from(dataList);

    // Get the current date and time
    DateTime now = DateTime.now();
    String date = DateFormat('yyyy-MM-dd').format(now);
    String time = DateFormat('kk:mm:ss').format(now);

    // Create a map containing the value, date, and time
    Map<String, dynamic> data = {
      'value': dataList[index]["value"],
      'date': dataList[index]["date"],
      'time': dataList[index]["time"],
    };

    // Remove the selected data from the copy of the dataList
    newDataList.removeAt(index);

    // Get the database reference
    final databaseReference = FirebaseDatabase.instance.reference();

    // Update the database with the new dataList
    await databaseReference
        .child("test")
        .child("json")
        .child("history2")
        .set(newDataList);

    // Show a SnackBar message to confirm deletion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tebrikler Başarılı Şekilde Sildiniz!"),
        duration: Duration(seconds: 2),
      ),
    );

    // SetState() is used to refresh the screen after deleting the data.
    setState(() {
      // Update the dataList with the copy
      dataList = newDataList;
    });
  }
}

/*
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  List<double> dataList = [];


  double calculateAverage(List<double> data) {
    double sum = 0.0;
    double fark = 1.0;
    for (double num in data) {            // ortlama için
      sum += num;
    }
    return sum / data.length;
    return fark;
  }



  @override
  void initState() {
    super.initState();

    // Create the Firebase Realtime Database reference.
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child("test") // led
        .child("json")
        .child("gecmis");

    // Read the data once.
    databaseRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        // Extract the data and add it to the dataList.
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          dataList.add(double.parse(value.toString()));
        });
      } else {
        // Notify the user if there is no data.
        print("No data!");
      }
      setState(() {}); // SetState() is used for the refresh.
    });

    // Add a listener to listen for the data.
    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and add it to the dataList.
        double value = double.parse(event.snapshot.value.toString());
        dataList.add(value);
        setState(() {}); // SetState() is used for the refresh.
      }
    });

    // Add a listener to listen for the data being deleted.
// Add a listener to listen for the data being deleted.




  }

  @override
  Widget build(BuildContext context) {
    double average = calculateAverage(dataList); // ortalma için
    double fark = dataList.last - dataList.first;
    final databaseRef = FirebaseDatabase.instance.reference();
    final testRef = databaseRef.child("test");
    final jsonRef = testRef.child("json");
    final gecmisRef = jsonRef.child("gecmis");
    final history2Ref = jsonRef.child("history2");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sıcaklık ve Nem Geçmişi",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[600], // sky blue
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.history,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => History2Screen(),
                ),
              );
            },
          ),
        ],
      ),
      body: dataList.isEmpty
          ? Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
            Colors.green[700], // green as plants
          ),
        ),
      )
          : ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 3.0,
            margin: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: ListTile(
              leading: Icon(
                Icons.thermostat_outlined,
                color: Colors.green[700], // green as plants
              ),
              title: Text(
                '${dataList[index]} °C',
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700], // green as plants
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.save,
                  color: Colors.red[700], // red as life
                ),
                onPressed: () async {
                  // Remove the data from the dataList.
                  final value = dataList.removeAt(index);
                  await history2Ref.push().set(value); // kaydettin!
                  // Remove the data from Firebase Realtime Database.

                  // Add the deleted data to the history2 node.

                  // Show a snackbar to notify the user.
                  final snackBar = SnackBar(
                    content: Text(
                      "Kaydettin!", // saved!
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.red[700], // red as life
                    duration: const Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  setState(() {}); // SetState() is used for the refresh.
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              child: Text(
                'CANLI: Sıcaklık ${dataList.last}°C',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              child: Text(
                'Ortalaması $average°C',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              child: Text(
                'Fark $fark°C',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),

    );

  }
}


class History2Screen extends StatefulWidget {
  @override
  _History2ScreenState createState() => _History2ScreenState();
}

class _History2ScreenState extends State<History2Screen> {
  List<double> dataList = [];

  @override
  void initState() {
    super.initState();

    // Retrieve the data from the history2 node.
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child("test")
        .child("json")
        .child("history2");

    // Add a listener to listen for the data.
    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and add it to the dataList.
        double value = double.parse(event.snapshot.value.toString());
        dataList.add(value);
        setState(() {}); // SetState() is used for the refresh.
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History 2",
          style: TextStyle(
            color: Colors.green[800],
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.yellow[300],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green[800]),
      ),
      body: dataList.length == 0
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.green[800],
          ),
        ),
      )
          : ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.yellow[100],
            elevation: 2,
            child: ListTile(
              leading: Icon(
                Icons.thermostat_outlined,
                color: Colors.green[800],
              ),
              title: Text(
                '${dataList[index]} °C',
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 20.0,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () async {
                  // Call a function to delete the selected data from the database
                  await deleteData(index);
                },
              ),
            )
          );
        },
      ),
    );
  }

  Future<void> deleteData(int index) async {
    // Get the database reference
    final databaseReference = FirebaseDatabase.instance.reference();

    // Remove the selected data from the list
    dataList.removeAt(index);

    // Update the database with the new list of data
    await databaseReference.child('test').child('json').child('history2').set(dataList);
  }}




*/
/*

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  List<double> dataList = [];


  double calculateAverage(List<double> data) {
    double sum = 0.0;
    double fark = 1.0;
    for (double num in data) {            // ortlama için
      sum += num;
    }
    return sum / data.length;
    return fark;
  }



  @override
  void initState() {
    super.initState();

    // Create the Firebase Realtime Database reference.
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child("test") // led
        .child("json")
        .child("gecmis");

    // Read the data once.
    databaseRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        // Extract the data and add it to the dataList.
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          dataList.add(double.parse(value.toString()));
        });
      } else {
        // Notify the user if there is no data.
        print("No data!");
      }
      setState(() {}); // SetState() is used for the refresh.
    });

    // Add a listener to listen for the data.
    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and add it to the dataList.
        double value = double.parse(event.snapshot.value.toString());
        dataList.add(value);
        setState(() {}); // SetState() is used for the refresh.
      }
    });

    // Add a listener to listen for the data being deleted.
// Add a listener to listen for the data being deleted.




  }

  @override
  Widget build(BuildContext context) {
    double average = calculateAverage(dataList); // ortalma için
    double fark = dataList.last - dataList.first;
    final databaseRef = FirebaseDatabase.instance.reference();
    final testRef = databaseRef.child("test");
    final jsonRef = testRef.child("json");
    final gecmisRef = jsonRef.child("gecmis");
    final history2Ref = jsonRef.child("history2");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sıcaklık ve Nem Geçmişi",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green[700],
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.history,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => History2Screen(),
                ),
              );
            },
          ),
        ],
      ),
      body: dataList.isEmpty
          ? Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
            Colors.green[700],
          ),
        ),
      )
          : ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {

          return Card(
            elevation: 3.0,
            margin: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: ListTile(
              leading: Icon(
                Icons.thermostat_outlined,
                color: Colors.green[700],
              ),
              title: Text(
                '${dataList[index]} °C',
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.save,
                  color: Colors.red[700],
                ),
                onPressed: () async {
                  // Remove the data from the dataList.
                  final value = dataList.removeAt(index);
                  await history2Ref.push().set(value);  // kaldrığdıını kaydet mantığı
                  // Remove the data from Firebase Realtime Database.


                  // Add the deleted data to the history2 node.


                  // Show a snackbar to notify the user.
                  final snackBar = SnackBar(
                    content: Text(
                      "Kaydettin!",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.red[700],
                    duration: const Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  setState(() {}); // SetState() is used for the refresh.
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(

              child: Text(
                'CANLI: Sıcaklık ${dataList.last}°C',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(

              child: Text(
                'Ortalaması $average°C',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(

              child: Text(
                'Fark $fark°C',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }
}


class History2Screen extends StatefulWidget {
  @override
  _History2ScreenState createState() => _History2ScreenState();
}

class _History2ScreenState extends State<History2Screen> {
  List<double> dataList = [];

  @override
  void initState() {
    super.initState();

    // Retrieve the data from the history2 node.
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child("test")
        .child("json")
        .child("history2");

    // Add a listener to listen for the data.
    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and add it to the dataList.
        double value = double.parse(event.snapshot.value.toString());
        dataList.add(value);
        setState(() {}); // SetState() is used for the refresh.
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History 2",
          style: TextStyle(
            color: Colors.green[800],
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.yellow[300],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green[800]),
      ),
      body: dataList.length == 0
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.green[800],
          ),
        ),
      )
          : ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.yellow[100],
            elevation: 2,
            child: ListTile(
              leading: Icon(
                Icons.thermostat_outlined,
                color: Colors.green[800],
              ),
              title: Text(
                '${dataList[index]} °C',
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 20.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
*/
/*
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  List<double> dataList = [];
  double _c = 0;

  void _ortlamaal(){

   _c = dataList.reduce((a, b) => a + b) / dataList.length;

  }

  @override
  void initState() {
    super.initState();

    // Create the Firebase Realtime Database reference.
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child("test") // led
        .child("json")
        .child("gecmis");

    // Read the data once.
    databaseRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        // Extract the data and add it to the dataList.
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          dataList.add(double.parse(value.toString()));
        });
      } else {
        // Notify the user if there is no data.
        print("No data!");
      }
      setState(() {}); // SetState() is used for the refresh.
    });

    // Add a listener to listen for the data.
    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and add it to the dataList.
        double value = double.parse(event.snapshot.value.toString());
        dataList.add(value);
        setState(() {}); // SetState() is used for the refresh.
      }
    });

    // Add a listener to listen for the data being deleted.
    databaseRef.onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and move it to the history node.
        double value = double.parse(event.snapshot.value.toString());
        final historyRef = FirebaseDatabase.instance
            .reference()
            .child("test") // led
            .child("json")
            .child("history")
            .push();
        historyRef.set(value);

        // Also add the data to history2 node.
        final history2Ref = FirebaseDatabase.instance
            .reference()
            .child("test") // led
            .child("json")
            .child("history2")
            .push();
        history2Ref.set(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final databaseRef = FirebaseDatabase.instance.reference();
    final testRef = databaseRef.child("test");
    final jsonRef = testRef.child("json");
    final gecmisRef = jsonRef.child("gecmis");
    final history2Ref = jsonRef.child("history2");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sıcaklık ve Nem Geçmişi",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green[700],
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.history,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => History2Screen(),
                ),
              );
            },
          ),
        ],
      ),
      body: dataList.isEmpty
          ? Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
            Colors.green[700],
          ),
        ),
      )
          : ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 3.0,
            margin: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: ListTile(
              leading: Icon(
                Icons.thermostat_outlined,
                color: Colors.green[700],
              ),
              title: Text(
                '${dataList[index]} °C',
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red[700],
                ),
                onPressed: () async {
                  // Remove the data from the dataList.
                  final value = dataList.removeAt(index);

                  // Remove the data from Firebase Realtime Database.
                  await gecmisRef.child(index.toString()).remove();

                  // Add the deleted data to the history2 node.
                  await history2Ref.push().set(value);

                  // Show a snackbar to notify the user.
                  final snackBar = SnackBar(
                    content: Text(
                      "Data deleted!",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.red[700],
                    duration: const Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  setState(() {}); // SetState() is used for the refresh.
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                _ortlamaal();
              },
              child: Text(
                'Average',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Add humidity button functionality
              },
              child: Text(
                '${_c.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Add humidity button functionality
              },
              child: Text(
                'Nem Oranı',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }
}


  class History2Screen extends StatefulWidget {
  @override
  _History2ScreenState createState() => _History2ScreenState();
}

class _History2ScreenState extends State<History2Screen> {
  List<double> dataList = [];

  @override
  void initState() {
    super.initState();

    // Retrieve the data from the history2 node.
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child("test")
        .child("json")
        .child("history2");

    // Add a listener to listen for the data.
    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and add it to the dataList.
        double value = double.parse(event.snapshot.value.toString());
        dataList.add(value);
        setState(() {}); // SetState() is used for the refresh.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History 2",
          style: TextStyle(
            color: Colors.green[800],
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.yellow[300],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green[800]),
      ),
      body: dataList.length == 0
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.green[800],
          ),
        ),
      )
          : ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.yellow[100],
            elevation: 2,
            child: ListTile(
              leading: Icon(
                Icons.thermostat_outlined,
                color: Colors.green[800],
              ),
              title: Text(
                '${dataList[index]} °C',
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 20.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
*/
/*
class TemperaturePage extends StatefulWidget {
  @override
  _TemperaturePageState createState() => _TemperaturePageState();
}


class _TemperaturePageState extends State<TemperaturePage> {
  List<double> dataList = [];
  List<DateTime> timestampList = [];
  double lastData;
  DateTime lastTimestamp;

  @override
  void initState() {
    super.initState();

    // Create the Firebase Realtime Database reference.
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child("test") // led
        .child("json")
        .child("gecmis");

    // Read the data once.
    databaseRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        // Extract the data and add it to the dataList and timestampList.
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          dataList.add(double.parse(value.toString()));
          timestampList.add(DateTime.now());
        });

        // Get the latest data and timestamp.
        lastData = dataList.last;
        lastTimestamp = timestampList.last;
      } else {
        // Notify the user if there is no data.
        print("No data!");
      }
      setState(() {}); // SetState() is used for the refresh.
    });

    // Add a listener to listen for the data.
    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and add it to the dataList and timestampList.
        double value = double.parse(event.snapshot.value.toString());
        dataList.add(value);
        timestampList.add(DateTime.now());

        // Get the latest data and timestamp.
        lastData = dataList.last;
        lastTimestamp = timestampList.last;

        // Update the "tarih" table with the latest data.
        final tarihRef = FirebaseDatabase.instance
            .reference()
            .child("test")
            .child("json")
            .child("tarih");
        tarihRef.push().set(lastData);

        // Update the "tarihveri" table with the latest timestamp.
        final tarihveriRef = FirebaseDatabase.instance
            .reference()
            .child("test")
            .child("json")
            .child("tarihveri");
        final formattedTimestamp =
        DateFormat('dd MMMM y - HH:mm').format(lastTimestamp);
        tarihveriRef.push().set(formattedTimestamp);

        setState(() {}); // SetState() is used for the refresh.
      }
    });

    // Add a listener to listen for the data being deleted.
    databaseRef.onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and move it to the history node.
        double value = double.parse(event.snapshot.value.toString());
        final historyRef = FirebaseDatabase.instance
            .reference()
            .child("test") // led
            .child("json")
            .child("history")
            .push();
        historyRef.set(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Sıcaklık - Geçmiş Veriler"),
      ),
      body: dataList.length == 0
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (BuildContext context, int index) {
            // Get the timestamp of the data.
            final timestamp = timestampList[index];
            final formattedTimestamp =
            DateFormat('dd MMMM y - HH:mm').format(timestamp);
            // Get the temperature data.
            final temperature = dataList[index];

// Create a ListTile to display the data.
            return ListTile(
              leading: Icon(Icons.thermostat),
              title: Text("$temperature °C"),
              subtitle: Text(formattedTimestamp),
            );

          }),

    );
  }
}
*/
/*
class TemperaturePage extends StatefulWidget {
  @override
  _TemperaturePageState createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  List<double> dataList = [];
  List<DateTime> timestampList = [];

  @override
  void initState() {
    super.initState();

    // Create the Firebase Realtime Database reference.
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child("test") // led
        .child("json")
        .child("gecmis");

    // Read the data once.
    databaseRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        // Extract the data and add it to the dataList and timestampList.
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          dataList.add(double.parse(value.toString()));
          timestampList.add(DateTime.now());
        });
      } else {
        // Notify the user if there is no data.
        print("No data!");
      }
      setState(() {}); // SetState() is used for the refresh.
    });

    // Add a listener to listen for the data.
    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and add it to the dataList and timestampList.
        double value = double.parse(event.snapshot.value.toString());
        dataList.add(value);
        timestampList.add(DateTime.now());

        // Update the "tarih" table.
        final tarihRef = FirebaseDatabase.instance
            .reference()
            .child("test")
            .child("json")
            .child("tarih");
        tarihRef.push().set(dataList.last);

        // Update the "tarihveri" table.
        final tarihveriRef = FirebaseDatabase.instance
            .reference()
            .child("test")
            .child("json")
            .child("tarihveri");
        final timestamp = timestampList.last;
        final formattedTimestamp =
        DateFormat('dd MMMM y - HH:mm').format(timestamp);
        tarihveriRef.push().set(formattedTimestamp);

        setState(() {}); // SetState() is used for the refresh.
      }
    });

    // Add a listener to listen for the data being deleted.
    databaseRef.onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and move it to the history node.
        double value = double.parse(event.snapshot.value.toString());
        final historyRef = FirebaseDatabase.instance
            .reference()
            .child("test") // led
            .child("json")
            .child("history")
            .push();
        historyRef.set(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Sıcaklık - Geçmiş Veriler"),
    ),
    body: dataList.length == 0
    ? Center(
    child: CircularProgressIndicator(),
    )
        : ListView.builder(
    itemCount: dataList.length,
    itemBuilder: (BuildContext context, int index) {
    // Get the timestamp of the data.
    final timestamp = timestampList[index];
    final formattedTimestamp =
    DateFormat('dd MMMM y - HH:mm').format(timestamp);
    // Get the temperature data.
    final temperature = dataList[index];

// Create a ListTile to display the data.
      return ListTile(
        leading: Icon(Icons.thermostat),
        title: Text("$temperature °C"),
        subtitle: Text(formattedTimestamp),
      );
    }),
    );
  }
}

*/
/*

class TemperaturePage extends StatefulWidget {
  @override
  _TemperaturePageState createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  List<double> dataList = [];
  DateTime firstPullDate;

  @override
  void initState() {
    super.initState();

    // Create the Firebase Realtime Database reference.
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child("test") // led
        .child("json")
        .child("gecmis");

    // Read the data once.
    databaseRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        // Extract the data and add it to the dataList.
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          dataList.add(double.parse(value.toString()));
        });

        // Set the firstPullDate to the current date if dataList is empty.
        if (dataList.isEmpty) {
          firstPullDate = DateTime.now();
        }
      } else {
        // Notify the user if there is no data.
        print("No data!");
      }
      setState(() {}); // SetState() is used for the refresh.
    });

    // Add a listener to listen for the data.
    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and add it to the dataList.
        double value = double.parse(event.snapshot.value.toString());
        dataList.add(value);
        setState(() {}); // SetState() is used for the refresh.
      }
    });

    // Add a listener to listen for the data being deleted.
    databaseRef.onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and move it to the history node.
        double value = double.parse(event.snapshot.value.toString());
        final historyRef = FirebaseDatabase.instance
            .reference()
            .child("test") // led
            .child("json")
            .child("history")
            .push();
        historyRef.set(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Sıcaklık - Geçmiş Veriler"),
    ),
    body: dataList.length == 0
    ? Center(
    child: CircularProgressIndicator(),
    )
        : ListView.builder(
    itemCount: dataList.length,
    itemBuilder: (BuildContext context, int index) {
    // Get the date and time of the data.
    final timestamp = firstPullDate != null
    ? firstPullDate
        : DateTime.now();
    final formattedTimestamp =
    DateFormat('dd MMMM y - HH:mm').format(timestamp);

    return Card(
    child: ListTile(
    leading: Icon(Icons.thermostat_outlined),
    title: Text(
    '${dataList[index]} °C',
    style: TextStyle(fontSize: 20.0),
    ),
    subtitle: Text(
    formattedTimestamp,
    style: TextStyle(fontSize: 12.0),
    ),
    trailing: IconButton(
    icon: Icon(Icons.delete_outline),
// Remove the data from the dataList.
      onPressed: () {
// Delete the data from the database.
        final databaseRef = FirebaseDatabase.instance
            .reference()
            .child("test") // led
            .child("json")
            .child("gecmis")
            .child(index.toString());
        databaseRef.remove();
      setState(() {
      dataList.removeAt(index);
      });
    },
    ),
    ),
    );
  },
  ),
  );
}
}
*/

/* 222
class TemperaturePage extends StatefulWidget {
  @override
  _TemperaturePageState createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  List<double> dataList = [];

  @override
  void initState() {
    super.initState();

    // Create the Firebase Realtime Database reference.
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child("test") // led
        .child("json")
        .child("gecmis");

    // Read the data once.
    databaseRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        // Extract the data and add it to the dataList.
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          dataList.add(double.parse(value.toString()));
        });
      } else {
        // Notify the user if there is no data.
        print("No data!");
      }
      setState(() {}); // SetState() is used for the refresh.
    });

    // Add a listener to listen for the data.
    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and add it to the dataList.
        double value = double.parse(event.snapshot.value.toString());
        dataList.add(value);
        setState(() {}); // SetState() is used for the refresh.
      }
    });

    // Add a listener to listen for the data being deleted.
    databaseRef.onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and move it to the history node.
        double value = double.parse(event.snapshot.value.toString());
        final historyRef = FirebaseDatabase.instance
            .reference()
            .child("test") // led
            .child("json")
            .child("history")
            .push();
        historyRef.set(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Sıcaklık - Geçmiş Veriler"),
    ),
    body: dataList.length == 0
    ? Center(
    child: CircularProgressIndicator(),
    )
        : ListView.builder(
    itemCount: dataList.length,
    itemBuilder: (BuildContext context, int index) {
    // Get the date and time of the data.
    final timestamp = DateTime.now();
    final formattedTimestamp =
    DateFormat('dd MMMM y - HH:mm').format(timestamp);

    return Card(
    child: ListTile(
    leading: Icon(Icons.thermostat_outlined),
    title: Text(
    '${dataList[index]} °C',
    style: TextStyle(fontSize: 20.0),
    ),
    subtitle: Text(
    formattedTimestamp,
    style: TextStyle(fontSize: 12.0),
    ),
    trailing: IconButton(
    icon: Icon(Icons.delete_outline),
    onPressed: () {
    // Remove the data from the dataList.
    dataList.removeAt(index);

    // Remove the data from Firebase Realtime Database.
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child("test") // led
        .child("json")
        .child("gecmis")
        .child(index.toString());
    databaseRef.remove();

    setState(() {}); // SetState() is used for the refresh.
    },
    ),
    ),
    );
    },
    ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.restore_outlined),
              onPressed: () {
                // Read the data from the history node.
                final historyRef = FirebaseDatabase.instance
                    .reference()
                    .child("test") // led
                    .child("json")
                    .child("history");

                historyRef.once().then((DataSnapshot snapshot) {
                  if (snapshot.value != null) {
                    // Extract the data and add it to the dataList.
                    Map<dynamic, dynamic> values = snapshot.value;
                    values.forEach((key, value) {
                      dataList.add(double.parse(value.toString()));
                    });

                    // Delete the data from the history node.
                    historyRef.remove();

                    setState(() {}); // SetState() is used for the refresh.
                  } else {
                    // Notify the user if there is no data.
                    print("No data in history!");
                  }
                });
              },
            ),
            TextButton(
              onPressed: () {
                // Do something.
              },
              child: Text(
                'Deleted Data',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 -- 2  */
/*
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<double> dataList = [];

  @override
  void initState() {
    super.initState();

    // Create the Firebase Realtime Database reference.
    final databaseRef = FirebaseDatabase.instance
        .reference()
        .child("test") // led
        .child("json")
        .child("gecmis");

    // Read the data once.
    databaseRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        // Extract the data and add it to the dataList.
        Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
      dataList.add(double.parse(value.toString()));
      });
      } else {
      // Notify the user if there is no data.
      print("No data!");
      }
      setState(() {}); // SetState() is used for the refresh.
    });

    // Add a listener to listen for the data.
    databaseRef.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and add it to the dataList.
        double value = double.parse(event.snapshot.value.toString());
        dataList.add(value);
        setState(() {}); // SetState() is used for the refresh.
      }
    });

    // Add a listener to listen for the data being deleted.
    databaseRef.onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        // Extract the data and move it to the history node.
        double value = double.parse(event.snapshot.value.toString());
        final historyRef = FirebaseDatabase.instance
            .reference()
            .child("test") // led
            .child("json")
            .child("history")
            .push();
        historyRef.set(value);
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sıcaklık - Geçmiş Veriler"),
      ),
      body: dataList.length == 0
          ? Center(
              child:
                  CircularProgressIndicator()) // Yüklenirken gösterilecek bir ilerleme çubuğu.
          : ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(         // bu kısmı güncelledim baya B*
            child: ListTile(
              leading: Icon(Icons.thermostat_outlined),
              title: Text(
                '${dataList[index]} °C',
                style: TextStyle(fontSize: 20.0),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  // Remove the data from the dataList.
                  dataList.removeAt(index);

                  // Remove the data from Firebase Realtime Database.
                  final databaseRef = FirebaseDatabase.instance
                      .reference()
                      .child("test") // led
                      .child("json")
                      .child("past")
                      .child(index.toString());
                  databaseRef.remove();

                  setState(() {}); // SetState() is used for the refresh.
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.restore_outlined),
              onPressed: () {
                // Read the data from the history node.
                final historyRef = FirebaseDatabase.instance
                    .reference()
                    .child("test") // led
                    .child("json")
                    .child("history");

                historyRef.once().then((DataSnapshot snapshot) {
                  if (snapshot.value != null) {
                    // Extract the data and add it to the dataList.
                    Map<dynamic, dynamic> values = snapshot.value;
                    values.forEach((key, value) {
                      dataList.add(double.parse(value.toString()));
                    });

                    // Delete the data from the history node.
                    historyRef.remove();

                    setState(() {}); // SetState() is used for the refresh.
                  } else {
                    // Notify the user if there is no data.
                    print("No data in history!");
                  }
                });
              },
            ),
            TextButton(
              onPressed: () {
                // Do something.
              },
              child: Text(
                'Deleted Data',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

    */
