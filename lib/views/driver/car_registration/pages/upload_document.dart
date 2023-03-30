import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadDocument extends StatefulWidget {
  const UploadDocument({super.key, required this.onImageSelected});

  final Function onImageSelected;

  @override
  State<UploadDocument> createState() => _ModelYearState();
}

class _ModelYearState extends State<UploadDocument> {
  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  getImage(ImageSource imgSource) async {
    final XFile? image = await picker.pickImage(source: imgSource);
    if (image != null) {
      selectedImage = File(image.path);
      widget.onImageSelected(selectedImage);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Upload Documents',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            getImage(ImageSource.camera);
          },
          child: Container(
            width: Get.width,
            height: Get.height * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xffE3E3E3).withOpacity(0.4),
              border: Border.all(
                color: const Color(0xff2F8654).withOpacity(0.26),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_upload,
                  size: 40,
                  color: Color(0xff707070),
                ),
                Text(
                  selectedImage != null
                      ? 'Tap here to upload'
                      : 'Document is Selected',
                  style: const TextStyle(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
