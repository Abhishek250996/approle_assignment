import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../products.dart';



class Add_Products extends StatefulWidget {
  @override
  _Add_ProductsState createState() => new _Add_ProductsState();

}

class _Add_ProductsState extends State<Add_Products> {

  ProductService productService = ProductService();
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  List<String> selectedSizes = <String>[];
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  File _image;
  File orgImage;
  bool isLoading= false;
  bool isSale= false;
  bool isFeatured=false;
  var textVal = "Switch is off";



  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    print(_image?.lengthSync());
    print(orgImage?.lengthSync());
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Product"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child : screenSize.width < 580 ? mobileApp(): webApp(),
      ),
    );
  }


  void _selectImage(ImageSource  source) async
  {
    var image = await ImagePicker.pickImage(source: source);


    //Cropping the image
//
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
   //   aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      maxWidth: 512,
      maxHeight: 512,
    );

//    //Compress the image

    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path,image.path,
      quality: 50,
    );

    setState(() {
      _image = result;
      orgImage = croppedFile;
      print(_image.lengthSync());
      print(orgImage.length());

    });
  }



  Widget _displayChild1() {
    if(_image == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
            14.0, 40.0, 14.0, 40.0),
        child: Icon(Icons.add,color: Colors.white,size: 50,)
      );
    }
      else {
      return Image.file(_image,fit: BoxFit.cover,height: 270,width: 290,);
    }
  }

  void ValidateAndUpload() async{
    if(_formKey.currentState.validate())
      {
        setState(()=> isLoading=true);
        if(_image != null)
          {
            String imageUrl;

                final FirebaseStorage storage = FirebaseStorage.instance;
                final String picture1 ="1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
                StorageUploadTask task1 = storage.ref().child(picture1).putFile(_image);



                StorageTaskSnapshot snapshot1 = await task1.onComplete.then((snapshot) => snapshot);

                task1.onComplete.then((snapshot3) async {
                  imageUrl = await snapshot1.ref.getDownloadURL();



                  productService.uploadProduct(
                    productName: productNameController.text,
                    price: double.parse(priceController.text),
                    images: imageUrl,
                    description: descriptionController.text,



                  );
                  _formKey.currentState.reset();
                  setState(() => isLoading = false);
                  Fluttertoast.showToast(msg: "Product added");
                  });

          }
      else
        {
          setState(()=> isLoading=false);
          Fluttertoast.showToast(msg: "All images must be provided");
        }

  }
                }


  Widget webApp(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isLoading ? CircularProgressIndicator(
            backgroundColor: Colors.red,

          ): Column(

            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white
                      )
                  ),
                  child: OutlineButton(
                    onPressed: ()
                    =>  _selectImage(ImageSource.gallery),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.8),
                    ),

                    child: _displayChild1(),


                  ),
                ),
              ),
              Text("Available Sizes",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.white),),


              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text("New Size :",style: TextStyle
                                  (fontSize: 12.0,
                                    fontWeight: FontWeight.bold,color: Colors.white
                                ),),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("${_image == null ? "0": _image.lengthSync()}",style: TextStyle
                                  (fontSize: 12.0,
                                    fontWeight: FontWeight.bold,color: Colors.white
                                )),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Container(
                                child: Row(
                                  children: [
                                    Text("Old Size :",style: TextStyle
                                      (fontSize: 12.0,
                                        fontWeight: FontWeight.bold
                                        ,color: Colors.white
                                    ),),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("${orgImage == null ? "0" : orgImage.lengthSync()}",style: TextStyle
                                      (fontSize: 12.0,
                                        fontWeight: FontWeight.bold,color: Colors.white
                                    )),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width/3,
                        child: TextFormField(
                          controller: productNameController,
                          decoration: InputDecoration(
                            hintText: "ProductName",
                            hintStyle: TextStyle
                              (fontSize: 16.0,
                                fontWeight: FontWeight.bold,color: Colors.white
                            ),
                            enabledBorder: new UnderlineInputBorder( borderSide: new BorderSide(color: Colors.white), ),

                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "You must enter the product Name";
                            }
                            else if (value.length > 10) {
                              return "Product Name cant have more then 10 Letters";
                            }

                            return null;},
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width/3,
                        child: TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            hintText: "Description",
                            hintStyle: TextStyle
                              (fontSize: 16.0,
                                fontWeight: FontWeight.bold,color: Colors.white
                            ),
                            enabledBorder: new UnderlineInputBorder( borderSide: new BorderSide(color: Colors.white), ),

                          ),
                          validator: (value) {
                            if(value.isEmpty)
                            {
                              return "you must be enter the description ";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width/3,
                        child: TextFormField(
                          //       initialValue: '0.00',
                          controller: priceController,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                            hintText: "Price",
                            hintStyle: TextStyle
                              (fontSize: 16.0,
                                fontWeight: FontWeight.bold,color: Colors.white
                            )
                            ,
                            enabledBorder: new UnderlineInputBorder( borderSide: new BorderSide(color: Colors.white), ),
                          ),
                          validator: (value) {
                            if(value.isEmpty)
                            {
                              return "you must be enter the price";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),


                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FlatButton(
                  textColor: white,
                  child: Text("Add Product",
                    style: TextStyle
                      (fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: (){ValidateAndUpload();},
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget mobileApp(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isLoading ? CircularProgressIndicator(
            backgroundColor: Colors.red,

          ): Column(

            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white
                      )
                  ),
                  child: OutlineButton(
                    onPressed: ()
                    =>  _selectImage(ImageSource.gallery),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.8),
                    ),

                    child: _displayChild1(),


                  ),
                ),
              ),
              Text("Available Sizes",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.white),),

              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Row(
                          children: [
                            Text("New Size :",style: TextStyle
                              (fontSize: 12.0,
                                fontWeight: FontWeight.bold,color: Colors.white
                            ),),
                            SizedBox(
                              width: 10,
                            ),
                            Text("${_image == null ? "0": _image.lengthSync()}",style: TextStyle
                              (fontSize: 12.0,
                                fontWeight: FontWeight.bold,color: Colors.white
                            )),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Container(
                          child: Row(
                            children: [
                              Text("Old Size :",style: TextStyle
                                (fontSize: 12.0,
                                  fontWeight: FontWeight.bold
                                  ,color: Colors.white
                              ),),
                              SizedBox(
                                width: 10,
                              ),
                              Text("${orgImage == null ? "0" : orgImage.lengthSync()}",style: TextStyle
                                (fontSize: 12.0,
                                  fontWeight: FontWeight.bold,color: Colors.white
                              )),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    hintText: "ProductName",
                    hintStyle: TextStyle
                      (fontSize: 16.0,
                        fontWeight: FontWeight.bold,color: Colors.white
                    ),
                    enabledBorder: new UnderlineInputBorder( borderSide: new BorderSide(color: Colors.white), ),

                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "You must enter the product Name";
                    }
                    else if (value.length > 10) {
                      return "Product Name cant have more then 10 Letters";
                    }

                    return null;},
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle
                      (fontSize: 16.0,
                        fontWeight: FontWeight.bold,color: Colors.white
                    ),
                    enabledBorder: new UnderlineInputBorder( borderSide: new BorderSide(color: Colors.white), ),

                  ),
                  validator: (value) {
                    if(value.isEmpty)
                    {
                      return "you must be enter the product name";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  //       initialValue: '0.00',
                  controller: priceController,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    hintText: "Price",
                    hintStyle: TextStyle
                      (fontSize: 16.0,
                        fontWeight: FontWeight.bold,color: Colors.white
                    )
                    ,
                    enabledBorder: new UnderlineInputBorder( borderSide: new BorderSide(color: Colors.white), ),
                  ),
                  validator: (value) {
                    if(value.isEmpty)
                    {
                      return "you must be enter the product name";
                    }
                    return null;
                  },
                ),
              ),



              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FlatButton(
                  textColor: white,
                  child: Text("Add Product",
                    style: TextStyle
                      (fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: (){ValidateAndUpload();},
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
