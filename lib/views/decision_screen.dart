import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxi/controller/auth_controller.dart';
import 'package:taxi/views/driver/driver_profile_setup.dart';
import 'package:taxi/views/login_screen.dart';
import 'package:taxi/widgets/green_intro_widget.dart';
import 'package:taxi/widgets/my_botton.dart';

class DecisionScreen extends StatelessWidget {
  DecisionScreen({super.key});

  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            greenIntroWidget(),
            const SizedBox(
              height: 50,
            ),
            DecisionButton(
              'assets/images/bgColor.png',
              'Login As Driver',
              () {
                authController.isLoginAsDriver = true;
                Get.to(() => const LoginScreen());
              },
              Get.width * 0.8,
            ),
            const SizedBox(
              height: 20,
            ),
            DecisionButton(
              'assets/images/bgColor.png',
              'Login As User',
              () {
                authController.isLoginAsDriver = false;
                Get.to(() => const LoginScreen());
                //Get.to(() => const DriverProfileSetup());
              },
              Get.width * 0.8,
            ),
          ],
        ),
      ),
    );
  }
}
