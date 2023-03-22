import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

Widget greenIntroWidget() {
  return Container(
    width: Get.width,
    height: Get.height * 0.6,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/bg2.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/oak-leaf.png'),
        const SizedBox(
          height: 10,
        ),
        SvgPicture.asset('assets/oak-leaf.png'),
      ],
    ),
  );
}
