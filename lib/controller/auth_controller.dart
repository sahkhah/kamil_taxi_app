import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:taxi/model/user_model/user_model.dart';
import 'package:taxi/views/profile_setting_screen.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import '../views/home_screen.dart';
import 'package:path/path.dart' as Path;

class AuthController extends GetxController {


  String userUid = ''; //storing userId


  var varId = ''; //verification code


  int? resendTokenId;


  bool phoneAuthCheck = false;


  bool profileUpload = false;


  bool get isProfileUploading => profileUpload;


  dynamic credentials;






  set isProfileUploading(bool value) {
    profileUpload = value;
  }







  phoneAuth(String phone) async {
    try {
      credentials = null;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          log('Completed');
          credentials = credential;
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        forceResendingToken: resendTokenId,
        verificationFailed: (FirebaseAuthException e) {
          log('failed');
          if (e.code == 'Invalid-phone-number') {
            debugPrint('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          log('Code sent');
          varId = verificationId;
          resendTokenId = resendToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      log('Error occured $e');
    }
  }













  verifyOtp(String otpNumber) async {
    log('Called');
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: varId,
      smsCode: otpNumber,
    );

    log('Logged In');

    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      decideRoute();
    });
  }











  decideRoute() {
    //Step 1- check user login
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      //Step 2- check whether the user profile exists
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) {
        if (value.exists) {
          Get.to(() => const HomeScreen());
        } else {
          Get.to(() => const ProfileSettingScreen());
        }
      });
    }
  }











  var myUser = UserModel(
          bAddress: null,
          hAdrerss: null,
          mallAddress: null,
          name: null,
          image: null)
      .obs;













  getUserInfo() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).snapshots().listen(
      (event) {
        myUser.value = UserModel.fromJson(event.data()!);
      },
    );
  }









  Future<Prediction?> showGoogleAutoComplete(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
        offset: 0,
        radius: 1000,
        strictbounds: false,
        hint: 'Search City',
        region: 'us',
        context: context,
        apiKey: '',
        types: ['(cities)'],
        mode: Mode.overlay,
        language: 'en',
        components: [Component(Component.country, 'us')]);

    return p;
  }









  uploadImage(File image) async {
    String imageUrl = '';

    String fileName = Path.basename(image.path);
    var reference = FirebaseStorage.instance.ref().child('users/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then(
      (value) {
        imageUrl = value;
        print('Download URL: $value');
      },
    );

    return imageUrl;
  }









  storeUserInfo(
    File? selectedImage,
    String name,
    String home,
    String business,
    String shop, {
    String url = '',
    LatLng? homeLatlng,
    LatLng? shoppingLatLng,
    LatLng? businessLatLng,
  }) async {
    String urlNew = url;
    if (selectedImage != null) {
      urlNew = await uploadImage(selectedImage);
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': url,
      'name': name,
      'home_address': home,
      'business_address': business,
      'shopping_address': shop,
    }).then((value) {
      Get.to(() => const HomeScreen());
    });
  }







  Future<LatLng> buildLatLngFromAddress(String place) async {
    List<geoCoding.Location> locations =
        await geoCoding.locationFromAddress(place);
    return LatLng(locations.first.latitude, locations.first.longitude);
  }
}
