import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_realtimedb/nemgecmis.dart';
import 'package:firebase_realtimedb/sicakliktehlike.dart';
import 'package:firebase_realtimedb/sohbet.dart';
import 'package:firebase_realtimedb/nemkayit.dart';
import 'package:firebase_realtimedb/sonsicaklik.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marquee/marquee.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:wave_progress_widget/wave_progress.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';



import './dht.dart';

import 'bitkiismi.dart';
import 'grafikC.dart';

class SinglePageApp extends StatefulWidget {
  @override
  _SinglePageAppState createState() => _SinglePageAppState();
}

class _SinglePageAppState extends State<SinglePageApp>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int tabIndex = 0;
  double _sicaklik = 0;
  DateTime now = DateTime.now();
  double _datasicaklikglobel2;
  String _datasicaklikglobel;
  double _datanemglobel2;
  String _datanemglobel;
  double _sonuc;
  double _sonuc2;
  double _sonuc3;
  double _sonuc4;
  double _sonucson = 100;
  double _sula = 100;
  int _sul;
  String _message = ""; // su döküldü / su yok mesajı
  String _displayText = '';

  String _mesaj = '';

  String saatMesaji() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    String cevap;


    if (hour >= 22 || hour < 5) {
      cevap = "İyi geceler! Uyuman gerek geç olmadan dinlen "; // öne
    } // arkaya koy
    else if (hour >= 17 && hour < 20) {
      cevap = "Akşam oluyor. Yemeğini yedin dimi? ";
    } else {
      cevap = "";
    }


    return cevap;
  }

  String saatMesaji2() {
    DateTime now = DateTime.now();

    int hour = now.hour;
    String cevap;


    if (hour >= 5 && hour < 12) {
      cevap = ", günaydın! bugün seni iyi gördüm"; // arkaya koy
    }
    else if (hour >= 12 && hour < 17) {
      cevap =
      ", iyi öğlenler! Bugün çok güzelsin. Beraber fotoğraf çekilmeliyiz gibi :)";
    } else {
      cevap = "";
    }


    return cevap;
  }


  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _dhtRef =
  FirebaseDatabase.instance.reference().child('test');

  bool _signIn;
  String heatIndexText;
  Timer _timer;
  int _selectedIndex = 0;


  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
    _signIn = false;
    // heatIndexText = "Showing Heat Index Here Soon ...";

    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (_signIn) {
        setState(() {});
      }
    });

    _signInAnonymously();
    // ----------------  //


  }


  @override
  void dispose() {
    _tabController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _signIn ? mainScaffold() : signInScaffold();
  }

  Widget mainScaffold() {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                if (_selectedIndex == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePagenem()),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MaterialCommunityIcons.water,
                    color: _selectedIndex == 0 ? Colors.blueAccent : Colors.grey,
                  ),
                  Text(
                    'Son Nem Değerleri',
                    style: TextStyle(
                      color: _selectedIndex == 0 ? Colors.blueAccent : Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                if (_selectedIndex == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MaterialCommunityIcons.fire,
                    color: _selectedIndex == 2 ? Colors.blueAccent : Colors.grey,
                  ),
                  Text(
                    'Son Sıcaklık Değerleri',
                    style: TextStyle(
                      color: _selectedIndex == 2 ? Colors.blueAccent : Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ),
      appBar: AppBar(
        // bu kısım sağ üste buton için
        actions: [
          IconButton(
            icon: Icon(Icons.highlight),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VeriTehlike()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.wechat_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MiniChatScreen()),
              );
            },
          ),
        ],
        // bu kısım sağ üste buton için
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 16.0), // üste uzaklığı
            child: Text(
              "Bitkim Güvende",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                fontFamily: 'Helvetica Neue',
              ),
            ),
          ),
        ),

        backgroundColor: Colors.blue,
        elevation: 5.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              onTap: (int index) {
                setState(() {
                  tabIndex = index;
                });
              },
              tabs: [
                Tab(
                  icon: Icon(
                    MaterialCommunityIcons.home_analytics,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                ),
                Tab(
                  icon: Icon(
                    MaterialCommunityIcons.fire,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                ),

                Tab(
                  icon: Icon(
                    MaterialCommunityIcons.temperature_celsius,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                ),

                Tab(
                  icon: Icon(
                    MaterialCommunityIcons.water_percent,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                ),


              ],
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 3.0,
                ),
                insets: EdgeInsets.symmetric(horizontal: 20.0),
              ),
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: 30),
          Expanded(
            child: StreamBuilder(
                stream: _dhtRef.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError &&
                      snapshot.data.snapshot.value != null) {
                    var _dht = DHT.fromJson(
                        snapshot.data.snapshot.value['json']);
                    return IndexedStack(
                      index: tabIndex,
                      children: [
                        _orta(_dht),
                        _sicakliksol(_dht),
                        _temperatureLayout(_dht),

                        _humidityLayout(_dht) // sıralıyorum soldan sağa açılışı


                      ],
                    );
                  } else {
                    return Center(
                      child: Text("DATA YOK"),
                    );
                  }
                }
            ),
          ),
        ],
      ),
    );
