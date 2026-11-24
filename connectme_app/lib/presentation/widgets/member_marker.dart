import 'package:google_maps_flutter/google_maps_flutter.dart';

class MemberMarker {
  const MemberMarker({
    required this.id,
    required this.name,
    required this.city,
    required this.position,
  });

  final String id;
  final String name;
  final String city;
  final LatLng position;

  Marker toMarker() => Marker(
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(title: name, snippet: city),
      );
}
