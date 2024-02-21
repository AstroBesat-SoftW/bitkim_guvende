import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'singlepage_app.dart';



class MiniChatScreen extends StatefulWidget {
  @override
  _MiniChatScreenState createState() => _MiniChatScreenState();
}

class _MiniChatScreenState extends State<MiniChatScreen> {
  String _temp;

  final databaseReference = FirebaseDatabase.instance.reference().child("test/ac");
  final databaseReferencee = FirebaseDatabase.instance.reference().child("test/double");


  TextEditingController _textEditingController = TextEditingController();
  List<String> messages = [];
  Map<String, String> robotResponses = {
    'yardım': '>bir kaç komut:\nmerhaba\nnasılsın\ngüle güle\nbye\nSicaklik değerini öğrenmek için "scaklık" yaz. \nTelefonunda sıcaklık değerleriniz ne kadar sürede güncellenmesini istiyorsan \n>"veri hızi" yaz \nışık açmak veya kapatmak için "ışığı aç"-"ışığı kapat"',
    'yardim': '>bir kaç komut:\nmerhaba\nnasılsın\ngüle güle\nbye\nSicaklik değerini öğrenmek için "scaklık" yaz. \nTelefonunda sıcaklık değerleriniz ne kadar sürede güncellenmesini istiyorsan \n>"veri hızi"yaz \nışık açmak veya kapatmak için "ışığı aç"-"ışığı kapat"' ,
    'merhaba': '>:), nasılsın?',
    'iyiyim': '>hep iyi ol',
    'iyidir': '>hep iyi ol',
    'nasılsın': '>Ben bir botum, duygularım yok!',
    'güle güle': '>Görüşürüz!',
    'bye': '>Görüşürüz!',
    'veri': '> günde kaç veri istersin?',
    'sicaklik': '>Hemen konrtol ediyorum.'


  };


