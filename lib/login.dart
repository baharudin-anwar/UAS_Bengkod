import 'package:aan_uas/home.dart';
import 'package:aan_uas/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';



class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 TextEditingController emailCont = TextEditingController();
 TextEditingController passwordCont = TextEditingController();
 static FirebaseAuth _auth = FirebaseAuth.instance;
 List allUser =[];


  @override
  void initState() {
    super.initState();
  }


  static Future createUser(String email, String pass) async {
    final result = await
       _auth.createUserWithEmailAndPassword(email: email, password: pass);
    return result;
  }



  
  @override
  Widget build(BuildContext context) {

   void getDetailData() async {
        DatabaseReference databaseReference =
            FirebaseDatabase.instanceFor(app: Firebase.app(),
          databaseURL:
              'https://aan-uas-default-rtdb.asia-southeast1.firebasedatabase.app/').ref().child('users');

          databaseReference.onValue.listen((event) {
            DataSnapshot dataSnapshot = event.snapshot;
            Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;

              values.forEach((key, values) {
                if(values['email'] == emailCont.text){
                  userDetail = {
                    'key': key,
                    'email': values['email'],
                    'phone': values['phone'],
                    'imgProfile': values['imgProfile'],
                  };
                }
                setState(() {
                  print(allUser);
                });
              });
          });

      }

  Future signInWithEmail(String email, String pass) async {
    final result = await
      _auth.signInWithEmailAndPassword(email: email, password: pass);
      print(result.additionalUserInfo);
       if(result.additionalUserInfo == null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login gagal !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red,));
        return false;
       }else{
        emailCont.clear();
        passwordCont.clear();
        emailUserSesi=email;
        getDetailData();
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login berhasil !', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green,));
          return true;
       }
  }

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
                        Text("Welcome Back", style: GoogleFonts.aBeeZee(fontSize: 28, fontWeight: FontWeight.bold)),
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
                                          SizedBox(
                                            height: 0.1 *
                                                MediaQuery.of(context).size.height,
                                          ),
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
                                          30.height,
                                          GestureDetector(
                                          onTap: (){
                                            signInWithEmail(emailCont.text, passwordCont.text);
                                          },  
                                          child: Container(width: 200, height: 40, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.blue[900]),
                                          child: Center(child: Text('Login', style: GoogleFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),),),
                                          ),),
                                          15.height,
                                          Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                              TextButton(
                                                onPressed: () async {
                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>RegisterScreen()));
                                                },
                                                child: Text(
                                                  'Belum punya akun ? ',
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
