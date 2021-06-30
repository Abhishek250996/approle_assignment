import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assignment/screens/signup.dart';
import 'homepage.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => new _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _PasswordController = TextEditingController();
  String _email, _password;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  SubmitAndValidate()async
  {
    final formState = _formKey.currentState;

    if(formState.validate())
    {
      formState.save();

      try{

        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        User user = userCredential.user;

        if(user != null)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> Homepage()));
          Fluttertoast.showToast(msg: "SignIn Succesfull");
        }
      }
      catch(e) {}
    }
    else
    {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "SignIn Failed");
      _formKey.currentState.reset();
    }

    return "SignIn Successfull";
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

  Widget webApp(){
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
              padding: const EdgeInsets.only(top:8.0),
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  child:    Image.asset("assets/images/1.jpg",fit: BoxFit.cover,)
                  ,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width/2,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40,20,40,8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right:30.0),
                      child: Container(
                        height: 20,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen())),
                            child: Text("Sign up !",
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
                      padding: const EdgeInsets.only(left:10.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Welcome Back!...",
                          style: GoogleFonts.notoSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 45,
                              color: Colors.white

                          ),),
                      ),
                    ),

                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: 500,
                      height: 250,
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
                            padding: const EdgeInsets.only(left: 10,right: 10),                            child: Container(
                              width: 450,
                              child: TextFormField(
                                controller: _EmailController,
                                cursorColor: Colors.red,
                                onSaved: (email) =>  _email = email,
                                validator: (email) => email != null && !EmailValidator.validate(email) ? "Enter a valid email" : null,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.white

                                ),
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
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
                                controller: _PasswordController,
                                cursorColor: Colors.red,
                                obscureText: true,
                                onSaved: (password) =>  _password = password,
                                validator: (password) => password != null && password.length < 8 ? "Enter minimum 8 Characters" : null,
                                keyboardType: TextInputType.emailAddress,
                                style: GoogleFonts.crimsonPro(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.white

                                ),
                                decoration: InputDecoration(

                                  labelText: "Password",
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  ),

                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SignIn Failed")));
                          }
                        },child: Text("Sign In",style: GoogleFonts.openSans(
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
  Widget mobileApp(){
    return Column(
      children: [
        ClipPath(
          clipper: WaveClipperOne(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/1.8,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(top:20.0),
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
                          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen())),
                          child: Text("Sign up !",
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
                    height: 50,
                  ),Center(
                    child: Container(
                      width: 200,
                      height: 180,
                      child:    Image.asset("assets/images/1.jpg",fit: BoxFit.cover,)
                      ,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:10.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text("Welcome  \n Back",
                        style: GoogleFonts.notoSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                            color: Colors.white

                        ),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40,20,40,8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0,0,8.0,0),
                    child: TextFormField(
                      controller: _EmailController,
                      cursorColor: Colors.red,
                      onSaved: (email) =>  _email = email,
                      validator: (email) => email != null && !EmailValidator.validate(email) ? "Enter a valid email" : null,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.crimsonPro(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.black

                      ),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),

                      ),
                    ),
                  ),

                  TextFormField(
                    controller: _PasswordController,
                    cursorColor: Colors.red,
                    obscureText: true,
                    onSaved: (password) =>  _password = password,
                    validator: (password) => password != null && password.length < 8 ? "Enter minimum 8 Characters" : null,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.crimsonPro(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black

                    ),
                    decoration: InputDecoration(

                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),

                    ),
                  ),
                  SizedBox(
                    height: 30,
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SignIn Failed")));
                        }
                      },child: Text("Sign In",style: GoogleFonts.openSans(
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
    );
  }
}
