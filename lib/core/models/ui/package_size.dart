import '../../../app/res/icons.dart';

class PackageSize {
  final String id;
  final String title;
  final String catDesc;
  final String? errorDesc;
  // final String? dispPrice;
  // final int? cost;

  PackageSize({
    required this.id,
    required this.title,
    required this.catDesc,
    this.errorDesc,
    // this.dispPrice,
    // this.cost,
  });

  static List<PackageSize> packageSizes = [
    PackageSize(
      id: "SMALL",
      title: "Small Bag",
      catDesc: "Fits in a hand Up to 20cm",
      // dispPrice: "₦2,500",
      // cost: 2500,
    ),
    PackageSize(
      id: "MEDIUM",
      title: "Medium",
      catDesc: "Shoebox Size 20-40cm",
      // dispPrice: "₦4,500",
      // cost: 4500,
    ),
    PackageSize(
      id: "LARGE",
      title: "Large",
      catDesc: "Backpack Size 40-60cm",
      // dispPrice: "₦7,500",
      // cost: 7500,
    ),
    PackageSize(
      id: "EXTRA_LARGE",
      title: "Extra Large",
      catDesc: "Suitcase size 60cm+",
      // dispPrice: "₦12,500",
      // cost: 12500,
    ),
  ];
  static List<PackageSize> luggageSizes = [
    PackageSize(
      id: "SMALL",
      title: "Small Bag",
      catDesc: "Backpack or Laptop bag",
    ),
    PackageSize(
      id: "MEDIUM",
      title: "Medium Bag",
      catDesc: "Backpack or Laptop bag",
    ),
    PackageSize(
      id: "LARGE",
      title: "Large Bag",
      catDesc: "Backpack or Laptop bag",
      errorDesc: "Too Large for trunk",
    ),
  ];
}

class PackageDetails {
  final String title;
  final String icon;
  final String id;

  PackageDetails({required this.id, required this.title, required this.icon});

  static List<PackageDetails> packageSizes = [
    PackageDetails(id: "DOCUMENTS",title: "Documents", icon: AppIcons.documentText),
    PackageDetails(id: "CLOTHING",title: "Clothing", icon: AppIcons.clothing),
    PackageDetails(id: "ELECTRONICS",title: "Electronics", icon: AppIcons.electronics),
    PackageDetails(id: "GIFT",title: "Gift", icon: AppIcons.giftOutlined),
    PackageDetails(id: "OTHER",title: "Other", icon: AppIcons.boxOutlined),
  ];
}
