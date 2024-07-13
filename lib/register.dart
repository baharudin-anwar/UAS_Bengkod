import 'dart:convert';
import 'dart:io';

import 'package:aan_uas/bloc/custom_bloc.dart';
import 'package:aan_uas/home.dart';
import 'package:aan_uas/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:nb_utils/nb_utils.dart';




class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
 TextEditingController emailCont = TextEditingController();
 TextEditingController passwordCont = TextEditingController();
 TextEditingController passwordConfCont = TextEditingController();
 TextEditingController phoneCont = TextEditingController();
 CustomBloc imgProfile = CustomBloc();
 static FirebaseAuth _auth = FirebaseAuth.instance;
 final ImagePicker _picker = ImagePicker();

  CustomBloc _imgBloc = CustomBloc();
  XFile? _image;
  List allUserCheck = [];


  @override
  void initState() {
    getAllUser();
    super.initState();
    print(allUserCheck);
  }

Future getImageGallery(context) async {
    final XFile? imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    _image = imageFile!;

    final bytes = File(_image!.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    imgProfile.changeVal(img64);
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
    imgProfile.changeVal(img64);
    print(img64);
    Navigator.pop(context);
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

  Future createUser(String email, String pass) async {
    final result = await
       _auth.createUserWithEmailAndPassword(email: email, password: pass);
        print(result.additionalUserInfo);
       if(result.additionalUserInfo == null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Register gagal !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red,));
        return false;
       }else{
        emailUserSesi=email;
        saveUser(emailCont.text, phoneCont.text, imgProfile.state);
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Register berhasil !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green,));
        emailCont.clear();
        phoneCont.clear();
        imgProfile.defaultVal();
        passwordConfCont.clear();
        passwordCont.clear();
          return true;
       }
      
  }

  void getAllUser() async {
        DatabaseReference databaseReference =
            FirebaseDatabase.instanceFor(app: Firebase.app(),
          databaseURL:
              'https://aan-uas-default-rtdb.asia-southeast1.firebasedatabase.app/').ref().child('users');

          databaseReference.onValue.listen((event) {
            DataSnapshot dataSnapshot = event.snapshot;
            Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;
            if(allUserCheck.isNotEmpty){
              allUserCheck.clear();
            }
              values.forEach((key, values) {
                allUserCheck.add({
                    'key': key,
                    'email': values['email'],
                    'phone': values['phone'],
                    'imgProfile': values['imgProfile'],
                });
              });
              setState(() {
                print(allUserCheck);
              });
          });

      }

  bool cek(){
    print(allUserCheck);
    for(int i = 0; i < allUserCheck.length; i++){
      if(emailCont.text == allUserCheck[i]['email']){
        return true;
      }
    }
    return false;
  }


  Future saveUser(String email, String phone, String imgProfile) async {
        DatabaseReference databaseReference =
            FirebaseDatabase.instanceFor(app: Firebase.app(),
          databaseURL:
              'https://aan-uas-default-rtdb.asia-southeast1.firebasedatabase.app/').ref().child('users');

       databaseReference.push().set({
          'email': email,
          'phone': phone,
          'imgProfile': imgProfile,
        }).then((value){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tambah Data User berhasil !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green,));
        print("Data added successfully!");
        return true;
      })
      .catchError((error){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tambah Data User gagal !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red,));
        print("Failed to add trans: $error");
        return false;
      });

      }

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blue[200],
      body: 
            Container(
              width: context.width(),
              height: context.height(),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    60.height,
                    Text("Create Account", style: GoogleFonts.aBeeZee(fontSize: 28, fontWeight: FontWeight.bold)),
                    10.height,
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Container(
                            width: context.width(),
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 16),
                            margin: EdgeInsets.only(top: 55.0),
                            decoration: boxDecorationWithShadow(
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                          height: 0.1 *
                                              MediaQuery.of(context).size.height,
                                        ),
                                          Text(
                                           'Foto Profile',
                                            style: primaryTextStyle(size: 14, color: Colors.grey),
                                          ),
                                          SizedBox(
                                            height: 0.01 * MediaQuery.of(context).size.height,
                                          ),
                                          BlocBuilder(
                                              bloc: imgProfile,
                                              buildWhen: (previous, current) {
                                                if (previous != current) {
                                                  return true;
                                                } else {
                                                  return false;
                                                }
                                              },
                                              builder: (context, state) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Dialogs.bottomMaterialDialog(
                                                    barrierDismissible: true,
                                                    color: Colors.white,
                                                    title: 'Pilih',
                                                    customView: Container(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  getImageCamera(context);
                                                                },
                                                                child: Container(
                                                                  width: 0.15 * MediaQuery.of(context).size.width,
                                                                  child: Image.asset(
                                                                    'img/icon_camera.png',
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 0.1 * MediaQuery.of(context).size.width,
                                                              ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  getImageGallery(context);
                                                                },
                                                                child: Container(
                                                                  width: 0.15 * MediaQuery.of(context).size.width,
                                                                  child: Image.asset(
                                                                    'img/icon_gallery.png',
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                    customViewPosition: CustomViewPosition.BEFORE_ACTION,
                                                    context: context,
                                                    actions: []
                                                    // [
                                                    // IconsButton(
                                                    //   onPressed: () {
                                                    //     Navigator.pop(context);
                                                    //   },
                                                    //   text: 'Kembali',
                                                    //   iconData: Icons.arrow_back,
                                                    //   color: WAInfo1,
                                                    //   textStyle: TextStyle(color: WALightColor),
                                                    //   iconColor: WALightColor,
                                                    // ),
                                                    // ]
                                                    );},
                                                  child: imgProfile.state != ''
                                                      ? Stack(
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundImage:
                                                                  MemoryImage(base64Decode(base64 == true
                                                                      ? removeBase64(imgProfile.state)
                                                                      : imgProfile.state)),
                                                              maxRadius: 0.11 * MediaQuery.of(context).size.width,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                top: 0.15 * MediaQuery.of(context).size.width,
                                                                left: 0.2 * MediaQuery.of(context).size.width,
                                                              ),
                                                              child: Icon(
                                                                Icons.change_circle,
                                                                color: Colors.blue,
                                                                size: 20,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : Stack(
                                                          children: [
                                                            Container(
                                                              width: 0.2 * MediaQuery.of(context).size.width,
                                                              height: 0.2 * MediaQuery.of(context).size.width,
                                                              child: Image.asset(
                                                                'img/profile.png',
                                                                fit: BoxFit.contain,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                top: 0.12 * MediaQuery.of(context).size.width,
                                                                left: 0.15 * MediaQuery.of(context).size.width,
                                                              ),
                                                              child: Icon(
                                                                Icons.change_circle,
                                                                color: Colors.blue,
                                                                size: 20,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                );
                                              }),
                                        ],
                                      ),
                                      5.height,
                                       Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Email',
                                            style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
                                          ),
                                          SizedBox(
                                            height: 0.01 * MediaQuery.of(context).size.height,
                                          ),
                                          AppTextField(
                                            decoration: InputDecoration(
                                              hintText: 'example@gmail.com', hintStyle: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey)),
                                            textFieldType: TextFieldType.OTHER,
                                            keyboardType: TextInputType.text,
                                            isPassword: false,
                                            controller: emailCont,
                                            textStyle: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])
                                          ),
                                          SizedBox(
                                            height: 0.01 * MediaQuery.of(context).size.height,
                                          ),
                                        ],
                                      ),
                                      16.height,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Phone',
                                            style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black)
                                          ),
                                          SizedBox(
                                            height: 0.01 * MediaQuery.of(context).size.height,
                                          ),
                                          AppTextField(
                                             decoration: InputDecoration(hintText: '085*****', hintStyle: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey)),
                                            textFieldType: TextFieldType.NUMBER,
                                            keyboardType: TextInputType.number,
                                            suffixIconColor: Colors.blue[900],
                                            isPassword: true,
                                            controller: phoneCont,
                                            textStyle: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])
                                          ),
                                          SizedBox(
                                            height: 0.01 * MediaQuery.of(context).size.height,
                                          ),
                                        ],
                                      ),
                                      16.height,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Password',
                                            style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black)
                                          ),
                                          SizedBox(
                                            height: 0.01 * MediaQuery.of(context).size.height,
                                          ),
                                          AppTextField(
                                             decoration: InputDecoration(hintText: '******', hintStyle: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey)),
                                            textFieldType: TextFieldType.PASSWORD,
                                            keyboardType: TextInputType.visiblePassword,
                                            suffixIconColor: Colors.blue[900],
                                            isPassword: true,
                                            controller: passwordCont,
                                            textStyle: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])
                                          ),
                                          SizedBox(
                                            height: 0.01 * MediaQuery.of(context).size.height,
                                          ),
                                        ],
                                      ),
                                      16.height,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Confirmation Password',
                                            style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black)
                                          ),
                                          SizedBox(
                                            height: 0.01 * MediaQuery.of(context).size.height,
                                          ),
                                          AppTextField(
                                             decoration: InputDecoration(hintText: '******', hintStyle: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey)),
                                            textFieldType: TextFieldType.PASSWORD,
                                            keyboardType: TextInputType.visiblePassword,
                                            suffixIconColor: Colors.blue[900],
                                            isPassword: true,
                                            controller: passwordConfCont,
                                            textStyle: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])
                                          ),
                                          SizedBox(
                                            height: 0.01 * MediaQuery.of(context).size.height,
                                          ),
                                        ],
                                      ),
                                      16.height,
                                      30.height,
                                      GestureDetector(
                                      onTap: (){
                                        if(passwordCont.text.length < 6){
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Minimal Password 6 karakter', style: TextStyle(color: Colors.white)), backgroundColor: Colors.amber,));
                                        }else{
                                          if(passwordCont.text != passwordConfCont.text){
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Konfirmasi Password salah', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red,));
                                          }else{
                                            if(cek() == true){
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email telah digunakan', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red,));
                                            }else{
                                                createUser(emailCont.text, passwordCont.text);
                                            }
                                          }
                                        }
                                      },  
                                      child: Container(width: 200, height: 40, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.blue[900]),
                                      child: Center(child: Text('Register', style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),),),
                                      ),),
                                      15.height,
                                      Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                          TextButton(
                                            onPressed: () async {
                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
                                            },
                                            child: Text(
                                              'Sudah punya akun ? ',
                                              style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.blueGrey[800])
                                            )),
                                        ],),
                                      ),
                                      Center(
                                        child: Text(
                                            'Project UAS Baharudin',
                                            style: GoogleFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey),
                                            textAlign: TextAlign.center,
                                            maxLines: 3),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 100,
                            width: 120,
                            decoration: boxDecorationRoundedWithShadow(30),
                            child: Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Logo_udinus1.jpg/1190px-Logo_udinus1.jpg',
                              height: 80,
                              width: 100,
                              fit: BoxFit.contain,
                            ),
                          )
                        ],
                      ),
                    ),
                    16.height,
                  ],
                ),
              ),
            ),
         ));
  }
}
