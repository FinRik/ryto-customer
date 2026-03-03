class TripItemModel {
  final String title;
  final double rating;
  final bool isVerified;
  final String avatarText;

  const TripItemModel({
    required this.title,
    required this.rating,
    required this.isVerified,
    required this.avatarText,
  });

  static final List<TripItemModel> trips = [
    TripItemModel(
      title: "David Peterson",
      rating: 4.8,
      isVerified: true,
      avatarText: "DP",
    ),
    TripItemModel(
      title: "Chidi O.",
      rating: 4.8,
      isVerified: true,
      avatarText: "CO",
    ),
    TripItemModel(
      title: "Chidi O.",
      rating: 4.8,
      isVerified: true,
      avatarText: "CO",
    ),
  ];

  static final driverDetail = const TripItemModel(
  title: "Chidi .O",
  rating: 4.6,
  isVerified: true,
  avatarText: "CO",
  );
}