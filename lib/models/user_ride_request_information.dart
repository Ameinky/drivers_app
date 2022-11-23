import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRideRequestInformation {
  LatLng? originLng;
  LatLng? destinationLng;
  String? originAddress;
  String? destinationAddress;
  String? rideRequestId;
  String? userName;
  String? userPhone;

  UserRideRequestInformation(
      {this.originLng,
      this.destinationLng,
      this.originAddress,
      this.destinationAddress,
      this.rideRequestId,
      this.userName,
      this.userPhone});
}
