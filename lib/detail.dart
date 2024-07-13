import 'dart:convert';

import 'package:aan_uas/editData.dart';
import 'package:aan_uas/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:nb_utils/nb_utils.dart';

class DetailScreen extends StatefulWidget {
  Map data;
  DetailScreen(this. data, {super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

     Future delWallet(String key) async {
        DatabaseReference databaseReference =
            FirebaseDatabase.instanceFor(app: Firebase.app(),
          databaseURL:
              'https://aan-uas-default-rtdb.asia-southeast1.firebasedatabase.app/').ref().child('wallets');

       databaseReference.child(key).remove().then((value){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hapus Data berhasil !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green,));
        print("Transaction deleted successfully!");
        Navigator.pop(context);
        return true;
      })
      .catchError((error){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hapus Data gagal !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red,));
        print("Failed to delete trans: $error");
        return false;
      });

      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      title: Text('Detail ${widget.data['tipe']}', style: GoogleFonts.aBeeZee(fontSize:16),),
      flexibleSpace: Container(
           decoration: BoxDecoration(
           gradient: LinearGradient(
           begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.white,
              Colors.blue
            ])
           ),
          ),
         ),
    body: SingleChildScrollView(child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
    child: 
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        30.height,
        Padding(padding: EdgeInsets.symmetric(horizontal: 0.05*context.width()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          GestureDetector(
          onTap: (){
            Dialogs.materialDialog(
                      barrierDismissible: true,
                      color: Colors.white,
                      title: 'Detail',
                      customView: Container(
                            child: Image.memory(base64Decode(widget.data['trans'])),
                          ),
                      customViewPosition: CustomViewPosition.BEFORE_ACTION,
                      context: context,
                      actions: []);
          },
          child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          height: 0.2*MediaQuery.of(context).size.height, width:  MediaQuery.of(context).size.width, decoration: BoxDecoration(color: Colors.lightBlue, borderRadius: BorderRadius.circular(15),
          image: userDetail.isNotEmpty ?DecorationImage(image:  MemoryImage(base64Decode(widget.data['trans'])), fit: BoxFit.cover,):DecorationImage(image:  NetworkImage(base64Img), fit: BoxFit.cover,)
          ),),),
          30.height,
          Text('Tanggal ${widget.data['tipe']}', style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight:FontWeight.bold),),
          10.height,
          Text('${widget.data['tanggal']}', style:  GoogleFonts.aBeeZee(fontSize: 14),),
          20.height,
          Text('Kode ${widget.data['tipe']}', style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight:FontWeight.bold),),
          10.height,
          Text('${widget.data['key']}', style:  GoogleFonts.aBeeZee(fontSize: 14),),
          20.height,
          Text('Jumlah ${widget.data['tipe']}', style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight:FontWeight.bold),),
          10.height,
          Text('IDR ${widget.data['nominal']}', style:  GoogleFonts.aBeeZee(fontSize: 20, fontWeight:FontWeight.bold,color: widget.data['tipe']=='pemasukan'?Colors.green[600]:Colors.red[600]),),
          30.height,
          Text('Keterangan ${widget.data['tipe']}', style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight:FontWeight.bold),),
          10.height,
          Text('${widget.data['keterangan']}', style:  GoogleFonts.aBeeZee(fontSize: 14),),
        ],),
        ),
        50.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          GestureDetector(
            onTap: (){
             delWallet(widget.data['key']);
            },  
            child: Container(width: 150, height: 40, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.red[900]),
            child: Center(child: Text('Hapus Data', style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),),),
            ),),
            10.width,
          GestureDetector(
            onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (c)=>EditData(widget.data)));
            },  
            child: Container(width: 150, height: 40, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.green[900]),
            child: Center(child: Text('Update Data', style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),),),
            ),),

        ],)
    ],),
    ),),
    );

  }
}