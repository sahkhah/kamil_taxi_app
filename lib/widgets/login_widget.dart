import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxi/utils/appContstants.dart';
import 'package:taxi/views/otp_verificattion_view.dart';
import 'package:taxi/widgets/text_widget.dart';

Widget loginWidget(CountryCode countryCode, Function onCountryChanged, Function onSubmit) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: AppConstants.helloNiceToMeetYou),
        textWidget(
          text: AppConstants.getMoving,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(
          height: 40,
        ),
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 3,
                blurRadius: 3,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => onCountryChanged(),
                  child: Container(
                    child: Row(
                      children: [
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            child: countryCode.flagImage,
                          ),
                        ),
                        textWidget(text: countryCode.dialCode),
                        const Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 55,
                color: Colors.black.withOpacity(0.2),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    onSubmitted: (input) {
                      onSubmit(input);
                    },
                    onTap: (() {
                      Get.to(() => OtpScreen(null));
                    }),
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      hintText: AppConstants.enterMobileNumber,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
              children: [
                const TextSpan(
                  text: '${AppConstants.byCreating} ',
                ),
                TextSpan(
                  text: '${AppConstants.termsOfService} ',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: 'and',
                ),
                TextSpan(
                  text: "${AppConstants.privacyPolicy} ",
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
