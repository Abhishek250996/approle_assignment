import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'homepage.dart';
import 'signin.dart';
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => new _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController _FnameController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _PasswordController = TextEditingController();
  TextEditingController _PhoneController = TextEditingController();
  String _email, _password, _username,_phone;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  SubmitAndValidate() async
  {
    final formState = _formKey.currentState;
    if(formState.validate())
    {
      formState.save();

      try
      {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email:_email, password:_password);
        User user = userCredential.user;
        await FirebaseFirestore.instance.collection("Users").doc(user.uid).set({'UserName':_username, 'PhoneNo':_phone});

        print(userCredential.user.uid);
        print(userCredential.user.email);
        if(user != null)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> Homepage()));
          Fluttertoast.showToast(msg: "Successfull Register");
        }
      }
      catch(e)
      {
        print("Hello + ${e}");
      }
    }
    else{
      _formKey.currentState.reset();
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Invalid Details");
    }

    return "Successfull SignUp";
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return new Scaffold(

    backgroundColor: screenSize.width < 580 ? Colors.white: Colors.black,
      body: SingleChildScrollView(
        child: screenSize.width < 580 ? mobileApp(): webApp(),
      ),
    );
  }

  Widget webApp(    )
  {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width/2,
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(top:20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Center(
                    child: Container(
                      width: 300,
                      height:300,
                      child: Image.asset("assets/images/2.jpg",fit: BoxFit.cover,),

                    ),
                  ),

                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width/2,
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40,20,40,8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(right:30.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> SigninScreen())),
                            child: Text("Sign in !",
                              style: GoogleFonts.crimsonPro(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.red

                              ),),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 100,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:20.0),
                      child: Text("Create Account",
                        style: GoogleFonts.notoSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white

                        ),),
                    ),

                    SizedBox(
                      height: 50,
                    ),

                    Container(
                      width: 500,
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white,
                              width: 4
                          )
                      ),
                      child: Column(
                        children: [

                          SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: Container(
                              width: 450,

                              child: TextFormField(
                              cursorColor: Colors.red,
                              controller: _FnameController,
                              onSaved: (fullname) => _username = fullname,
                              validator: (fullname) => fullname == null ? "Enter a Full Name" : null,
                              style: GoogleFonts.crimsonPro(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                  color: Colors.white

                              ),
                              decoration: InputDecoration(
                                labelText: "Full Name",
                                labelStyle: TextStyle(
                                    color: Colors.grey
                                ),
                              ),

                        ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Container(
                            width: 450,

                            child: TextFormField(
                              cursorColor: Colors.red,
                              controller: _PhoneController,
                              inputFormatters: [new LengthLimitingTextInputFormatter(10)],
                              onSaved: (phone) => _phone = phone,
                              validator: (phone) => phone == null && phone.length < 10 ? "Enter 10 digit Numbers" : null,
                              keyboardType: TextInputType.number,

                              style: GoogleFonts.crimsonPro(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                  color: Colors.white

                              ),

                              decoration: InputDecoration(
                                labelText: "Mobile",
                                labelStyle: TextStyle(
                                    color: Colors.grey
                                ),
                              ),

                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Container(
                            width: 450,

                            child: TextFormField(
                              cursorColor: Colors.red,
                              controller: _EmailController,
                              style: GoogleFonts.crimsonPro(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                  color: Colors.white

                              ),
                              onSaved: (email) => _email = email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (email) => email != null && !EmailValidator.validate(email) ? "Enter a valid email" : null,

                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(
                                    color: Colors.grey
                                ),
                              ),

                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Container(
                            width: 450,

                            child: TextFormField(
                              cursorColor: Colors.red,
                              controller: _PasswordController,
                              onSaved: (password) =>  _password = password,
                              validator: (password) => password != null  && password.length < 8 ? "Enter minimum 8 Characters" : null ,
                              obscureText: true,
                              style: GoogleFonts.crimsonPro(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                  color: Colors.white

                              ),
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(
                                    color: Colors.grey
                                ),

                              ),

                            ),
                          ),
                        ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),

                    Center(
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green
                        ),
                        child: TextButton(onPressed: () async {
                          SubmitAndValidate();
                          if(!_formKey.currentState.validate())
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SignUp Failed")));
                          }
                        },child: Text("Sign Up",style: GoogleFonts.openSans(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),),
                        ),
                      ),)

                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );

  }

  Widget mobileApp()
  {
    return Container(
      child: Column(
        children: [
          ClipPath(
            clipper: WaveClipperOne(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2.1,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(top:20),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right:30.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> SigninScreen())),
                            child: Text("Sign in !",
                              style: GoogleFonts.crimsonPro(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.red

                              ),),
                          ),
                        ),
                      ),
                    ),

                    Center(
                      child: Container(
                        width: 200,
                        height:200,
                        child: Image.asset("assets/images/2.jpg",fit: BoxFit.cover,),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:20.0),
                      child: Text("Create \n Account",
                        style: GoogleFonts.notoSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                            color: Colors.white

                        ),),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40.0,0.0,40.0,0.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    TextFormField(
                      cursorColor: Colors.red,
                      controller: _FnameController,
                      onSaved: (fullname) => _username = fullname,
                      validator: (fullname) => fullname == null ? "Enter a Full Name" : null,
                      style: GoogleFonts.crimsonPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: TextStyle(
                            color: Colors.grey
                        ),
                      ),

                    ),
                    TextFormField(
                      cursorColor: Colors.red,
                      controller: _PhoneController,
                      inputFormatters: [new LengthLimitingTextInputFormatter(10)],
                      onSaved: (phone) => _phone = phone,
                      validator: (phone) => phone == null && phone.length < 10 ? "Enter 10 digit Numbers" : null,
                      keyboardType: TextInputType.number,

                      style: GoogleFonts.crimsonPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),

                      decoration: InputDecoration(
                        labelText: "Mobile",
                        labelStyle: TextStyle(
                            color: Colors.grey
                        ),
                      ),

                    ),
                    TextFormField(
                      cursorColor: Colors.red,
                      controller: _EmailController,
                      style: GoogleFonts.crimsonPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      onSaved: (email) => _email = email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) => email != null && !EmailValidator.validate(email) ? "Enter a valid email" : null,

                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                            color: Colors.grey
                        ),
                      ),

                    ),
                    TextFormField(
                      cursorColor: Colors.red,
                      controller: _PasswordController,
                      onSaved: (password) =>  _password = password,
                      validator: (password) => password != null  && password.length < 8 ? "Enter minimum 8 Characters" : null ,
                      obscureText: true,
                      style: GoogleFonts.crimsonPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                            color: Colors.grey
                        ),

                      ),

                    ),
                    SizedBox(
                      height: 40,
                    ),

                    Center(
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green
                        ),
                        child: TextButton(onPressed: () async {
                          SubmitAndValidate();
                          if(!_formKey.currentState.validate())
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SignUp Failed")));
                          }
                        },child: Text("Sign Up",style: GoogleFonts.openSans(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),),
                        ),
                      ),)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
