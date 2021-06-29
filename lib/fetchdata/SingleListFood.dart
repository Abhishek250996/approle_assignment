import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SinglelistFood extends StatefulWidget {

   String id;
   String name;
   String image;
   String description;
   double price;

  SinglelistFood({@required this.id,@required this.description,@required this.price, @required this.name,@required  this.image});

  @override
  _SinglelistFoodState createState() => _SinglelistFoodState();
}

class _SinglelistFoodState extends State<SinglelistFood> {
  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Container(
      child: screenSize.width < 580 ? mobileApp(): webApp(),
    );
  }

  Widget  webApp(){
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.image)
                    )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width:  200,
                child: Column
                  (
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.name,
                      style: GoogleFonts.crimsonPro(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,

                      ),),
                    SizedBox(height: 10,),
                    Text(" \u20B9 ${widget.price}",
                      style: GoogleFonts.crimsonPro(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,

                      ),),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget  mobileApp(){
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.image)
                  )
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width:  200,
              child: Column
                (
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.name,
                    style: GoogleFonts.crimsonPro(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,

                    ),),
                  SizedBox(height: 10,),
                  Text(" \u20B9 ${widget.price}",
                    style: GoogleFonts.crimsonPro(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,

                    ),),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
