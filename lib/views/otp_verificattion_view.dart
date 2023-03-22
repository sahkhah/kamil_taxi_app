import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxi/controller/auth_controller.dart';

import 'package:taxi/utils/appColors.dart';

import '../widgets/green_intro_widget.dart';
import '../widgets/otp_verification_widget.dart';

class OtpScreen extends StatefulWidget {
  String? phoneNumber;
  OtpScreen(
    this.phoneNumber,
  );

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  AuthController authController =
      Get.find<AuthController>(); //gets an instance of authcontroller

  @override
  void initState() {
    authController.phoneAuth(widget.phoneNumber!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: [
              greenIntroWidget(),
              Positioned(
                  top: 40,
                  left: 30,
                  child: InkWell(
                    onTap: (() {
                      Get.back();
                    }),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.greenColor,
                        size: 20,
                      ),
                    ),
                  ))
            ],
          ),
          const SizedBox(height: 50),
          otpVerificationWidget(),
        ]),
      ),
    );
  }
}
