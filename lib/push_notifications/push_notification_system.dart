import 'package:drivers_app/global/global.dart';
import 'package:drivers_app/models/user_ride_request_information.dart';
import 'package:drivers_app/push_notifications/notification_dialog_box.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async {
    await Firebase.initializeApp();
    //1. terminated
    //When the device is locked or the application is not running.
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        print("this is Ride Request");
        print(remoteMessage.data["rideRequestId"]);
        //display ride request information- user informationwhorequest a ride
        readUserRideRequestInformation(
            remoteMessage.data["rideRequestId"], context);
      }
    });

    //2. Foreground
    //When the application is open, in view & in use.
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) async {
      await Firebase.initializeApp();
      print("this is Ride Request");
      print(remoteMessage!.data["rideRequestId"]);
      //display ride request information- user informationwhorequest a ride
      readUserRideRequestInformation(
          remoteMessage.data["rideRequestId"], context);
    });

    //3. Background
    // When the application is open, however in the background (minimised)
    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage? remoteMessage) async {
      await Firebase.initializeApp();
      print("this is Ride Request");
      print(remoteMessage!.data["rideRequestId"]);
      //display ride request information- user informationwhorequest a ride
      readUserRideRequestInformation(
          remoteMessage.data["rideRequestId"], context);
    });
  }

  readUserRideRequestInformation(
      String UserRideRequestId, BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .child(UserRideRequestId)
        .once()
        .then((snapData) {
      if (snapData.snapshot.value != null) {
        // audioPlayer.open(Audio("music/music_notification.mp3"));
        // audioPlayer.play();
        //--------------------Origin-----------------//
        double originLat = double.parse(
            (snapData.snapshot.value! as Map)["origin"]["latitude"]);
        double originLng = double.parse(
            (snapData.snapshot.value! as Map)["origin"]["longitude"]);
        String originAddress =
            (snapData.snapshot.value! as Map)["originAddress"];
        //--------------------destination-----------------//
        double destinationLat = double.parse(
            (snapData.snapshot.value! as Map)["destination"]["latitude"]);
        double destinationLng = double.parse(
            (snapData.snapshot.value! as Map)["destination"]["longitude"]);
        String destinationAddress =
            (snapData.snapshot.value! as Map)["destinationAddress"];

        String userName = (snapData.snapshot.value! as Map)["userName"];
        String userPhone = (snapData.snapshot.value! as Map)["userPhone"];

        String? rideRequestId = snapData.snapshot.key;

        UserRideRequestInformation userRideRequestDetails =
            UserRideRequestInformation();
        userRideRequestDetails.originLng = LatLng(originLat, originLng);
        userRideRequestDetails.originAddress = originAddress;
        userRideRequestDetails.destinationLng =
            LatLng(destinationLat, destinationLng);
        userRideRequestDetails.destinationAddress = destinationAddress;

        userRideRequestDetails.userName = userName;
        userRideRequestDetails.userPhone = userPhone;

        userRideRequestDetails.rideRequestId=rideRequestId;

        showDialog(
            context: context,
            builder: (BuildContext context) => NotificationDialogBox(
                  userRideRequestDetails: userRideRequestDetails,
                ));
      } else {
        Fluttertoast.showToast(msg: "this ride reques Id do not exit.");
      }
    });
  }

  Future generateAndGetToken() async {
    await Firebase.initializeApp();
    String? registrationToken = await messaging.getToken();
    print("FCM Registration Token");
    print(registrationToken);
    if (currentFirebaseUser != null) {
      FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(currentFirebaseUser!.uid)
          .child("token")
          .set(registrationToken);
    } else {
      return;
    }

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }
}
