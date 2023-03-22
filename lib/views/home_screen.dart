import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:taxi/controller/auth_controller.dart';
import 'package:taxi/views/profile_setting_screen.dart';

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

    @override
    void initState() {
      super.initState();

      authController.getUserInfo();

      rootBundle
          .loadString('assets/map_style.txt')
          .then((value) => _mapStyle = value);

      loadCustomMarker();
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
                          children: const [
                            Text(
                              'KOA, KOHAT',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Office Address ',
                        style: TextStyle(
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
                          children: const [
                            Text(
                              'Tahil, KOHAT',
                              style: TextStyle(color: Colors.black),
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
                          Prediction? p = await authController
                              .showGoogleAutoComplete(context);
                          String sourcePlace = p!.description!;
                          sourceController.text = sourcePlace;
                          /* List<geoCoding.Location> locations =
                              await geoCoding.locationFromAddress(sourcePlace);
                          source = LatLng(locations.first.latitude,
                              locations.first.longitude); */
                          source = await authController
                              .buildLatLngFromAddress(sourcePlace);
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
                          });
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
                  buildDrawerItem(title: 'Payment History', onPressed: () {}),
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
      onTap: () => onPressed(),
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

late Uint8List markIcons;

loadCustomMarker() async {
  markIcons = await loadAsset('assets/dest_marker.png', 100);
}

Future<Uint8List> loadAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      tergetHeight: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteDAta(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

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