  void _handleSubmitted(String text) async {
    _textEditingController.clear();
    setState(() {
      messages.add(text);
      String robotResponse;
      bool isMatched = false;
      if (text.toLowerCase() == "sıcaklık" || text.toLowerCase() == "sicaklik") {
        final reference = FirebaseDatabase.instance.reference().child('test/json/double');
        reference.once().then((DataSnapshot snapshot) {
          var data = snapshot.value;
          robotResponse = 'Sıcaklık $data C°';
          messages.add(robotResponse);
        });
        isMatched = true;
      }
      //  diğeri
      if (text.toLowerCase() == "ışığı aç" || text.toLowerCase() == "isigi ac") {
        final reference = FirebaseDatabase.instance.reference().child('test/ac');
        reference.once().then((DataSnapshot snapshot) {
          reference.set(1);
          robotResponse = 'Işık Açıldı.';
          messages.add(robotResponse);
        });
        isMatched = true;
      }
      // diğeri
      if (text.toLowerCase() == "ışığı kapat" || text.toLowerCase() == "isigi kapat") {
        final reference = FirebaseDatabase.instance.reference().child('test/ac');
        reference.once().then((DataSnapshot snapshot) {
          reference.set(0);
          robotResponse = 'Işık Kapandı.';
          messages.add(robotResponse);
        });
        isMatched = true;
      }

      // Girilen değerin sayısal bir değer olduğunu kontrol ediyoruz
      if (int.tryParse(text) != null) {
        // Sayısal bir değer girildiyse, onu alıp bir işlem yapabiliriz
        if (messages.last.toLowerCase().contains('veri hizi') && !RegExp(r'\d+').hasMatch(text) || messages.last.toLowerCase().contains('veri hızı') && !RegExp(r'\d+').hasMatch(text)) {
          robotResponse = 'Kaç derece olsun?';
        } else {
          int number = int.parse(text);
          robotResponse = 'Günde $number adet gönderilmek üzere onaylandı.';

          // Firebase veritabanına veri ekleme işlemi
          var app;
          final reference = FirebaseDatabase(app: app).reference().child('test/verihizi');
        //  reference.set({'realdata': number.toString()});
          reference.set(number);

        }

        messages.add(robotResponse);
        isMatched = true;
      } else {
        // Girilen değer sayısal bir değer değilse, önceden olduğu gibi diğer komutları kontrol ederiz
        for (var key in robotResponses.keys) {
          List<String> words = key.split(' ');
          bool isWordsMatched = true;
          for (var word in words) {
            if (!text.toLowerCase().contains(word.toLowerCase())) {
              isWordsMatched = false;
              break;
            }
          }

          if (isWordsMatched) {
            robotResponse = robotResponses[key] ?? 'Üzgünüm, anlamadım.';
            messages.add(robotResponse);
            isMatched = true;
            break;
          }
        }
      }

      if (!isMatched) {
        messages.add('Üzgünüm, anlamadım.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mini Sohbet Ekranı'),
      ),

      body: Column(
        children: [
          Row(
            children: [
              Image(
                image: AssetImage("assets/bitkimana.png"),
                height: 100,
                width: 100,
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
                          return AnimatedTextKit(
                            // Sonsuz tekrar et
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'Hey $data, nasılsın? Basit komutları görmek istiyorsan "Yardım" yaz.\n................................................................................................... <3',
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8,
                                  color: Colors.white,
                                ),
                                speed: Duration(milliseconds: 100),
                              ),
                            ],
                            pause: Duration(seconds: 0),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
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
          ),


          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Align(
                    alignment: messages[index].startsWith('Ben') ? Alignment.centerRight : Alignment.centerLeft,

                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: messages[index].startsWith('Ben') ? Colors.white : Colors.blue,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text(messages[index], style: TextStyle(color: messages[index].startsWith('Ben') ? Colors.black : Colors.white)),
                    ),

                  ),
                );
              },
              itemCount: messages.length,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    onSubmitted: _handleSubmitted,
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı buraya yazın',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => _handleSubmitted(_textEditingController.text),
                  child: Text('Gönder'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





/*

class MiniChatScreen extends StatefulWidget {
  @override
  _MiniChatScreenState createState() => _MiniChatScreenState();
}

class _MiniChatScreenState extends State<MiniChatScreen> {


  TextEditingController _textEditingController = TextEditingController();
  List<String> messages = [];
  Map<String, String> robotResponses = {
    'yardım': '>bir kaç komut:\n merhaba\nnasılsın\ngüle güle\nmerhaba nasılsın',
    'yardim': '>bir kaç komut:\n merhaba\nnasılsın\ngüle güle\nmerhaba nasılsın',
    'merhaba': '>Merhaba, nasılsın?',
    'nasılsın': '>Ben bir botum, duygularım yok!',
    'güle güle': '>Görüşürüz!',
    'merhaba nasılsın': '>İyiyim, teşekkür ederim. Sen nasılsın?'
  };

  void _handleSubmitted(String text) {
    _textEditingController.clear();
    setState(() {
      messages.add(text);
      String robotResponse;
      bool isMatched = false;
      for (var key in robotResponses.keys) {
        List<String> words = key.split(' ');
        bool isWordsMatched = true;
        for (var word in words) {
          if (!text.toLowerCase().contains(word.toLowerCase())) {
            isWordsMatched = false;
            break;
          }
        }

        if (isWordsMatched) {
          robotResponse = robotResponses[key] ?? 'Üzgünüm, anlamadım.';
          messages.add(robotResponse);
          isMatched = true;
          break;
        }
      }

      if (!isMatched) {
        messages.add('Üzgünüm, anlamadım.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mini Sohbet Ekranı'),
      ),

      body: Column(
        children: [
          Row(
            children: [
              Image(
                image: AssetImage("assets/bitkimana.png"),
                height: 100,
                width: 100,
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
                          return AnimatedTextKit(
                            // Sonsuz tekrar et
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'Hey $data, nasılsın? Basit komutları görmek istiyorsan "Yardım" yaz.\n................................................................................................... <3',
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8,
                                  color: Colors.white,
                                ),
                                speed: Duration(milliseconds: 100),
                              ),
                            ],
                            pause: Duration(seconds: 0),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
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
          ),


          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Align(
                    alignment: messages[index].startsWith('Ben') ? Alignment.centerRight : Alignment.centerLeft,

                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: messages[index].startsWith('Ben') ? Colors.white : Colors.blue,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text(messages[index], style: TextStyle(color: messages[index].startsWith('Ben') ? Colors.black : Colors.white)),
                    ),

                  ),
                );
              },
              itemCount: messages.length,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    onSubmitted: _handleSubmitted,
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı buraya yazın',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => _handleSubmitted(_textEditingController.text),
                  child: Text('Gönder'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


*/