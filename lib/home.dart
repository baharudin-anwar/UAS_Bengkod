import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:aan_uas/addData.dart';
import 'package:aan_uas/detail.dart';
import 'package:aan_uas/login.dart';
import 'package:aan_uas/register.dart';
import 'package:aan_uas/wallets_model.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:nb_utils/nb_utils.dart';



String emailUserSesi='';
Map userDetail ={};
String base64Img='https://awsimages.detik.net.id/community/media/visual/2023/11/15/ahyeon-babymonster-1_43.jpeg?w=1200';

  List walletsAll = [];
  int saldo = 0;

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nominal = TextEditingController();

  TextEditingController keterangan = TextEditingController();

  TextEditingController tanggal = TextEditingController();

  TextEditingController tipe = TextEditingController();

  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  void cekSaldo(){
    saldo = 0;
    for(int i = 0; i < walletsAll.length; i++){
      if(walletsAll[i]['tipe']== 'pemasukan'){
        saldo += int.parse(walletsAll[i]['nominal']);
      }
      if(walletsAll[i]['tipe']== 'pengeluaran'){
        saldo -= int.parse(walletsAll[i]['nominal']);
      }
    }
    setState(() {
      
    });

  }

  void dataAll() async {
        DatabaseReference databaseReference =
            FirebaseDatabase.instanceFor(app: Firebase.app(),
          databaseURL:
              'https://aan-uas-default-rtdb.asia-southeast1.firebasedatabase.app/').ref().child('wallets');

          databaseReference.onValue.listen((event) {
            DataSnapshot dataSnapshot = event.snapshot;
            if(dataSnapshot.exists){
              Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;
              if(walletsAll.isNotEmpty){
                walletsAll.clear();
              }

              values.forEach((key, values) {
                  if(values['key_user'] == userDetail['key']){
                    walletsAll.add({
                      'key': key,
                      'key_user': values['key_user'],
                      'nominal': values['nominal'],
                      'keterangan': values['keterangan'],
                      'tanggal': values['tanggal'],
                      'tipe': values['tipe'],
                      'trans': values['trans'],
                    });
                  }
                  
                  setState(() {
                    print(walletsAll);
                  });
                  cekSaldo();
                });
            }
            
          });

      }
  
  void getDetailData() async {
        DatabaseReference databaseReference =
            FirebaseDatabase.instanceFor(app: Firebase.app(),
          databaseURL:
              'https://aan-uas-default-rtdb.asia-southeast1.firebasedatabase.app/').ref().child('users');

          databaseReference.onValue.listen((event) {
            DataSnapshot dataSnapshot = event.snapshot;
            Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;

              values.forEach((key, values) {
                if(values['email'] == emailUserSesi){
                  userDetail = {
                    'key': key,
                    'email': values['email'],
                    'phone': values['phone'],
                    'imgProfile': values['imgProfile'],
                  };
                }
                setState(() {
                });
              });
              print(userDetail);
          });

      }



  @override
  void initState() {
    getDetailData();
    dataAll();
    print(userDetail);
    super.initState();
  }

  String removeBase64(String img) {
    if (img.contains('data:image/png;base64, ') == true) {
      var img64 = img.split('data:image/png;base64, ');
      String imgNew = img64[1].replaceAll(RegExp(r'\s+'), '');
      return imgNew;
    } else {
      return '';
    }
  }


  Future getImageGallery(context) async {
    final XFile? imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    _image = imageFile!;
    final bytes = File(_image!.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    base64Img = img64;
    setState(() {
      
    });
    print(img64);
    Navigator.pop(context);
  }

  Future getImageCamera(context) async {
    final XFile? imageFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    _image = imageFile!;
    final bytes = File(_image!.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    base64Img = img64;
    setState(() {
      
    });
    print(img64);
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(child: 
      Stack(children: [
        Container(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height, decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.lightBlue.shade200,
                  Colors.white,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp),
          ),
          child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              250.height,
              Center(child:  Container(width: 80, height:8, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.blueGrey),),),              
              20.height,
              Container(width: MediaQuery.of(context).size.width,height: 110, 
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.blue, border: Border.all(color: Colors.white, width: 3)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                10.width,
                SizedBox(width: 0.5*MediaQuery.of(context).size.width, child: 
                Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Text('Saldo Anda Saat ini', style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),),
                SizedBox(height: 5,),
                Text('IDR ${saldo}', style: GoogleFonts.aBeeZee(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),),
                ],),),
                30.width,
                GestureDetector(onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>AddData()));
                },
                child: Container( width: 35, height: 35, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                child: Icon(Icons.add, color: Colors.lightBlue,),),)
              ],),
              ),
              10.height,
              Text('Catatan Keuangan', style: GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),),
              20.height,
              Container(width: MediaQuery.of(context).size.width,height: 400,
              child: SingleChildScrollView(
                child: 
                Column(children: List.generate(walletsAll.length, (index) => 
                GestureDetector(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (c)=>DetailScreen(walletsAll[index])));},
                   child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                      BoxShadow(
                        blurStyle: BlurStyle.inner,
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],),
                  width: MediaQuery.of(context).size.width, height: 60, child: 
                  ListTile(
                    leading: Icon(Icons.wallet), 
                    title: Text(walletsAll[index]['keterangan']??'', style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),),
                    subtitle: Text(walletsAll[index]['tanggal']??'', style: GoogleFonts.aBeeZee(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),),
                    trailing: Text( "${walletsAll[index]['tipe']=='pemasukan'?'+':'-'} ${walletsAll[index]['nominal']??''}", style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold, color: walletsAll[index]['tipe']=='pengeluaran'?Colors.red:Colors.green),),
                  )),
                ),),
              ),
              ))
            ],
          )
          ,),),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          height: 0.3*MediaQuery.of(context).size.height, width:  MediaQuery.of(context).size.width, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(40), bottomStart: Radius.circular(40)),
        image: userDetail.isNotEmpty ?DecorationImage(image:  MemoryImage(base64Decode(userDetail['imgProfile'])), fit: BoxFit.cover,):DecorationImage(image:  NetworkImage(base64Img), fit: BoxFit.cover,)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(left: 0.60*MediaQuery.of(context).size.width), 
            child: 
            ElevatedButton(onPressed: (){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c)=>LoginScreen()), (route) => false);}, child: Text('Logout', style: GoogleFonts.aBeeZee(fontSize:14, color:Colors.red, fontWeight:FontWeight.bold),))
           ),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
           SizedBox(width: 0.6*MediaQuery.of(context).size.width, child: Text('${userDetail['email']??''}', style: GoogleFonts.aBeeZee(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),),
            // SizedBox(width: 0.1*MediaQuery.of(context).size.width, child:  IconButton(onPressed: (){
            //   Dialogs.materialDialog(
            //   barrierDismissible: true,
            //   color: Colors.white,
            //   title: 'Upload Gambar',
            //   customView: Container(
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               GestureDetector(
            //                 onTap: () {
            //                   getImageCamera(context);
            //                 },
            //                 child: Container(
            //                   width: 0.15 * MediaQuery.of(context).size.width,
            //                   child: Icon(
            //                     Icons.camera_alt, size: 35,
            //                   ),
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: 0.1 * MediaQuery.of(context).size.width,
            //               ),
            //               GestureDetector(
            //                 onTap: () {
            //                   getImageGallery(context);
            //                 },
            //                 child: Container(
            //                   width: 0.15 * MediaQuery.of(context).size.width,
            //                   child: Icon(
            //                     Icons.manage_search_rounded, size: 35,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //   customViewPosition: CustomViewPosition.BEFORE_ACTION,
            //   context: context,
            //   actions: []
            //   );
            // }, icon: Icon(Icons.upload, color: Colors.white,)),)
           ],)        ],),
        )
      ],),),
      );
  }
}