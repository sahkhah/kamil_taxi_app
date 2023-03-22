import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';

import 'package:taxi/controller/auth_controller.dart';
import 'package:taxi/utils/appColors.dart';
import '../widgets/green_intro_widget_without_logo.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  //controllers for each textfield
  final nameController = TextEditingController();
  final homeController = TextEditingController();
  final businessController = TextEditingController();
  final shopController = TextEditingController();
  //GetX controller
  final authController = Get.find<AuthController>();
  //key for the textfield
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //image to the displayed
  File? selectedImage;

  final ImagePicker imagePicker = ImagePicker();

  late LatLng homeAddress;
  late LatLng businessAddress;
  late LatLng shopAddress;

  @override
  void initState() {
    super.initState();
    nameController.text = authController.myUser.value.name ?? "";
    homeController.text = authController.myUser.value.hAdrerss ?? "";
    businessController.text = authController.myUser.value.bAddress ?? "";
    shopController.text = authController.myUser.value.mallAddress ?? "";
  }

  getImage({required ImageSource source}) async {
    final XFile? image = await imagePicker.pickImage(source: source);

    if (image != null) {
      selectedImage = File(image.path);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.4,
      child: Stack(
        children: [
          greenIntroWidgetWithoutLogo(),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                getImage(source: ImageSource.camera);
              },
              child: selectedImage == null
                  ? Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffD6D6D6),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(
                            selectedImage!,
                          ),
                        ),
                        shape: BoxShape.circle,
                        color: const Color(0xffD6D6D6),
                      ),
                    ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 23),
            child: Column(
              children: [
                textFieldWidget(
                  'Name',
                  Icons.person_outlined,
                  nameController,
                  (String? input) {
                    if (input!.isEmpty) {
                      return 'Name is required';
                    }

                    if (input.length < 5) {
                      return 'Please enter a valid name';
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                textFieldWidget(
                  'Home Address',
                  Icons.home_outlined,
                  homeController,
                  (String? input) {
                    if (input!.isEmpty) {
                      return 'Home address is required';
                    }
                    return null;
                  },
                  onTap: () async {
                    Prediction? p =
                        await authController.showGoogleAutoComplete(context);
                    /* String sourcePlace = p!.description!;
                    List<geoCoding.Location> locations =
                        await geoCoding.locationFromAddress(sourcePlace);
                    homeAddress = LatLng(
                        locations.first.latitude, locations.first.longitude);
                  */
                    //now let's translate this selected address and convert it to a latlng object
                    homeAddress = await authController
                        .buildLatLngFromAddress(p!.description!);
                    homeController.text = p.description!;
                    //store this information into firebase together once update is clicked
                  },
                  readOnly: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                textFieldWidget(
                    'Business Address', Icons.card_travel, businessController,
                    (String? input) {
                  if (input!.isEmpty) {
                    return 'Business address is required';
                  }
                  return null;
                }, onTap: () async {
                  Prediction? p =
                      await authController.showGoogleAutoComplete(context);
                  businessAddress = await authController
                      .buildLatLngFromAddress(p!.description!);
                  businessController.text = p.description!;
                  //store this information into firebase together once update is clicked
                }),
                const SizedBox(
                  height: 10,
                ),
                textFieldWidget(
                  'Shopping Center',
                  Icons.shopping_cart_outlined,
                  shopController,
                  (String? input) {
                    if (input!.isEmpty) {
                      return 'Shopping Center is required';
                    }
                    return null;
                  },
                  onTap: () async {
                    Prediction? p =
                        await authController.showGoogleAutoComplete(context);
                    shopAddress = await authController
                        .buildLatLngFromAddress(p!.description!);
                    shopController.text = p.description!;
                    //store this information into firebase together once update is clicked
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(() => authController.isProfileUploading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : greeenButton('Submit', () {
                        if (formKey.currentState!.validate()) {
                          return;
                        }
                        if (selectedImage == null) {
                          Get.snackbar('Warning', 'Please add your image');
                          return;
                        }
                        //authController.isProfileUploading(true);
                        authController.storeUserInfo(
                          selectedImage,
                          nameController.text,
                          homeController.text,
                          businessController.text,
                          shopController.text,
                          url: authController.myUser.value.image ?? '',
                        );
                      })),
              ],
            ),
          )
        ],
      ),
    );
  }

  textFieldWidget(String title, IconData iconData,
      TextEditingController controller, Function validator,
      {Function? onTap, bool readOnly = false}) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xffeceded),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Container(
              width: Get.width,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.85),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                readOnly: readOnly,
                validator: (value) {
                  validator(value);
                  return null;
                },
                controller: controller,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xffA7A7A7),
                ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      iconData,
                      color: AppColors.greenColor,
                    ),
                  ),
                  border: InputBorder.none,
                ),
              ))
        ],
      ),
    );
  }

  greeenButton(String s, Function() param1) {
    return ElevatedButton(
      onPressed: param1,
      child: Text(s),
    );
  }
}
