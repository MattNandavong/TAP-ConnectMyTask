import 'package:app/model/user.dart';
import 'package:app/utils/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:country_picker/country_picker.dart';

class LocationInput extends StatefulWidget {
  final void Function(String address, double lat, double lng) onPlaceSelected;

  const LocationInput({required this.onPlaceSelected, super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  final TextEditingController _controller = TextEditingController();
  String? _countryCode = 'au'; // default fallback

  @override
  void initState() {
    super.initState();
    _loadUserCountryCode();
  }

  Future<void> _loadUserCountryCode() async {
    try {
      final user = await AuthService().getCurrentUser(); // Await if async
      final countryName = user!.location?['country'];
      final code = getCountryCodeFromName(countryName ?? '');

      setState(() {
        _countryCode = code ?? 'au';
      });
    } catch (e) {
      print('Failed to load user or country code: $e');
    }
  }

  String? getCountryCodeFromName(String countryName) {
    final match = Country.tryParse(countryName);
    return match?.countryCode.toLowerCase(); // returns 'au', 'th', etc.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: _controller,
        googleAPIKey: "AIzaSyCw5oCey7i_yWvKuJVQ-apK_xenWUqgsUY",
        inputDecoration: InputDecoration(
          hintText: "Enter Location",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        boxDecoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        debounceTime: 800,
        countries: _countryCode != null ? [_countryCode!] : null,
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          final address = prediction.description ?? "";
          final lat = double.tryParse(prediction.lat ?? "") ?? 0.0;
          final lng = double.tryParse(prediction.lng ?? "") ?? 0.0;
          widget.onPlaceSelected(address, lat, lng);
        },
        itemClick: (Prediction prediction) {
          _controller.text = prediction.description ?? "";
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        },
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                SizedBox(width: 7),
                Expanded(
                  child: Text(
                    prediction.description ?? "",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        seperatedBuilder: Divider(height: 0, indent: 15, endIndent: 15),
        isCrossBtnShown: true,
        containerHorizontalPadding: 10,
      ),
    );
  }
}
