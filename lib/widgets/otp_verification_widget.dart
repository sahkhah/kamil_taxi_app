import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxi/utils/appContstants.dart';
import 'package:taxi/widgets/pinput.dart';
import 'package:taxi/widgets/text_widget.dart';

Widget otpVerificationWidget() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: AppConstants.phoneVerification),
        textWidget(
          text: AppConstants.enterOtp,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(
          height: 40,
        ),
        SizedBox(
          width: Get.width,
          height: 50,
          child: const RoundedWithShadow(),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
              children: [
                const TextSpan(
                  text: '${AppConstants.resendCode} ',
                ),
                TextSpan(
                  text: '10 seconds ',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
