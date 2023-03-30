import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxi/views/driver/car_registration/pages/location_page.dart';
import 'package:taxi/views/driver/car_registration/pages/show_upload_document.dart';
import 'package:taxi/views/driver/car_registration/pages/type_of_vehicle.dart';
import 'package:taxi/views/driver/car_registration/pages/upload_document.dart';
import 'package:taxi/views/driver/car_registration/pages/vehicle_make.dart';
import 'package:taxi/views/driver/car_registration/pages/verification_process_status.dart';
import 'package:taxi/widgets/green_intro_widget_without_logo.dart';

import '../../../controller/auth_controller.dart';

class CarRegistrationTemplatee extends StatefulWidget {
  const CarRegistrationTemplatee({super.key});

  @override
  State<CarRegistrationTemplatee> createState() =>
      _CarRegistrationTemplateeState();
}

class _CarRegistrationTemplateeState extends State<CarRegistrationTemplatee> {
  String selectedLocation = '';
  String selectedVehicleType = '';
  String selectedVehicleMake = '';
  String selectedVehicleModel = '';
  String selectedVehicleColor = '';
  String selectedVehicleNumber = '';
  String selectedVehicleYear = '';

  File? document;

  PageController pgController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          greenIntroWidgetWithoutLogo(
              title: 'Car Registration', subtitle: 'Complete the '),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            //as it contains specific pages, we are not
            //going to use a pageview builder for it, instead
            //we use the pageview that has children
            child: Padding(
              //since all the pages contains the same padding, we have to generalize it in the pageview widget
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
              child: PageView(
                controller: pgController,
                onPageChanged: (value) {
                  currentPage = value;
                },
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  LocationPage(
                    selectedLocation: selectedLocation,
                    onSelect: (String location) {
                      setState(() {
                        selectedLocation = location;
                      });
                    },
                  ),
                  VehicleType(
                      selectedVehicle: selectedVehicleType,
                      onSelect: (String vehicle) {
                        setState(() {
                          selectedVehicleType = vehicle;
                        });
                      }),
                  VehicleMake(
                    vehicleMaker: selectedVehicleMake,
                    onSelected: (String vehicleMaker) {
                      setState(() {
                        selectedVehicleMake = vehicleMaker;
                      });

                      UploadDocument(
                        onImageSelected: (File image) {
                          document = image;
                        },
                      );
                      const ShowUpload();
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => isUploading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : FloatingActionButton(
                        onPressed: () {
                          if (currentPage < 8) {
                            pgController.animateToPage(
                              currentPage + 1,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeIn,
                            );
                          } else {
                            uploadDriverCarEntry();
                          }
                        },
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  var isUploading = false.obs;

  void uploadDriverCarEntry() async {
    isUploading(true);
    //first upload the document in the firebase
    String documentUrl =
        await Get.find<AuthController>().uploadImage(document!);
    Map<String, dynamic> carData = {
      'country': selectedLocation,
      'vehicle_type': selectedVehicleType,
      'vehicle_make': selectedVehicleMake,
      'vehicle_model': selectedVehicleModel,
      'vehicle_year': selectedVehicleYear,
      'vehicle_number': selectedVehicleNumber,
      'vehicle_color': selectedVehicleColor,
      'document': documentUrl,
    };
    await Get.find<AuthController>().uploadCarEntry(carData);
    isUploading(false);
    Get.off(() => VerificationProcessStatus());
  }
}