// üst kısmı değiştirdim B*
  }


  TextEditingController _sogukTextController = TextEditingController();
  TextEditingController _nemTextController = TextEditingController();

  Widget _sicakliksol(DHT _dht) {
    _sicaklik = _dht.temp;
    Color progressColor;
    if (_sonucson > (70)) {
      progressColor = Colors.lightGreenAccent;
    } else if (_sonucson > 50 && _sonucson < 71) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

    Color progressBackgroundColor;
    if (_sonucson > (70)) {
      progressBackgroundColor = Colors.lightGreenAccent;
    } else if (_sonucson >= 50 && _sonucson < 71) {
      progressBackgroundColor = Colors.orange;
    } else {
      progressBackgroundColor = Colors.red;
    }


    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder(
                  future: FirebaseDatabase.instance
                      .reference()
                      .child('test')
                      .child('json')
                      .child('zzzn')
                      .once(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.value != null) {
                      final data = snapshot.data.value;
                      _datanemglobel = data;
                      double datasicAsDouble = double.parse(data);
                      _datanemglobel2 = datasicAsDouble;


                      // Dönüştürülmüş double değerini kullanabilirsiniz
                      return Text(
                        '',
                        style: TextStyle(
                          fontSize: 0,
                          color: Colors.black,
                        ),
                      );
                    }
                    // Veri yüklenmediyse veya null ise, bir yükleniyor göstergesi veya hata mesajı gösterin
                    return CircularProgressIndicator();
                  },
                ),
                FutureBuilder(
                  future: FirebaseDatabase.instance
                      .reference()
                      .child('test')
                      .child('json')
                      .child('zzzs')
                      .once(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.value != null) {
                      final datasic = snapshot.data.value;
                      _datasicaklikglobel = datasic;
                      double datasicAsDouble = double.parse(datasic);
                      _datasicaklikglobel2 = datasicAsDouble;

                      _sonuc = _dht.temp - _datasicaklikglobel2;
                      _sonuc2 = _sonuc.abs(); // mutlak değer alıyorum
                      _sonuc3 = _dht.humidity - _datanemglobel2;
                      _sonuc4 = _sonuc3.abs();
                      _sonucson = 100 -
                          (((_sonuc2 * _sonuc2) / 3 + (_sonuc4 * _sonuc4) / 3) *
                              1.8);
                      if (_sonucson < 0) {
                        _sonucson == 0;
                      }


                      return Text(
                        '',
                        style: TextStyle(
                          fontSize: 0,
                          color: Colors.black,
                        ),
                      );
                    }
                    // Veri yüklenmediyse veya null ise, bir yükleniyor göstergesi veya hata mesajı gösterin
                    return CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),

          Container(

            padding: const EdgeInsets.only(top: 0),
            child: Text(
              "Sıcaklık $_datasicaklikglobel, Nem, $_datanemglobel Uygulanıyor. Değiştirmek için Aşağıdan güncelleyeniz",
              style: TextStyle(fontSize: 8),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: WaveProgress(
                  180.0,
                  progressColor,
                  progressBackgroundColor,
                  _sonucson,
                ),
              ),
              SizedBox(width: 35),
              Text(
                "Bitkiniz Sağlık Yüzdesi\n${_sonucson.toStringAsFixed(2)}%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              SizedBox(
                width: 150,
                height: 100,
                child: LiquidLinearProgressIndicator(
                  value: _dht.humidity / 100,
                  valueColor: AlwaysStoppedAnimation(
                      Colors.blue.withOpacity(0.5)),
                  backgroundColor: Colors.white60.withOpacity(0.5),
                  borderColor: Colors.transparent,
                  borderWidth: 0.0,
                  direction: Axis.horizontal,
                  center: Text(
                    "Nem ${_dht.humidity.toStringAsFixed(2)} %",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              SizedBox(
                width: 150,
                height: 100,
                child: LiquidLinearProgressIndicator(
                  value: _dht.humidity / 100,
                  valueColor: AlwaysStoppedAnimation(
                      Colors.red.withOpacity(0.5)),
                  backgroundColor: Colors.white60.withOpacity(0.5),
                  borderColor: Colors.transparent,
                  borderWidth: 0.0,
                  direction: Axis.horizontal,
                  center: Text(
                    "Sıcaklık ${_dht.temp.toStringAsFixed(2)} °C",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 65),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bitkiniz için ideal sıcaklık ve nem bilgilerini giriniz.",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SizedBox(width: 150, height: 40, child:
                    TextField(
                      controller: _sogukTextController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Sıcaklık (°C)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 150, height: 40,
                      child: TextField(
                        controller: _nemTextController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Nem (%)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        String sogukText = _sogukTextController.text;
                        String nemText = _nemTextController.text;

                        if (sogukText.isNotEmpty) {
                          DatabaseReference sogukRef =
                          FirebaseDatabase.instance.reference()
                              .child("test")
                              .child("json")
                              .child("zzzs");
                          sogukRef.set(sogukText);
                        }

                        if (nemText.isNotEmpty) {
                          DatabaseReference nemRef =
                          FirebaseDatabase.instance.reference()
                              .child("test")
                              .child("json")
                              .child("zzzn");
                          nemRef.set(nemText);
                        }

                        _sogukTextController.clear();
                        _nemTextController.clear();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Bilgiler kaydedildi."),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text("Kaydet"),
                    ),
                  ],),
              ],
            ),
          ),


        ],
      ),
    );
  }


  Widget _temperatureLayout(DHT _dht) {
    return Center(
      child: GrafikC(),
    );
  }

