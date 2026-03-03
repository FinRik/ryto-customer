class LocationMarker {
  final String location;
  final String address;
  final String openingHrs;
  final String closingHrs;

  LocationMarker({required this.location, required this.address, required this.openingHrs, required this.closingHrs});

  static List<LocationMarker> points = [
    LocationMarker(location: "Ryto Hub - Yaba", address: "45 Herber Macaulay way, Yaba", openingHrs: "9.00 AM", closingHrs: "6.00 PM"),
    LocationMarker(location: "Ryto Hub - Ikeja", address: "45 Herber Macaulay way, Yaba", openingHrs: "9.00 AM", closingHrs: "6.00 PM"),
    LocationMarker(location: "Ryto Hub - Lekki", address: "45 Herber Macaulay way, Yaba", openingHrs: "9.00 AM", closingHrs: "6.00 PM"),
  ];
  static List<LocationMarker> deliveryRoutes = [
    LocationMarker(location: "Ryto Hub - Yaba", address: "45 Herber Macaulay way, Yaba", openingHrs: "9.00 AM", closingHrs: "6.00 PM"),
    LocationMarker(location: "Ryto Hub - Lekki", address: "45 Herber Macaulay way, Yaba", openingHrs: "9.00 AM", closingHrs: "6.00 PM"),
  ];
}