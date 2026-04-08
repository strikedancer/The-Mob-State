import 'package:json_annotation/json_annotation.dart';

part 'job.g.dart';

@JsonSerializable()
class Job {
  final String id;
  final String name;
  final String? description;

  @JsonKey(name: 'minLevel')
  final int requiredRank;

  @JsonKey(name: 'minEarnings')
  final int minPay;

  @JsonKey(name: 'maxEarnings')
  final int maxPay;

  final int xpReward;
  final int? cooldownMinutes;
  final String? image;

  Job({
    required this.id,
    required this.name,
    this.description,
    required this.requiredRank,
    required this.minPay,
    required this.maxPay,
    required this.xpReward,
    this.cooldownMinutes,
    this.image,
  });

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJson() => _$JobToJson(this);
}