/*
  Widget _temperatureLayout(DHT _dht) {
    return Center(
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              "SICAKLIK",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: WaveProgress(
                  180.0,
                  Colors.red,
                  Colors.redAccent,
                  _dht.temp,
                ),
              ),

              SizedBox(width: 20),
              Text(
                "${_dht.temp.toStringAsFixed(2)} °C",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _dhtRef.update({"ac": 1});
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.power),
                    SizedBox(width: 8),
                    Text("Işık Aç = 1"),
                  ],
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  _dhtRef.update({"akapat": 0});
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.power_off),
                    SizedBox(width: 8),
                    Text("Işık Kapat = 0"),
                  ],
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
  */
  /*
  Widget _temperatureLayout(DHT _dht) {
    return Center(
        child: Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 1),
          child: Text(
            "SICAKLIK",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Expanded(

          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: WaveProgress(
                  180.0, Colors.red, Colors.redAccent, _dht.humidity)),
        ),
       /* Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: FAProgressBar(
              progressColor: Colors.green,
              direction: Axis.vertical,
              verticalDirection: VerticalDirection.up,
              size: 100,
              currentValue: _dht.temp.round(),

              changeColorValue: 100,
              changeProgressColor: Colors.red,
              maxValue: 150,
              displayText: "°C",
              borderRadius: 16,
              animatedDuration: Duration(milliseconds: 500),
            ),
          ),
        ), */
        Container(
          padding: const EdgeInsets.only(bottom: 40),
          child: Text(
            "${_dht.temp.toStringAsFixed(2)} °C",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _dhtRef.update({"ac": 1});
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.power),
                  SizedBox(width: 5),
                  Text("Işık Aç = 1"),
                ],
              ),
            ),
            SizedBox(width: 5), // 16 piksel boşluk
            ElevatedButton(
              onPressed: () {
                _dhtRef.update({"akapat": 0});
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.power_off),
                  SizedBox(width: 5),
                  Text("Işık Kapat = 0"),
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }
*/


