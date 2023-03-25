import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:taxi/controller/auth_controller.dart';
import 'package:taxi/views/payment_screen.dart';
import 'package:taxi/views/profile_setting_screen.dart';
import 'package:taxi/widgets/text_widget.dart';

import '../utils/appColors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(14.8888888, 12.9983),
    zoom: 14.4746,
  );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LatLng destination;
  late LatLng source;

  String? dropDownValue;

  final Set<Polyline> _polyLine = {};
  String? _mapStyle;
  Set<Marker> markers = <Marker>{};

  GoogleMapController? myMapController;

  TextEditingController destinationController = TextEditingController();
  TextEditingController sourceController = TextEditingController();

  bool showSourceField = false;

  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    void drawPolyLine(String placeId) {
      _polyLine.clear();
      _polyLine.add(
        Polyline(
          polylineId: PolylineId(placeId),
          visible: true,
          points: [source, destination],
          color: AppColors.greyColor,
          width: 5,
        ),
      );
    }

    buildSourceSheet() {
      Get.bottomSheet(
        Container(
          width: Get.width,
          height: Get.height * 0.5,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Select Your Location',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Home Address ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  Get.back();
                  source = authController.myUser.value.homeAddress!;
                  if (markers.length >= 2) {
                    markers.remove(markers.length);
                  }
                  markers.add(
                    Marker(
                      markerId: MarkerId(authController.myUser.value.hAdrerss!),
                      infoWindow: InfoWindow(
                        title:
                            'Source: ${authController.myUser.value.hAdrerss!}',
                      ),
                      position: source,
                    ),
                  );

                  //await getPolyLines(source, destination);
                  //drawPolyLine(sourcePlace);

                  myMapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: source,
                        zoom: 14,
                      ),
                    ),
                  );
                  setState(() {
                    //showSourceField = true;
                  });

                  // Get.back();

                  buildRideConfirmationSheet();
                },
                child: Container(
                  width: Get.width,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        spreadRadius: 4,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        authController.myUser.value.hAdrerss!,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                authController.myUser.value.mallAddress!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: Get.width,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      spreadRadius: 4,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      authController.myUser.value.bAddress!,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  Get.back();
                  //String= sourcePlace = await showGoogleAutoComplete();
                  Prediction? p =
                      await authController.showGoogleAutoComplete(context);
                  String sourcePlace = p!.description!;
                  sourceController.text = sourcePlace;
                  /* List<geoCoding.Location> locations =
                              await geoCoding.locationFromAddress(sourcePlace);
                          source = LatLng(locations.first.latitude,
                              locations.first.longitude); */
                  /* source =
                      await authController.buildLatLngFromAddress(sourcePlace);
                  if (markers.length >= 2) {
                    markers.remove(markers.length);
                  }
                  markers.add(
                    Marker(
                      markerId: MarkerId(sourcePlace),
                      infoWindow: InfoWindow(
                        title: 'Source: $sourcePlace',
                      ),
                      position: source,
                    ),
                  );
                  drawPolyLine(sourcePlace);

                  myMapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: source,
                        zoom: 14,
                      ),
                    ),
                  );
                  setState(() {
                    showSourceField = true;
                  }); */
                },
                child: Container(
                  width: Get.width,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 4,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Text(
                    'Search for Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    @override
    void initState() {
      super.initState();

      authController.getUserInfo();

      rootBundle
          .loadString('assets/map_style.txt')
          .then((value) => _mapStyle = value);

      //loadCustomMarker();
    }

    Widget buildProfileTile() {
      return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Obx(
            (() => authController.myUser.value.name == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    width: Get.width,
                    height: Get.height * .5,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: authController.myUser.value.image == null
                                  ? const DecorationImage(
                                      image: AssetImage('assets/person.png'),
                                      fit: BoxFit.fill)
                                  : DecorationImage(
                                      image: NetworkImage(
                                          authController.myUser.value.image!),
                                      fit: BoxFit.fill)),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Good Morning, ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    //name fetched from the firebase firestore
                                    text: authController.myUser.value.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'Where are you going?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
          ));
    }

    Widget buildDestinationTextField() {
      return Positioned(
        top: 170,
        left: 20,
        right: 29,
        child: Container(
          width: Get.width,
          height: 50,
          padding: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 4,
                blurRadius: 10,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: destinationController,
            readOnly: true,
            onTap: () async {
              //String selectedPlace = await showGoogleAutoComplete();
              Prediction? p =
                  await authController.showGoogleAutoComplete(context);
              String selectedPlace = p!.description!;
              destinationController.text = selectedPlace;
              /*  List<geoCoding.Location> locations =
                  await geoCoding.locationFromAddress(selectedPlace);
              destination =
                  LatLng(locations.first.latitude, locations.first.longitude); */
              destination =
                  await authController.buildLatLngFromAddress(selectedPlace);
              // late Uint8List markIcons;
              Uint8List markIcons = Uint8List(1);
              markers.add(
                Marker(
                  icon: BitmapDescriptor.fromBytes(markIcons),
                  markerId: MarkerId(selectedPlace),
                  infoWindow: InfoWindow(
                    title: 'Destination: $selectedPlace',
                  ),
                ),
              );
              myMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: destination,
                    zoom: 14,
                  ),
                ),
              );
              setState(() {
                showSourceField = true;
              });
            },
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xffA7A7A7),
            ),
            decoration: InputDecoration(
                hintText: 'Search for a destination',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.search),
                )),
          ),
        ),
      );
    }

    Widget buildSourceTextField() {
      return Positioned(
        top: 230,
        left: 20,
        right: 20,
        child: Container(
          width: Get.width,
          height: 50,
          padding: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 4,
                blurRadius: 10,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: sourceController,
            readOnly: true,
            onTap: () async {
              buildSourceSheet();
            },
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xffA7A7A7),
            ),
            decoration: InputDecoration(
                hintText: 'From',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.search),
                )),
          ),
        ),
      );
    }

    buildDrawer() {
      return Drawer(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Get.to(const ProfileSettingScreen());
              },
              child: SizedBox(
                height: 150,
                child: DrawerHeader(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: authController.myUser.value.image == null
                                ? const DecorationImage(
                                    image: AssetImage('assets/person.png'),
                                    fit: BoxFit.fill)
                                : DecorationImage(
                                    image: NetworkImage(
                                        authController.myUser.value.image!),
                                    fit: BoxFit.fill)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Good Morning',
                              style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.28),
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              authController.myUser.value.name ?? 'Mark Novpak',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  buildDrawerItem(
                      title: 'Payment History',
                      onPressed: () {
                        Get.to(() => const PaymentScreen());
                      }),
                  buildDrawerItem(
                      title: 'Ride History', onPressed: () {}, isVisible: true),
                  buildDrawerItem(title: 'Invite Friends', onPressed: () {}),
                  buildDrawerItem(title: 'Promo Codes', onPressed: () {}),
                  buildDrawerItem(title: 'Settings', onPressed: () {}),
                  buildDrawerItem(title: 'Support', onPressed: () {}),
                  buildDrawerItem(title: 'Log Out', onPressed: () {}),
                ],
              ),
            ),
            const Spacer(),
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 18,
              ),
              child: Column(children: [
                buildDrawerItem(
                    title: 'Do More',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.15),
                    height: 20),
                const SizedBox(
                  height: 20,
                ),
                buildDrawerItem(
                    title: 'Get Food Delivery',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.15),
                    height: 20),
                buildDrawerItem(
                    title: 'Make Money Driving',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.15),
                    height: 20),
                buildDrawerItem(
                    title: 'Rate us on store',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.15),
                    height: 20),
              ]),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      drawer: buildDrawer(),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
              polylines: _polyLine,
              markers: markers,
              zoomControlsEnabled: false,
              mapType: MapType.hybrid,
              initialCameraPosition: HomeScreen._kGooglePlex,
              onMapCreated: (controller) {},
            ),
          ),
          buildProfileTile(),
          buildDestinationTextField(),
          showSourceField ? buildSourceTextField() : Container(),
          buildCurrentLocationIcon(),
          buildBottomSheet(),
        ],
      ),
    );
  }

  buildRideConfirmationSheet() {
    Get.bottomSheet(
      Container(
        width: Get.width,
        height: Get.height * 0.4,
        padding: const EdgeInsets.only(
          left: 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: Get.width * 0.2,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            textWidget(
                text: 'Select an option',
                fontSize: 18,
                fontWeight: FontWeight.bold),
            const SizedBox(
              height: 20,
            ),
            buildDriverList(),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: buildPaymentCardWidget(),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    color: AppColors.greenColor,
                    shape: const StadiumBorder(),
                    child: textWidget(
                      text: 'Confirm',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int selectedRide = 0;

  buildDriverList() {
    return SizedBox(
      height: 90,
      width: Get.width,
      child: StatefulBuilder(
        builder: (context, setState) {
          return ListView.builder(
            itemBuilder: ((context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedRide = index;
                  });
                },
                child: buildDriverCard(selectedRide == index),
              );
            }),
            itemCount: 3,
            scrollDirection: Axis.horizontal,
          );
        },
      ),
    );
  }

  buildDriverCard(bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
      height: 85,
      width: 165,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: selected
                ? const Color(0xff2DBB54).withOpacity(0.2)
                : Colors.grey.withOpacity(0.2),
            offset: const Offset(0, 5),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
        color: selected ? const Color(0xff2DBB54) : Colors.grey,
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 10,
              top: 10,
              bottom: 10,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                  text: 'Standard',
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                )
              ],
            ),
          ),
          Positioned(
            right: -20,
            top: 0,
            bottom: 0,
            child: Image.asset('assets/Mask Group 2.png'),
          ),
        ],
      ),
    );
  }

  buildDrawerItem({
    bool isVisible = false,
    required String title,
    double height = 45,
    required Function onPressed,
    Color color = Colors.black,
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return SizedBox(
      height: height,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        dense: true,
        onTap: () => onPressed,
        title: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: color,
              ),
            ),
            const SizedBox(width: 5),
            isVisible
                ? CircleAvatar(
                    backgroundColor: AppColors.greenColor,
                    radius: 15,
                    child: Text(
                      '1',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

/* late Uint8List markIcons;

loadCustomMarker() async {
  markIcons = await loadAsset('assets/dest_marker.png', 100);
} */

/* Future<Uint8List> loadAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      tergetHeight: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteDAta(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
} */

  Widget buildCurrentLocationIcon() {
    return const Align(
      alignment: Alignment.bottomRight,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.green,
        child: Icon(
          Icons.my_location,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: Get.width * 0.8,
        height: 25,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 4,
              blurRadius: 10,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
          ),
        ),
        child: Center(
          child: Container(
            width: Get.width * 0.6,
            height: 4,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  buildPaymentCardWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/visa.png',
            width: 40,
          ),
          const SizedBox(
            width: 10,
          ),
          DropdownButton<String>(
            items: const [],
            value: dropDownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(),
            onChanged: (String? value) {
              //This is called when the user selects an item
              setState(() {
                dropDownValue = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
