import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget greenIntroWidgetWithoutLogo({String? title, String? subtitle}) {
  return Container(
    decoration: const BoxDecoration(
        image: DecorationImage(
      image: AssetImage('images/bg2.png'),
      fit: BoxFit.fill,
    )),
    height: Get.height * 0.3,
    child: Column(
      children: [
        Container(
          height: Get.height * 0.1,
          width: Get.width,
          margin: EdgeInsets.all(
            Get.height * 0.05,
          ),
          child: Center(
            child: Text(
              title!,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(subtitle!,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
      ],
    ),
  );
}
