
import 'package:flutter/material.dart';
import 'package:kisiler_uygulamasi/Kisiler.dart';
import 'package:kisiler_uygulamasi/Kisilerdao.dart';

import 'main.dart';

class KisiDetaySayfa extends StatefulWidget {

  Kisiler kisi;
  KisiDetaySayfa({required this.kisi});

  @override
  State<KisiDetaySayfa> createState() => _KisiDetaySayfaState();
}

class _KisiDetaySayfaState extends State<KisiDetaySayfa> {

  var tfKisiAdi = TextEditingController();
  var tfKisiTel = TextEditingController();

  Future<void> guncelle(String kisi_ad,String kisi_tel,int kisi_id) async {
    await Kisilerdao().kisiguncelle(kisi_id, kisi_ad, kisi_tel);

    Navigator.push(context as BuildContext, MaterialPageRoute(builder: (context) => Anasayfa()));
  }

  @override
  void initState() {
    super.initState();
    var kisi= widget.kisi;
    tfKisiAdi.text = kisi.kisi_ad;
    tfKisiTel.text = kisi.kisi_tel;

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kişiler Uygulaması"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50,right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                controller: tfKisiAdi,
                decoration: InputDecoration(hintText: "Kişi Ad"),
              ),

              TextField(
                controller: tfKisiTel,
                decoration: InputDecoration(hintText: "Kişi tel"),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          guncelle(tfKisiAdi.text, tfKisiTel.text, widget.kisi.kisi_id);

        },
        tooltip: 'Kişi guncelle',
        icon: const Icon(Icons.update),
        label: Text("guncelle"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
