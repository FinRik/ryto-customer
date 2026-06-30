import '../../../app/res/icons.dart';

class PackageSize {
  final String id;
  final String name;
  final String title;
  final String icon;

  final String? catDesc;
  final String? errorDesc;
  // final String? dispPrice;
  // final int? cost;

  const PackageSize({
    required this.id,
    required this.name,
    required this.title,
    required this.icon,

    this.catDesc,
    this.errorDesc,
    // this.dispPrice,
    // this.cost,
  });


}

class PackageDetails {
  static const List<PackageSize> luggageSizes = [
    PackageSize(id: "none", name: "None", title: "No Package", catDesc: "No Package or baggage", icon: "assets/svgs/none.svg"),
    PackageSize(id: "small", name: "SMALL", title: "Small Bag", catDesc: "Fits in a hand Up to 20cm", icon: "assets/svgs/small.svg"),
    PackageSize(id: "medium", name: "MEDIUM", title: "Medium Box", catDesc: "Shoebox Size 20-40cm", icon: "assets/svgs/medium.svg"),
    PackageSize(id: "large", name: "LARGE", title: "Large/Heavy Cargo", catDesc: "Backpack Size 40-60cm", icon: "assets/svgs/large.svg"),
    PackageSize(id: "extra_large", name: "LARGE", title: "Extra Large", catDesc: "Suitcase size 60cm+", icon: "assets/svgs/extra_large"),
  ];

  static List<PackageSize> packageSizes = [
    PackageSize(id: "small", name: "SMALL", title: "Small Bag", catDesc: "Fits in a hand Up to 20cm", icon: "assets/svgs/small.svg"),
    PackageSize(id: "medium", name: "MEDIUM", title: "Medium Box", catDesc: "Shoebox Size 20-40cm", icon: "assets/svgs/medium.svg"),
    PackageSize(id: "large", name: "LARGE", title: "Large/Heavy Cargo", catDesc: "Backpack Size 40-60cm", icon: "assets/svgs/large.svg",),
    PackageSize(id: "extra_large", name: "LARGE", title: "Extra Large", catDesc: "Suitcase size 60cm+", icon: "assets/svgs/extra_large"),
  ];

  static List<PackageSize> packageContents = [
    PackageSize(id: "documents", name: "DOCUMENTS", title: "Documents", icon: AppIcons.documentText),
    PackageSize(id: "clothing", name: "CLOTHING", title: "Clothing", icon: AppIcons.clothing),
    PackageSize(id: "electronics", name: "ELECTRONICS", title: "Electronics", icon: AppIcons.electronics),
    PackageSize(id: "gift", name: "GIFT", title: "Gift", icon: AppIcons.giftOutlined),
    PackageSize(id: "other", name: "OTHER", title: "Other", icon: AppIcons.boxOutlined),
  ];
}
