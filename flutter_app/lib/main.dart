import 'package:flutter/material.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'pages/cartmodel.dart';
import 'pages/cartpage.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(

      MyApp(
        model: CartModel(),
      ));

}

class MyApp extends StatelessWidget {
  final CartModel model;
  const MyApp({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return ScopedModel<CartModel>(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(primaryColor: Colors.blue),
        home: LoginPage(),
        routes: {'/cart': (context) => CartPage()},
      ),
    );


    /*



    if (isIos){
      return ScopedModel<CartModel>(
        model: model,
        child: CupertinoApp(
          debugShowCheckedModeBanner: false,

          home: LoginPage(),
          routes: {'/cart': (context) => CartPage()},
        ),
      );
    }else{
      return ScopedModel<CartModel>(
        model: model,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: ThemeData(primaryColor: Colors.blue),
          home: LoginPage(),
          routes: {'/cart': (context) => CartPage()},
        ),
      );
    }
    */


  }
}



/*

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(-2.148755, -79.962358);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;


  Set<Marker> _createMarkers(){
    var tmp= Set<Marker>();
    tmp.add(
      Marker(
          markerId: MarkerId("FCV"),
          position: LatLng(-2.151918, -79.957218),
          infoWindow: InfoWindow(
            title: 'Dispensador FCV',
            snippet: '5 Star Rating',
          )

      ),
    );
    tmp.add(
      Marker(
          markerId: MarkerId("biblioteca"),
          position: LatLng(-2.146910, -79.966094),
          infoWindow: InfoWindow(
            title: "Dispensador Biblioteca",
            snippet: '4 Star Rating',
          )
      ),
    );

    tmp.add(
      Marker(
          markerId: MarkerId("fimcbor"),
          position: LatLng(-2.146428, -79.963259),
          infoWindow: InfoWindow(
            title: "Dispensador FIMCBOR",
            snippet: '4 Star Rating',
          )
      ),
    );
    tmp.add(
      Marker(
          markerId: MarkerId("fmcp"),
          position: LatLng(-2.144723, -79.965780),
          infoWindow: InfoWindow(
            title: "Dispensador FIMCP",
            snippet: '4 Star Rating',
          )
      ),
    );

    tmp.add(
      Marker(
          markerId: MarkerId("celex"),
          position: LatLng(-2.148443, -79.967411),
          infoWindow: InfoWindow(
            title: "Dispensador CELEX",
            snippet: '3 Star Rating',
          )
      ),
    );

    tmp.add(
      Marker(
          markerId: MarkerId("fict"),
          position: LatLng(-2.148443, -79.967411),
          infoWindow: InfoWindow(
            title: "Dispensador FICT",
            snippet: '4 Star Rating',
          )
      ),
    );

    tmp.add(
      Marker(
          markerId: MarkerId("fiec"),
          position: LatLng(-2.144201, -79.967703),
          infoWindow: InfoWindow(
            title: "Dispensador FIEC",
            snippet: '5 Star Rating',
          )
      ),
    );

    tmp.add(
      Marker(
          markerId: MarkerId("fadcom"),
          position: LatLng(-2.143333, -79.962167),
          infoWindow: InfoWindow(
            title: "Dispensador FADCOM",
            snippet: '5 Star Rating',
          )
      ),
    );

    tmp.add(
      Marker(
          markerId: MarkerId("fcsh"),
          position: LatLng(-2.147354, -79.967796),
          infoWindow: InfoWindow(
            title: "Dispensador FCSH",
            snippet: '4 Star Rating',
          ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    tmp.add(
      Marker(
          markerId: MarkerId("fepol"),
          position: LatLng(-2.145835, -79.966239),
          infoWindow: InfoWindow(
            title: "Dispensador FEPOL",
            snippet: '4 Star Rating',
          ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),

      ),
    );


    return tmp;
  }


  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId("FCV"),
          position: LatLng(-2.151918, -79.957218),
          infoWindow: InfoWindow(
            title: 'Dispensador FCV',
            snippet: '5 Star Rating',
          ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),

      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<void> _goToCampus() async{
    final GoogleMapController controller= await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _center,
      zoom: 15,
      )));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('PoliFruits'),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15,
              ),
              mapType: _currentMapType,
              markers: _createMarkers(),  //_markers,
              myLocationEnabled: true,
              onCameraMove: _onCameraMove,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget> [
                    FloatingActionButton(
                      onPressed: _onMapTypeButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.map, size: 36.0),
                    ),
                    SizedBox(height: 16.0),

                    FloatingActionButton(
                      onPressed:_goToCampus,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.location_city, size: 36.0),
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

*/