import 'package:assignment/fetchdata/ModelClass.dart';
import 'package:assignment/fetchdata/SingleListFood.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewProduct extends StatefulWidget {
  @override
  _ViewProductState createState() => new _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {

  bool loadingPrdoucts = false;
  List<FoodModel> foodList = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<FoodModel> foodMoreList = [];
  List<DocumentSnapshot> docssnapshot;
  ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> products = []; // stores fetched products
  bool isLoading = false; // track if products fetching
  bool hasMore = true; // flag for more products available or not
  int documentLimit = 10; // documents to be fetched per request
  DocumentSnapshot lastDocument; // flag for last document from where next 10 records to be fetched


  @override
  void initState() {
    super.initState();
    getProducts();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getProducts();
      }
    });
  }


  getProducts() async {
    if (!hasMore) {
      print('No More Products');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await firestore
          .collection('products')
          .orderBy('name')
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await firestore
          .collection('products')
          .orderBy('name')
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .get();
      print("helllllo");
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    products.addAll(querySnapshot.docs);
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text("View Product"),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,

          child:   Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: products.length == 0
                    ? Center(child:CircularProgressIndicator())
                    :
                Center(
                  child: RefreshIndicator(
                    onRefresh: (){
                      return Future.delayed(Duration(seconds: 1),
                              (){
                            getProducts();
                          });
                    },
                    child: ListView.builder(
                      itemCount: products.length,
                      controller: _scrollController,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: ( context, index) {
                        return SinglelistFood(
                            name: products[index].data()['name'],
                            description: products[index].data()['description'],
                            image: products[index].data()['image'],
                            id: products[index].data()['id'],
                            price: products[index].data()['price']
                        );
                      },

                    ),
                  ),
                ),
              ),

              isLoading
                  ? Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(5),
                color: Colors.yellowAccent,
                child: Text(
                  'Loading',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : Container()
            ],
          ),

    ),
    );
  }

}