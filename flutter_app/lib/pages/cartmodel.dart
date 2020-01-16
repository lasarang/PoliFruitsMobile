import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';


class CartModel extends Model {
  final DocumentReference =  Firestore.instance.document('markers');

  List<Product> cart = [];
  double totalCartValue = 0;

  int get total => cart.length;

  void addProduct(product) {
    int index = cart.indexWhere((i) => i.id == product.id);
    print(index);
    if (index != -1)
      updateProduct(product, product.qty + 1);
    else if( product.qty==0){

    }
    else {
      cart.add(product);
      calculateTotal();
      notifyListeners();
    }
  }

  void removeProduct(product) {
    int index = cart.indexWhere((i) => i.id == product.id);
    cart[index].qty = 0;
    cart.removeWhere((item) => item.id == product.id);
    calculateTotal();
    notifyListeners();
  }

  void updateProduct(product, qty) {
    int index = cart.indexWhere((i) => i.id == product.id);
    cart[index].qty = qty;
    if (cart[index].qty == 1)
      removeProduct(product);

    calculateTotal();
    notifyListeners();
  }

  void clearCart() {
    cart.forEach((f) => f.qty = 0);
    cart = [];
    notifyListeners();
  }

  void calculateTotal() {
    totalCartValue = 0;
    cart.forEach((f) {
      totalCartValue += f.qty;
    });
  }

  actualizarEstadoDispensador(){

    DocumentReference.collection( HomePage.currentDispenserId + '/frutas/')
      .snapshots()
          .listen((snapshot) {
        int tempTotal = snapshot.documents.fold(0, (tot, doc) => tot + doc.data['cantidad']);

        if(tempTotal==0){
          Firestore.instance.document('markers/'+HomePage.currentDispenserId).updateData({"estado": "inactivo"});
        }

      });

  }


  updateFruit(url, cantidad) {
    try {

      DocumentReference.collection(HomePage.currentDispenserId).document('frutas/'+url).updateData({"cantidad": FieldValue.increment(-cantidad)});
      actualizarEstadoDispensador();
    } catch (e) {

      print(e.toString());
    }
  }

  updateFruits(){
    print('Actualizando frutas');
    cart.forEach((f) {
      print(f.title);
      updateFruit(f.url, f.qty);
    });
  }

}

class Product {
  int id;
  String url;
  String title;
  String imgUrl;
  int qty;

  Product({this.id, this.url,this.title, this.qty, this.imgUrl});
}
