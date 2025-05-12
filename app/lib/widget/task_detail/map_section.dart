import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app/model/location.dart'; // your Location model
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class LocationSection extends StatelessWidget {
  final Location? location;

  const LocationSection({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (location == null) {
      return SizedBox.shrink(); // no location = show nothing
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          'location'.tr(),
          style: GoogleFonts.figtree(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: location!.type == 'remote'
              ? Row(
                  children: [
                    Icon(FluentIcons.phone_laptop_20_filled, color: Colors.teal),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'remoteTaskDescription'.tr(),
                        style: GoogleFonts.figtree(fontSize: 14),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(FluentIcons.location_20_filled, color: Colors.teal),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            location?.address ?? 'unknownAddress',
                            style: GoogleFonts.figtree(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 200,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              location?.lat ?? 0.0,
                              location?.lng ?? 0.0,
                            ),
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId('task-location'),
                              position: LatLng(
                                location?.lat ?? 0.0,
                                location?.lng ?? 0.0,
                              ),
                            ),
                          },
                          zoomControlsEnabled: false,
                          liteModeEnabled: true, // faster lightweight map
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
