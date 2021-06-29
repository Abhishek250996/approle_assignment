import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AddProducts.dart';
import 'signin.dart';
import 'viewproduct.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => new _HomepageState();
}

class _HomepageState extends State<Homepage> {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  _signOut() async {
  await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: (){
          showDialog(context: context,
              builder: (context)=> AlertDialog(
                title: Text("QuizTime"),
                content: Text("You Can't go back.."),
                actions: [
                  TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Ok"))
                ],
              ));

          return null;
        },
      child: new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Assignment"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right:10.0),
              child: IconButton(color: Colors.white,onPressed: (){
              _signOut().whenComplete(
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SigninScreen()))
              );
                       },icon: Icon(Icons.logout,size: 20,),),
            )
          ],
        ),
        body: Container(
          child: screenSize.width < 580 ? mobileApp(): webApp(),
        ),
      ),
    );
  }

Widget webApp(){
    return  Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(minWidth: 150,onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewProduct()));

          },child: Text("View Product",style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold
          ),),
            color: Colors.black,),


          SizedBox(
            height: 50,
          ),
          MaterialButton(
              minWidth: 150,onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_Products()));

          },child: Text("Add prdouct",style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold
          ),),
              color: Colors.black)
        ],
      ),
    );
}
Widget mobileApp(){
  return  Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(minWidth: 150,onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewProduct()));

        },child: Text("View Product",style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold
        ),),
          color: Colors.black,),

        SizedBox(
          height: 50,
        ),
        MaterialButton(
            minWidth: 150,onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Add_Products()));

        },child: Text("Add prdouct",style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold
        ),),
            color: Colors.black)
      ],
    ),
  );
}
}
