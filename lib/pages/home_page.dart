import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_project/shared/constant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:ui' as ui;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController? googleMapController;
  Set<Marker> myMarkers = {};
  Set<Circle> myCircles = {};
  Set<Polygon> myPolygons = {};
  Set<Polyline> myPolyline = {};

  @override
  void initState() {
    super.initState();
    setAndChangeMarkerFun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: myMarkers,
        circles: myCircles,
        polygons: myPolygons,
        polylines: myPolyline,
        zoomControlsEnabled: false,
        initialCameraPosition: const CameraPosition(target: AppAssets.myLocation, zoom: 15),
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
          mapStyleFun();
          setCirclesFun();
          setPolygonFun();
          setPolylineFun();
        },
      ),
    );
  }

  /// TODO: change map style
  Future<void> mapStyleFun() async {
    final nightMapStyle = await DefaultAssetBundle.of(context).loadString(AppAssets.mapStyle);
    googleMapController?.setMapStyle(nightMapStyle);
  }

  ///TODO: Circles section
  void setCirclesFun() {
    final circle = Circle(
      radius: 700,
      strokeWidth: 2,
      strokeColor: Colors.white,
      circleId: const CircleId('myCircle'),
      fillColor: Colors.black.withOpacity(0.5),
      center: const LatLng(31.04074085416333, 31.378596021527475),
    );
    myCircles.add(circle);
  }

  ///TODO: Polyline section
  void setPolylineFun() {
    const polyline = Polyline(
      width: 4,
      color: Colors.white,
      polylineId: PolylineId('myPolyline'),
      points: [
        LatLng(31.0468597483121, 31.37405208673443),
        LatLng(31.047639702414667, 31.37993915811558),
        LatLng(31.050005022230906, 31.380015095956757),
        LatLng(31.050128688832725, 31.37517939017748),
      ],
    );
    myPolyline.add(polyline);
  }

  ///TODO: Polygons section
  void setPolygonFun() {
    const polygon = Polygon(
      strokeWidth: 4,
      strokeColor: Colors.white,
      fillColor: Colors.transparent,
      polygonId: PolygonId('myPolygon'),
      points: [
        LatLng(31.034332586071987, 31.381275230063025),
        LatLng(31.032898452532923, 31.38445096531071),
        LatLng(31.030839146090955, 31.379730277780364),
      ],
    );
    myPolygons.add(polygon);
  }

  /// TODO: change map default marker
  void setAndChangeMarkerFun() async {
    ///TODO: with change Size
    final myMarkerIcon = BitmapDescriptor.fromBytes(
      await changeMarkerSizeFun(markerImage: AppAssets.homeMarker, size: 120),
    );

    ///TODO: without change Size
    // final myMarkerIcon = await BitmapDescriptor.fromAssetImage(
    //   const ImageConfiguration(),
    //   AppAssets.homeMarker,
    // );
    final marker = Marker(
      icon: myMarkerIcon,
      position: AppAssets.myLocation,
      markerId: const MarkerId('myMarker'),
      infoWindow: const InfoWindow(title: 'this is my location'),
    );
    myMarkers.add(marker);
    setState(() {});
  }

  /// TODO: change marker size
  Future<Uint8List> changeMarkerSizeFun({required String markerImage, required int size}) async {
    ByteData byteData = await rootBundle.load(markerImage);
    Uint8List uint8listData = byteData.buffer.asUint8List();
    ui.Codec imageCodec = await ui.instantiateImageCodec(
      uint8listData,
      targetWidth: size,
      targetHeight: size,
    );
    ui.FrameInfo imageFrameInfo = await imageCodec.getNextFrame();

    final imageByteData = await imageFrameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final finalImage = imageByteData!.buffer.asUint8List();

    return finalImage;
  }
}