//// mesaj yanıtı için
  Widget _orta(DHT dht) {
    return Column(

      children: [

        Text(
          "Saat: ${now.hour}:${now.minute} Tarih: ${now.day}.${now.month}.${now
              .year}",

          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),

        SizedBox(height: 2),
        Text(
          "__________________________________________________________________________________ \n ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
        //    Text(
        // 'Ortakullanici: $_ortakullanici $_sicaklik',
        //style: TextStyle(fontSize: 18),
        //),
        Row(
          children: [
            Image(
              image: AssetImage("assets/bitkimana.png"),
              height: 320,
              width: 320,
            ),
            // yan yana için buraya koyarım sonra
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.blue,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder(
                future: FirebaseDatabase.instance
                    .reference()
                    .child('test')
                    .child('json')
                    .child('name')
                    .child('plant')
                    .once(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    final data = snapshot.data.value;
                    return Text(
                      ' ${saatMesaji()}$data${saatMesaji2()} ',
                      // saate göre cevap vercek
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text(
                      'HATA: ${snapshot.error}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        )

      ],
    );
  }





  Widget _humidityLayout(DHT _dht) {
    return Center(
      child: Column(
        children: [
          Container(

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder(
                  future: FirebaseDatabase.instance
                      .reference()
                      .child('test')
                      .child('json')
                      .child('sulamiktar')

                      .once(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasData) {
                      final datam = snapshot.data.value;
                      _sula = datam +0.0001;


                      return Text(
                        '',

                      );
                    }

                    return Container();
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 00),
                child: WaveProgress(
                    180.0, Colors.blue, Colors.blueAccent, _sula)),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 150),
            child: Text(
              "Depodaki su yüzdesi ${_sula.toStringAsFixed(2)}% ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          Container(

            child: Text(
              "(Not:Yaklaşık Değerdir(+-30))",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ),

          Row( mainAxisSize: MainAxisSize.min,
              children: [
          ElevatedButton(
            onPressed: () {
              if (_sula > 0) { // sıfırdan büyükse su var
                setState(() {
                  _message = "su döküldü";
                  _sula -= 10; // 10 azalt
                });
                DatabaseReference _ref2 = FirebaseDatabase.instance.reference().child("test").child("json").child("sulamiktarveri");
                _ref2.set(1);

                Future.delayed(Duration(seconds: 2), () {
                  _ref2.set(0);
                });
                DatabaseReference _ref = FirebaseDatabase.instance.reference().child("test").child("json").child("sulamiktar");
                _ref.set(_sula.toDouble()); // _sula değerini Firebase'e gönder
                Future.delayed(Duration(seconds: 3), () {
                  setState(() {
                    _message = ""; // 3 saniye sonra mesajı temizle

                  });
                });
              } else { // sıfırsa su yok
                setState(() {
                  _message = "su yok";
                });
              }
            },


            child: Text("Su Dök"),
          ),
                SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                if (_sula > 0) { // sıfırdan büyükse su var
                  setState(() {
                    _message = "Depo Fullendi";
                    // 10 azalt
                  });
                  DatabaseReference _ref = FirebaseDatabase.instance.reference().child("test").child("json").child("sulamiktar");
                  _ref.set(100.0001); // _sula değerini Firebase'e gönder
                  Future.delayed(Duration(seconds: 3), () {
                    setState(() {
                      _message = ""; // 3 saniye sonra mesajı temizle
                    });
                  });
                }
              },


              child: Text("Depoyu Doldurdum"),
            ),


          ] ),
          Text(
            _message,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }



  /*_setMarqueeText(DHT _dht) {
    heatIndexText = "Heat Index: ${_dht.heatIndex.toStringAsFixed(2)} °F, ";
    if (_dht.heatIndex > 80 && _dht.heatIndex <= 90) {
      heatIndexText +=
      "Caution: fatigue is possible with prolonged exposure and activity. Continuing activity could result in heat cramps. ";
    } else if (_dht.heatIndex > 90 && _dht.heatIndex <= 105) {
      heatIndexText +=
      "Extreme caution: heat cramps and heat exhaustion are possible. Continuing activity could result in heat stroke. ";
    } else if (_dht.heatIndex > 105 && _dht.heatIndex <= 130) {
      heatIndexText +=
      "Danger: heat cramps and heat exhaustion are likely; heat stroke is probable with continued activity. ";
    } else if (_dht.heatIndex > 130) {
      heatIndexText += "Extreme danger: heat stroke is imminent. ";
    } else {
      heatIndexText += "Normal. ";
    }
  } */

  Widget _buildMarquee() {
    return Marquee(
      text: heatIndexText,
      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),
    );
  }

  Widget signInScaffold() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sıcaklık && Nem Ölçme",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () async {
                _signInAnonymously();
              },
              child: Text(
                "DOKUN VE GİRİŞ YAP",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signInAnonymously() async {
    final FirebaseUser user = (await _auth.signInAnonymously()).user;
    print("*** user isAnonymous: ${user.isAnonymous}");
    print("*** user uid: ${user.uid}");

    setState(() {
      if (user != null) {
        _signIn = true;
      } else {
        _signIn = false;
      }
    });
  }

  List<charts.Series<dynamic, DateTime>> _createTemperatureData() {}


}

