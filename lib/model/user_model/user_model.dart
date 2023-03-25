// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserModel {
  String? bAddress;
  String? hAdrerss;
  String? mallAddress;
  String? name;
  String? image;

  LatLng? homeAddress;
  LatLng? businessAddress;
  LatLng? shopAddress;

  UserModel({
    required this.bAddress,
    required this.hAdrerss,
    required this.mallAddress,
    required this.name,
    required this.image,
    required this.homeAddress,
    required this.businessAddress,
    required this.shopAddress,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    UserModel(
      bAddress: json['business_address'],
      hAdrerss: json['home_address'],
      mallAddress: json['shopping_address'],
      name: json['name'],
      image: json['image'],
      homeAddress: LatLng(
        json['home_latlng'].latitude,
        json['home_latlng'].longitude,
      ),
      businessAddress: LatLng(
        json['business_latlng'].latitude,
        json['business_latlng'].longitude,
      ),
      shopAddress: LatLng(
        json['shopping_latlng'].latitude, 
        json['shopping_latlng'].longitude,
      ),
    );
  }
}
