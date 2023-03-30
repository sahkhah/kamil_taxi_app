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
import 'package:taxi/views/driver/car_registration/car_registration_template.dart';
import 'package:taxi/views/driver/driver_profile_setup.dart';
import 'package:taxi/views/profile_setting_screen.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import '../views/home_screen.dart';
import 'package:path/path.dart' as Path;

class AuthController extends GetxController {
  String userUid = ''; //storing userId

  var varId = ''; //verification code

  int? resendTokenId;

  bool phoneAuthCheck = false;

  var isProfileUploading = false.obs;

  var isDecided = false;

  dynamic credentials;

  RxList userCards = [].obs;

//check whether the user is a driver or a user
  bool isLoginAsDriver = false;

  storeUserCard(String number, String expiry, String cvv, String name) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cards')
        .add({
      'name': name,
      'number': number,
      'cvv': cvv,
      'expiry': expiry,
    }).then((value) => print(value));
  }

  getUserCard() {
    //fetch all the values that's associated with this particular user
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cards')
        .snapshots()
        .listen(
      (event) {
        userCards.value = event.docs;
      },
    );
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
      if (isLoginAsDriver) {
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get()
            .then((value) {
          //if isLoginAsDriver == true, navigate to the driver module
          if (isLoginAsDriver) {
            if (value.exists) {
              print('Driver Home Screen');
              //Get.offAll(() => const HomeScreen());
            } else {
              Get.offAll(() => const DriverProfileSetup());
            }
          } else {
            if (value.exists) {
              Get.to(() => const HomeScreen());
            } else {
              Get.to(() => const ProfileSettingScreen());
            }
          }
        });
      }
    }
  }

  var myUser = UserModel(
    bAddress: null,
    hAdrerss: null,
    mallAddress: null,
    name: null,
    image: null,
    businessAddress: null,
    homeAddress: null,
    shopAddress: null,
  ).obs;

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
    LatLng? homeLatLng,
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
      'home_latlng': GeoPoint(homeLatLng!.latitude, homeLatLng.longitude),
      'shop_latlng':
          GeoPoint(shoppingLatLng!.latitude, shoppingLatLng.longitude),
      'business_latlng':
          GeoPoint(businessLatLng!.latitude, businessLatLng.longitude),
    }).then((value) {
      isProfileUploading(false);
      Get.to(() => const HomeScreen());
    });
  }

  storeUserInfoForDriverScreen(
    File? selectedImage,
    String name,
    String email, {
    bool isDriver = false,
    String url = '',
    LatLng? homeLatLng,
    LatLng? shoppingLatLng,
    LatLng? businessLatLng,
  }) async {
    String urlNew = url;
    if (selectedImage != null) {
      urlNew = await uploadImage(selectedImage);
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set(
        {
          'image': urlNew,
          'name': name,
          'email': email,
          'isDriver': true,
          'home_latlng': GeoPoint(homeLatLng!.latitude, homeLatLng.longitude),
          'shop_latlng':
              GeoPoint(shoppingLatLng!.latitude, shoppingLatLng.longitude),
          'business_latlng':
              GeoPoint(businessLatLng!.latitude, businessLatLng.longitude),
        },
        SetOptions(
          merge: true,
        )).then((value) {
      isProfileUploading(false);
      //Get.off is equivalent to Navigation.pushReplacement()
      Get.off(() => const CarRegistrationTemplatee());
      //Get.to(() => const HomeScreen());
    });
  }

  //var isCarEntryUploading = false.obs;
  Future<bool> uploadCarEntry(Map<String, dynamic> carData) async {
    //isCarEntryUploading(true);
    bool isUploaded = false;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set(
        carData,
        SetOptions(
            merge:
                true)); //SetOptions is used so as to save the previous data as well as the new datas
    isUploaded = true;
    //isCarEntryUploading(false);
    return isUploaded;
  }

  Future<LatLng> buildLatLngFromAddress(String place) async {
    List<geoCoding.Location> locations =
        await geoCoding.locationFromAddress(place);
    return LatLng(locations.first.latitude, locations.first.longitude);
  }
}
