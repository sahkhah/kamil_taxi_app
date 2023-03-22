// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String? bAddress;
  String? hAdrerss;
  String? mallAddress;
  String? name;
  String? image;

  

  UserModel({
    required this.bAddress,
    required this.hAdrerss,
    required this.mallAddress,
    required this.name,
    required this.image,
  });

  

  UserModel.fromJson(Map<String, dynamic> json){
    UserModel(
    bAddress: json['business_address'], 
    hAdrerss: json['home_address'], 
    mallAddress: json['shopping_address'], 
    name: json['name'], 
    image: json['image']);
  }

}
