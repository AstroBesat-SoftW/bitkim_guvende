import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyHomePages extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePages> {
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
