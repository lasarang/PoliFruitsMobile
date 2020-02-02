import 'package:flutter/material.dart';
import 'package:flutter_app/pages/DispenserScreen.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:scoped_model/scoped_model.dart';
import 'cartmodel.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class CartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartPageState();
  }
}

class _CartPageState extends State<CartPage> {
   final _calificacionController = TextEditingController();


    updateCalificacion(calificacion){
      print(calificacion);
      Firestore.instance.document('markers/'+HomePage.currentDispenserId).updateData({"rating": calificacion});
    }

    showRateWindow(){
      final regexp = RegExp(r'[1-5]');
      final match = regexp.firstMatch(HomePage.title);
      final stars = match.group(0);

      EasyDialog(
          cornerRadius: 15.0,
          fogOpacity: 0.1,
          width: 370,
          height: 220,
          contentPadding:
          EdgeInsets.only(top: 12.0),

          // Needed for the button design
          contentList: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 30.0)),
                  Text(HomePage.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaleFactor: 1.0,
                  ),
                  Padding(padding: EdgeInsets.only(left: 10.0)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < int.parse(stars) ? Icons.star : Icons.star_border,
                        size: 30.0,
                        color: Colors.greenAccent,
                      );
                    }),
                  )],),
            ),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _calificacionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Escriba una calificación e.g. '[1-5] Star Rating'",
                    ),
                  ),
                )),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0))),
              child: FlatButton(
                onPressed: () {
                  updateCalificacion(_calificacionController.text);

                  //Navigator.of(context).pop();
                 // Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );

                },
                child: Text("Calificar",
                  textScaleFactor: 1.3,
                ),),
            ),
          ]).show(context);

    }

    @override
    void initState() {
      super.initState();
    }



  _showConfirmationScreen(BuildContext context) async {

    var alert = AlertDialog(
      content: Text("¿Está seguro que desea canjear las frutas?"),

      actions: <Widget>[
        FlatButton(
            child: Text('Simon tengo hambre!'),
            //
            onPressed: () {
              Navigator.pop(context);
              ScopedModel.of<CartModel>(context,
                  rebuildOnChange: true)
                  .updateFruits();
              ScopedModel.of<CartModel>(context).clearCart();

              showRateWindow();

            })
      ],
    );

    showDialog(context: context, child: alert);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
       Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text("Canasta"),

            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {


               // Navigator.pop(context);


                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );



              },
            ),

            actions: <Widget>[
              FlatButton(
                  child: Text(
                    "Clear",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => ScopedModel.of<CartModel>(context).clearCart())
            ],
          ),
          body: ScopedModel.of<CartModel>(context, rebuildOnChange: true)
                      .cart
                      .length ==
                  0
              ? Center(
                  child: Text("No items in Cart"),
                )
              : Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: ScopedModel.of<CartModel>(context,
                                rebuildOnChange: true)
                            .total,
                        itemBuilder: (context, index) {
                          return ScopedModelDescendant<CartModel>(
                            builder: (context, child, model) {
                              return ListTile(
                                title: Text(model.cart[index].title),
                                subtitle: Text(model.cart[index].qty.toString() +" unidades"),
                                trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          if(model.cart[index].qty !=0){
                                            model.updateProduct(model.cart[index],
                                                model.cart[index].qty + 1);
                                          }
                                          //model.updateProduct(model.cart[index],
                                          //    model.cart[index].qty + 1);
                                          // model.removeProduct(model.cart[index]);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          model.updateProduct(model.cart[index],
                                              model.cart[index].qty - 1);
                                          // model.removeProduct(model.cart[index]);
                                        },
                                      ),
                                    ]),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: RaisedButton(
                          color: Colors.yellow[900],
                          textColor: Colors.white,
                          elevation: 0,
                          child: Text("CANJEAR FRUTAS"),
                          onPressed: () {
                            _showConfirmationScreen(context);

                          },
                        ))
                  ])));

  }


}
