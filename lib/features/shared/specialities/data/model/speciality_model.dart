import 'package:equatable/equatable.dart';

class SpecialityModel extends Equatable {
  final int idx;
  final String id;
  final String name;
  final String icon;

  const SpecialityModel({
    required this.idx,
    required this.id,
    required this.name,
    required this.icon,
  });

  factory SpecialityModel.fromJson(Map<String, dynamic> json) {
    return SpecialityModel(
      idx: json['idx'] as int? ?? 0,
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  @override
  List<Object?> get props => [idx, id, name, icon];
}
