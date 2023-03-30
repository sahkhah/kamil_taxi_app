import 'package:flutter/material.dart';

import '../../../../utils/appColors.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key, required this.selectedLocation, required this.onSelect});

  final String selectedLocation;
  final Function onSelect;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<String> locations = ['Pakistan', 'Japan', 'China', 'India'];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'What Service Location Do You Want to Register?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: widget.onSelect(locations[index]),
              //removes the space between every list tile
              visualDensity: const VisualDensity(vertical: -4),
              title: Text(locations[index]),
              trailing: widget.selectedLocation == locations[index]
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
          itemCount: locations.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        )
      ],
    );
  }
}
