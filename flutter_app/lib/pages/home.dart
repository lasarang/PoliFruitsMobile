import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'cartmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatefulWidget {
  static var currentDispenserId = "";
  static var title="";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _products = [ /*

    Product(
        id: 1,
        title: "Manzana",
        imgUrl: "https://img.icons8.com/plasticine/2x/apple.png",
        qty: 20),
    Product(
        id: 2,
        title: "Guineo",
        imgUrl: "https://img.icons8.com/cotton/2x/banana.png",
        qty: 30),
    Product(
        id: 3,
        title: "Naranja",
        imgUrl: "https://img.icons8.com/cotton/2x/orange.png",
        qty: 40),
    Product(
        id: 4,
        title: "Sandia",
        imgUrl: "https://img.icons8.com/cotton/2x/watermelon.png",
        qty: 15),
    Product(
        id: 5,
        title: "Aguacate",
        imgUrl: "https://img.icons8.com/cotton/2x/avocado.png",
        qty: 23),

*/
  ];

  void addFruit(request, url ,requestId) {

    if(request['cantidad']!=0){
      final Product fruta = Product(
          id: requestId,
          url: url,
          title: request['nombre'],
          imgUrl: request['imgUrl'],
          qty: request['cantidad']
      );

      print(_products);
      setState(() {
        _products.add(fruta);
      });
    }

  }

  @override
  void initState() {
    print("dentro de initState");
    super.initState();
    poblarFrutas();

  }

  poblarFrutas() {

    /*
    Firestore.instance.collection('markers/' + HomePage.currentDispenserId + '/frutas/')
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          print("dentro del firestore");
          print(docs.documents[i]['nombre']);

          addFruit(docs.documents[i].data, docs.documents[i].documentID, i);
        }
      }
    });
    */


    Firestore.instance.collection('markers/' + HomePage.currentDispenserId + '/frutas/')
      .snapshots().listen((docs) {
      if (docs.documents.isNotEmpty) {
        _products.clear();

        for (int i = 0; i < docs.documents.length; i++) {
          print("dentro del firestore");

          print(docs.documents[i]['nombre']);


          addFruit(docs.documents[i].data, docs.documents[i].documentID, i);
        }
      }
    });



  }




  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.indigo[50],
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(HomePage.title),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {


              ScopedModel.of<CartModel>(context).clearCart();


              Navigator.pop(context);

            },
          ),

          actions: <Widget>[

            IconButton(
              icon: Icon(Icons.developer_board),
              onPressed: () => Navigator.pushNamed(context, '/cart'),
            ),




          ],
        ),
        body:
        GridView.builder(
          padding: EdgeInsets.all(7.0),
          itemCount: _products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.05),
          itemBuilder: (context, index) {
            return ScopedModelDescendant<CartModel>(
                builder: (context, child, model) {
                  return Card(child: Column(children: <Widget>[
                    Image.network(
                      _products[index].imgUrl, height: 90, width: 90,),
                    Text(_products[index].title,
                      style: TextStyle(fontWeight: FontWeight.bold),),
                    Text("Disponible: " + _products[index].qty.toString()),
                    OutlineButton(
                        child: Text("Agregar"),
                        borderSide: BorderSide(
                        color: Colors.black, width: 1.0,style: BorderStyle.solid),

                        onPressed: () => model.addProduct(_products[index]))
                  ])

                  );
                });
          },
        ),

        // ListView.builder(
        //   itemExtent: 80,
        //   itemCount: _products.length,
        //   itemBuilder: (context, index) {
        //     return ScopedModelDescendant<CartModel>(
        //         builder: (context, child, model) {
        //       return ListTile(
        //           leading: Image.network(_products[index].imgUrl),
        //           title: Text(_products[index].title),
        //           subtitle: Text("\$"+_products[index].price.toString()),
        //           trailing: OutlineButton(
        //               child: Text("Add"),
        //               onPressed: () => model.addProduct(_products[index])));
        //     });
        //   },
        // ),

      );
  }
}
