import 'package:flutter/material.dart';

import '../../../../utils/appColors.dart';

class VehicleType extends StatefulWidget {
  const VehicleType(
      {super.key, required this.selectedVehicle, required this.onSelect});

  final String selectedVehicle;
  final Function onSelect;

  @override
  State<VehicleType> createState() => _VehicleTypeState();
}

class _VehicleTypeState extends State<VehicleType> {
  List<String> vehicles = [
    'Economy',
    'Business',
    'Mobile',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'What Type of Vehicle is it?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: 
              widget.onSelect(
                vehicles[index],
              ),
              //removes the space between every list tile
              visualDensity: const VisualDensity(vertical: -4),
              title: Text(vehicles[index]),
              trailing: widget.selectedVehicle == vehicles[index]
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: AppColors.greenColor,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          },
          itemCount: vehicles.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        )
      ],
    );
  }
}
