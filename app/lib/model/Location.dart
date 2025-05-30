/// ---------------------------------------------------------------------------
/// File: location.dart
/// Description: Defines the Location model used to represent the location
/// details of a task, supporting both remote and physical locations with
/// optional geocoordinates.
/// Author: [Your Name]
/// Created: [Date]
/// ---------------------------------------------------------------------------

/// A model representing the location of a task.
/// It supports both remote and physical types.
class Location {
  final String type; // 'remote' or 'physical'
  final String? address; 
  final double? lat; 
  final double? lng; 

  /// Constructs a [Location] instance.
  Location({
    required this.type,
    this.address,
    this.lat,
    this.lng,
  });

  /// Factory constructor to create a [Location] instance from JSON.
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      address: json['address'],
      lat: (json['lat'] != null) ? (json['lat'] as num).toDouble() : null,
      lng: (json['lng'] != null) ? (json['lng'] as num).toDouble() : null,
    );
  }

  /// Converts the [Location] instance into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (address != null) 'address': address,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    };
  }

  /// Returns a readable string representation of the location.
  @override
  String toString() {
    if (type == 'remote') return 'Remote Task';
    return '$address';
  }
}
