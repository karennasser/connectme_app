import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/member_marker.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static const _members = [
    MemberMarker(id: 'm1', name: 'Maya Hassan', city: 'Cairo, Egypt',
      position: LatLng(30.0444, 31.2357)),
    MemberMarker(id: 'm2', name: 'Omar Khalil', city: 'Alexandria, Egypt',
      position: LatLng(31.2001, 29.9187)),
    MemberMarker(id: 'm3', name: 'Lina Ahmed', city: 'Giza, Egypt',
      position: LatLng(30.0131, 31.2089)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Map')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(30.8, 30.5),
          zoom: 6,
        ),
        markers: _members.map((member) => member.toMarker()).toSet(),
        mapToolbarEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
