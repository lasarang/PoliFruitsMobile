import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class DispenserScreen extends StatefulWidget{


  @override
  _DispenserScreenState createState() => _DispenserScreenState();

}

class _DispenserScreenState extends State<DispenserScreen> {
  final LatLng campus = LatLng(-2.148755, -79.962358);

  Completer<GoogleMapController> _controller = Completer();
  Position position;

  static const LatLng _center = const LatLng(-2.148755, -79.962358);

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Future<void> getPermission() async{
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if(permission == PermissionStatus.denied){
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }

    var geolocator = Geolocator();
    
    GeolocationStatus geolocationStatus = 
        await geolocator.checkGeolocationPermissionStatus();
    
    switch(geolocationStatus){
      case GeolocationStatus.denied:
        showToast('Access denied');
        break;
      case GeolocationStatus.disabled:
        showToast('Disabled');
        break;
      case GeolocationStatus.restricted:
        showToast('Restricted');
        break;
      case GeolocationStatus.unknown:
        showToast('Unknown');
        break;
      case GeolocationStatus.granted:
        showToast('Acces Granted');
        _getCurrentLocation();

    }
  }

  void _getCurrentLocation() async{
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      position = res;
     // _child = _mapWidget();
    });
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }

  void showToast(message){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor:  Colors.white,
      fontSize: 16.0
    );
  }


  @override
  void initState(){
    getPermission();
    super.initState();
    poblarSitios();
  }

  void initMarker(request, requestId){
    var colorMarker;
    if(request['estado']==("activo")) {
      colorMarker =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);

      var markerIdVal = requestId;
      final MarkerId markerId = MarkerId(markerIdVal);

      final Marker marker = Marker(
          markerId: markerId,
          position:
          LatLng(request['coords'].latitude, request['coords'].longitude),
          infoWindow:
          InfoWindow(
              title: request['title'],
              snippet: request['rating'],

              onTap: () {
                HomePage.currentDispenserId = request['id'];
                print("id asignado: " + HomePage.currentDispenserId);

                HomePage.title =
                    request['title'] + "\n\t\t\t\t" + request['rating'];

                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => HomePage()),
                );
              }

          ),
          icon: colorMarker
      );

      setState(() {
        markers[markerId] = marker;
        print(markerId);
      });
    }
  }

  /*
  Set<Marker> _createMarkers(){

    var tmp= Set<Marker>();
    tmp.add(
      Marker(
          markerId: MarkerId("fcv"),
          position: LatLng(-2.151918, -79.957218),
          infoWindow: InfoWindow(
            title: 'Dispensador FCV',
            snippet: '5 Star Rating',
              onTap: () {

              }
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage()),
                );

              }
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

*/


  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    //_setStyle(controller);

  }

  Future<void> _goToCampus() async{
    final GoogleMapController controller= await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _center,
      zoom: 15,
    )));
  }


  poblarSitios() {
    /*
    Firestore.instance.collection('markers')
        .getDocuments().then((docs){
      if(docs.documents.isNotEmpty){
        for(int i=0; i<docs.documents.length; i++){
          
          print("dentro del firestore");
          print(docs.documents[i]['id']);

          initMarker(docs.documents[i].data, docs.documents[i].documentID);

        }

      }

    });
    */

    Firestore.instance.collection('markers')
        .snapshots().listen((docs) {
      if (docs.documents.isNotEmpty) {
        //_products.clear();
        markers.clear();

        for (int i = 0; i < docs.documents.length; i++) {

          print("dentro del firestore");
          print(docs.documents[i]['id']);

          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });


  }


  @override
  Widget build(BuildContext context) {
    return
     Scaffold(
            appBar: AppBar(
              title: Text('PoliFruits'),
              backgroundColor: Colors.blue,
            ),
            body:
            Stack(
              children: <Widget>[

                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 15,
                  ),
                  mapType: _currentMapType,
                  markers: Set<Marker>.of(markers.values),
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
                          heroTag: "cambioVista",
                          onPressed: _onMapTypeButtonPressed,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.map, size: 36.0),
                        ),
                        SizedBox(height: 16.0),

                        FloatingActionButton(
                          heroTag: "regresarCampus",
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


          );
  }


}

