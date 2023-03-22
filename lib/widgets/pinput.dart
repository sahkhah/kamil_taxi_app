import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:taxi/controller/auth_controller.dart';

class RoundedWithShadow extends StatefulWidget {
  const RoundedWithShadow({super.key});

  @override
  State<RoundedWithShadow> createState() => _RoundedWithShadowState();
  @override
  String toStringShort() => 'Rounded With Shadow';
}

class _RoundedWithShadowState extends State<RoundedWithShadow> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  AuthController authController = Get.find<AuthController>();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 68,
      height: 64,
      textStyle: GoogleFonts.poppins(
          fontSize: 20, color: const Color.fromRGBO(70, 69, 66, 1)),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(232, 235, 241, 0.37),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(
          bottom: 12,
        ),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    return Pinput(
      length: 6,
      onCompleted: (String input) {
        authController.verifyOtp(input);
      },
      controller: controller,
      focusNode: focusNode,
      defaultPinTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      )
    );
  }
}
