import 'package:flutter/material.dart';
import 'package:taxi/utils/appColors.dart';

class VehicleMake extends StatefulWidget {
  const VehicleMake(
      {super.key, required this.vehicleMaker, required this.onSelected});

  final String vehicleMaker;
  final Function onSelected;

  @override
  State<VehicleMake> createState() => _VehicleMakeState();
}

class _VehicleMakeState extends State<VehicleMake> {
  List vehicleMake = [
    'Honda',
    'GMC',
    'Ford',
    'KIA',
    'Lexus',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'What Make Of Vehicle Is It?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: widget.onSelected(
                vehicleMake[index],
              ),
              visualDensity: const VisualDensity(
                vertical: -4,
              ),
              title: vehicleMake[index],
              trailing: widget.vehicleMaker == vehicleMake[index]
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
        ),
      ],
    );
  }
}
