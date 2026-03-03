
import '../../../app/res/icons.dart';

class PackageSizeModel {
  final String catTitle;
  final String catDesc;
  final String? errorDesc;
  final String? dispPrice;
  final int? cost;

  PackageSizeModel({required this.catTitle, required this.catDesc, this.errorDesc, this.dispPrice, this.cost});

  static List<PackageSizeModel> packageSizes = [
    PackageSizeModel(catTitle: "Small Bag", catDesc: "Fits in a hand Up to 20cm", dispPrice: "₦2,500", cost: 2500),
    PackageSizeModel(catTitle: "Medium", catDesc: "Shoebox Size 20-40cm", dispPrice: "₦4,500", cost: 4500),
    PackageSizeModel(catTitle: "Large", catDesc: "Backpack Size 40-60cm", dispPrice: "₦7,500", cost: 7500),
    PackageSizeModel(catTitle: "Extra Large", catDesc: "Suitcase size 60cm+", dispPrice: "₦12,500", cost: 12500),
  ];
  static List<PackageSizeModel> luggageSizes = [
    PackageSizeModel(catTitle: "Small Bag", catDesc: "Backpack or Laptop bag",),
    PackageSizeModel(catTitle: "Small Bag", catDesc: "Backpack or Laptop bag",),
    PackageSizeModel(catTitle: "Medium Bag", catDesc: "Backpack or Laptop bag",),
    PackageSizeModel(catTitle: "Large Bag", catDesc: "Backpack or Laptop bag", errorDesc: "Too Large for trunk"),
  ];
}

class PackageDetails {
  final String title;
  final String icon;

  PackageDetails({required this.title, required this.icon});

  static List<PackageDetails> packageSizes = [
    PackageDetails(title: "Documents", icon: AppIcons.documentText),
    PackageDetails(title: "Clothing", icon: AppIcons.clothing),
    PackageDetails(title: "Electronics", icon: AppIcons.electronics),
    PackageDetails(title: "Gift", icon: AppIcons.giftOutlined),
    PackageDetails(title: "Other", icon: AppIcons.boxOutlined),
  ];
}