// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
  currentPage: (json['currentPage'] as num).toInt(),
  perPage: (json['perPage'] as num).toInt(),
  skip: (json['skip'] as num?)?.toInt(),
  lastPage: (json['lastPage'] as num?)?.toInt(),
  nextPage: (json['nextPage'] as num?)?.toInt(),
  prevPage: (json['prevPage'] as num?)?.toInt(),
  from: (json['from'] as num?)?.toInt(),
  to: (json['to'] as num?)?.toInt(),
);

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'currentPage': instance.currentPage,
  'perPage': instance.perPage,
  'skip': instance.skip,
  'lastPage': instance.lastPage,
  'nextPage': instance.nextPage,
  'prevPage': instance.prevPage,
  'from': instance.from,
  'to': instance.to,
};
