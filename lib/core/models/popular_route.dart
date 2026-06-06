class PopularRoute {
  final Count count;
  final String originCity;
  final String destinationCity;

  PopularRoute({
    required this.count,
    required this.originCity,
    required this.destinationCity,
  });

  factory PopularRoute.fromJson(Map<String, dynamic> json) {
    return PopularRoute(
      count: Count.fromJson(json['_count']),
      originCity: json['originCity'],
      destinationCity: json['destinationCity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_count': count.toJson(),
      'originCity': originCity,
      'destinationCity': destinationCity,
    };
  }
}

class Count {
  final int id;

  Count({required this.id});

  factory Count.fromJson(Map<String, dynamic> json) {
    return Count(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}