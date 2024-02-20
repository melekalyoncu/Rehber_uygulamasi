import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kisiler_uygulamasi/KisiDetaySayfa.dart';
import 'package:kisiler_uygulamasi/KisiKayitSayfa.dart';
import 'package:kisiler_uygulamasi/Kisiler.dart';
import 'package:kisiler_uygulamasi/Kisilerdao.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  bool aramayapiliyorMu = false;
  String aramaKelimesi = "";

  Future<List<Kisiler>> tumKisileriGoster() async {
    var kisilerListesi = await Kisilerdao().tumKisiler();
    return kisilerListesi;

  }

  Future<List<Kisiler>> aramaYap(String aramaKelimesi) async {
    var kisilerListesi = await Kisilerdao().kisiArama(aramaKelimesi);
    return kisilerListesi;

  }

  Future<void> sil(int kisi_id) async {
    await Kisilerdao().kisiSil(kisi_id);

    setState(() {

    });
  }

  Future<bool> uygulamayikapat() async {
    await exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            uygulamayikapat();

          },
        ),
        title: aramayapiliyorMu ?
        TextField(
         decoration: InputDecoration(hintText: "Arama için bir şey yazın"),
          onChanged: (aramaSonucu){
           print("arama sonucu: $aramaSonucu");

           setState(() {
             aramaKelimesi=aramaSonucu;
           });
          },
        )
            :Text("Kişiler Uygulaması"),
        actions: [
          aramayapiliyorMu ?
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: (){
              setState(() {
                aramayapiliyorMu = false;
                aramaKelimesi ="";
              });
            },
          )
              : IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              setState(() {
                aramayapiliyorMu = true;
              });
            },
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: uygulamayikapat,
        child: FutureBuilder<List<Kisiler>>(
          future: aramayapiliyorMu ? aramaYap(aramaKelimesi) : tumKisileriGoster(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              var kisilerListesi = snapshot.data;
              return ListView.builder(
                itemCount: kisilerListesi!.length,
                itemBuilder: (context,index){
                  var kisi = kisilerListesi[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => KisiDetaySayfa(kisi: kisi,)));
                    },
                    child: Card(
                      child: SizedBox(height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(kisi.kisi_ad,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.pink),),
                            Text(kisi.kisi_tel),
                          IconButton(
                          icon: Icon(Icons.delete,color: Colors.pink,),
                            onPressed: (){
                            sil(kisi.kisi_id);
                            },
                    ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );

            }else{
              return Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => KisiKayitSayfa()));
        },
        tooltip: 'Kişi ekle',
        child: const Icon(Icons.add),
      ),
    );
  }
}
