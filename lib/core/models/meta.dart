import 'package:json_annotation/json_annotation.dart';

part 'meta.g.dart';

@JsonSerializable()
class Meta {
  final int currentPage;
  final int perPage;
  final int? skip;
  final int? lastPage;
  final int? nextPage;
  final int? prevPage;
  final int? from;
  final int? to;

  Meta({
    required this.currentPage,
    required this.perPage,
    this.skip,
    this.lastPage,
    this.nextPage,
    this.prevPage,
    this.from,
    this.to,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}